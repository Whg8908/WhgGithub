import 'dart:io';

import 'package:flutter/material.dart';
import 'package:github/common/dao/repos_dao.dart';
import 'package:github/common/net/address.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/common/utils/commonutils.dart';
import 'package:github/common/utils/fluttertoast.dart';
import 'package:github/common/utils/htmlutils.dart';
import 'package:github/common/utils/navigatorutils.dart';
import 'package:github/common/viewmodel/release_view_model.dart';
import 'package:github/ui/base/whg_list_state.dart';
import 'package:github/ui/view/release_item.dart';
import 'package:github/ui/view/repository_issue_list_header.dart';
import 'package:github/ui/view/whg_common_option_widget.dart';
import 'package:github/ui/view/whg_pullload_widget.dart';
import 'package:github/ui/view/whg_title_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class ReleasePage extends StatefulWidget {
  final String userName;

  final String reposName;

  ReleasePage(this.userName, this.reposName);

  @override
  _ReleasePageState createState() =>
      _ReleasePageState(this.userName, this.reposName);
}

// ignore: mixin_inherits_from_not_object
class _ReleasePageState extends WhgListState<ReleasePage> {
  final String userName;

  final String reposName;

  int selectIndex;

  _ReleasePageState(this.userName, this.reposName);

  _renderEventItem(index) {
    ReleaseItemViewModel releaseItemViewModel =
        ReleaseItemViewModel.fromMap(pullLoadWidgetControl.dataList[index]);
    return new ReleaseItem(
      releaseItemViewModel,
      onPressed: () {
        if (selectIndex == 0) {
          if (Platform.isIOS) {
            NavigatorUtils.gotoCodeDetailPage(
              context,
              title: releaseItemViewModel.actionTitle,
              userName: userName,
              reposName: reposName,
              data: HtmlUtils.generateHtml(
                  releaseItemViewModel.actionTargetHtml,
                  backgroundColor: WhgColors.webDraculaBackgroundColorString),
            );
          } else {
            String html = HtmlUtils.generateHtml(
                releaseItemViewModel.actionTargetHtml,
                backgroundColor: WhgColors.miWhiteString,
                userBR: false);
            CommonUtils.launchWebView(
                context, releaseItemViewModel.actionTitle, html);
          }
        }
      },
      onLongPress: () {
        _launchURL();
      },
    );
  }

  _launchURL() async {
    String url = _getUrl();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(
          msg: WhgStrings.option_web_launcher_error + ": " + url);
    }
  }

  _resolveSelectIndex() {
    clearData();
    showRefreshLoading();
  }

  _getDataLogic() async {
    return await ReposDao.getRepositoryReleaseDao(userName, reposName, page,
        needHtml: false, release: selectIndex == 0);
  }

  @override
  bool get wantKeepAlive => false;

  @override
  bool get needHeader => false;

  @override
  bool get isRefreshFirst => true;

  @override
  requestLoadMore() async {
    return await _getDataLogic();
  }

  @override
  requestRefresh() async {
    return await _getDataLogic();
  }

  _getUrl() {
    return selectIndex == 0
        ? Address.hostWeb + userName + "/" + reposName + "/releases"
        : Address.hostWeb + userName + "/" + reposName + "/tags";
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.
    String url = _getUrl();
    return new Scaffold(
      backgroundColor: Color(WhgColors.mainBackgroundColor),
      appBar: new AppBar(
        title: WhgTitleBar(
          reposName,
          rightWidget: new WhgCommonOptionWidget(url),
        ),
        bottom: new WhgSelectItemWidget(
          [
            WhgStrings.release_tab_release,
            WhgStrings.release_tab_tag,
          ],
          (selectIndex) {
            this.selectIndex = selectIndex;
            _resolveSelectIndex();
          },
          height: 30.0,
          margin: const EdgeInsets.all(0.0),
          elevation: 0.0,
        ),
        elevation: 4.0,
      ),
      body: WhgPullLoadWidget(
        (BuildContext context, int index) => _renderEventItem(index),
        handleRefresh,
        onLoadMore,
        pullLoadWidgetControl,
        refreshKey: refreshIndicatorKey,
      ),
    );
  }
}
