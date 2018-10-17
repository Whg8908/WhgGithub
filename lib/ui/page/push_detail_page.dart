import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github/common/bean/PushCommit.dart';
import 'package:github/common/dao/repos_dao.dart';
import 'package:github/common/net/address.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/common/utils/commonutils.dart';
import 'package:github/common/utils/htmlutils.dart';
import 'package:github/common/utils/navigatorutils.dart';
import 'package:github/common/viewmodel/push_code_item_view_model.dart';
import 'package:github/common/viewmodel/push_header_view_model.dart';
import 'package:github/ui/base/whg_list_state.dart';
import 'package:github/ui/view/push_code_item.dart';
import 'package:github/ui/view/push_header.dart';
import 'package:github/ui/view/whg_common_option_widget.dart';
import 'package:github/ui/view/whg_pullload_widget.dart';
import 'package:github/ui/view/whg_title_bar.dart';
/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/9/13
 *
 * @Description PushDetailPage
 *
 * PS: Stay hungry,Stay foolish.
 */

class PushDetailPage extends StatefulWidget {
  final String userName;

  final String reposName;

  final String sha;

  final bool needHomeIcon;

  PushDetailPage(this.sha, this.userName, this.reposName,
      {this.needHomeIcon = false});

  @override
  PushDetailPageState createState() => new PushDetailPageState(
      this.userName, this.reposName, this.sha, this.needHomeIcon);
}

class PushDetailPageState extends State<PushDetailPage>
    with
        AutomaticKeepAliveClientMixin<PushDetailPage>,
        WhgListState<PushDetailPage> {
  final String userName;

  final String reposName;

  final String sha;

  bool needHomeIcon = false;

  @override
  bool get isRefreshFirst => true;

  @override
  bool get needHeader => true;

  PushDetailPageState(
      this.userName, this.reposName, this.sha, this.needHomeIcon);

  PushHeaderViewModel pushHeaderViewModel = new PushHeaderViewModel();

  @override
  Future<Null> handleRefresh() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page = 1;
    var res = await _getDataLogic();
    if (res != null && res.result) {
      PushCommit pushCommit = res.data;
      pullLoadWidgetControl.dataList.clear();
      if (isShow) {
        setState(() {
          pushHeaderViewModel = PushHeaderViewModel.forMap(pushCommit);
          pullLoadWidgetControl.dataList.addAll(pushCommit.files);
          pullLoadWidgetControl.needLoadMore = false;
        });
      }
    }
    isLoading = false;
    return null;
  }

  _renderEventItem(index) {
    if (index == 0) {
      return new PushHeader(pushHeaderViewModel);
    }
    PushCodeItemViewModel itemViewModel = PushCodeItemViewModel.fromMap(
        pullLoadWidgetControl.dataList[index - 1]);
    return new PushCodeItem(itemViewModel, () {
      if (Platform.isIOS) {
        NavigatorUtils.gotoCodeDetailPage(
          context,
          title: itemViewModel.name,
          userName: userName,
          reposName: reposName,
          data: itemViewModel.patch,
          htmlUrl: itemViewModel.blob_url,
        );
      } else {
        String html = HtmlUtils.generateCode2HTml(
            HtmlUtils.parseDiffSource(itemViewModel.patch, false),
            backgroundColor: WhgColors.webDraculaBackgroundColorString,
            lang: '',
            userBR: false);
        CommonUtils.launchWebView(context, itemViewModel.name, html);
      }
    });
  }

  _getDataLogic() async {
    return await ReposDao.getReposCommitsInfoDao(userName, reposName, sha);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  requestRefresh() async {}

  @override
  requestLoadMore() async {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.
    String url =
        Address.hostWeb + userName + "/" + reposName + "/commits/" + sha;
    Widget widget = (needHomeIcon) ? null : new WhgCommonOptionWidget(url);
    return new Scaffold(
      appBar: new AppBar(
        title: WhgTitleBar(
          reposName,
          rightWidget: widget,
          needRightLocalIcon: needHomeIcon,
          iconData: WhgICons.HOME,
          onPressed: () {
            NavigatorUtils.goReposDetail(context, userName, reposName);
          },
        ),
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
