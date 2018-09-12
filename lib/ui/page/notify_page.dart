import 'package:flutter/material.dart';
import 'package:whg_github/common/bean/event_view_model.dart';
import 'package:whg_github/common/dao/user_dao.dart';
import 'package:whg_github/common/style/whg_style.dart';
import 'package:whg_github/common/utils/commonutils.dart';
import 'package:whg_github/common/utils/navigatorutils.dart';
import 'package:whg_github/ui/base/whg_list_state.dart';
import 'package:whg_github/ui/view/event_item.dart';
import 'package:whg_github/ui/view/repository_issue_list_header.dart';
import 'package:whg_github/ui/view/whg_pullload_widget.dart';
import 'package:whg_github/ui/view/whg_title_bar.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/9/8
 *
 * @Description   NotifyPage
 *
 * PS: Stay hungry,Stay foolish.
 */

class NotifyPage extends StatefulWidget {
  @override
  NotifyPageState createState() => new NotifyPageState();
}

class NotifyPageState extends WhgListState<NotifyPage> {
  int selectIndex;

  _renderEventItem(index) {
    EventViewModel eventViewModel = pullLoadWidgetControl.dataList[index];
    return new EventItem(eventViewModel, onPressed: () {
      var eventMap = eventViewModel.eventMap;
      if (eventMap["unread"]) {
        UserDao.setNotificationAsReadDao(eventMap["id"].toString());
      }
      print(eventMap["id"]);
      if (eventMap["subject"]["type"] == 'Issue') {
        String url = eventMap["subject"]["url"];
        List<String> tmp = url.split("/");
        String number = tmp[tmp.length - 1];
        String userName = eventMap["repository"]["owner"]["login"];
        String reposName = eventMap["repository"]["name"];
        NavigatorUtils.goIssueDetail(context, userName, reposName, number,
                needRightIcon: true)
            .then((res) {
          showRefreshLoading();
        });
      }
    }, needImage: false);
  }

  _resolveSelectIndex() {
    clearData();
    showRefreshLoading();
  }

  _getDataLogic() async {
    return await UserDao.getNotifyDao(selectIndex == 2, selectIndex == 1, page);
  }

  @override
  bool get wantKeepAlive => true;

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

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.
    return new Scaffold(
      backgroundColor: Color(WhgColors.mainBackgroundColor),
      appBar: new AppBar(
        title: WhgTitleBar(
          WhgStrings.notify_title,
          iconData: WhgICons.NOTIFY_ALL_READ,
          needRightIcon: true,
          onPressed: () {
            CommonUtils.showLoadingDialog(context);
            UserDao.setAllNotificationAsReadDao().then((res) {
              Navigator.pop(context);
              _resolveSelectIndex();
            });
          },
        ),
        bottom: new WhgSelectItemWidget(
          [
            WhgStrings.notify_tab_unread,
            WhgStrings.notify_tab_part,
            WhgStrings.notify_tab_all,
          ],
          (selectIndex) {
            this.selectIndex = selectIndex;
            _resolveSelectIndex();
          },
          elevation: 0.0,
          margin: const EdgeInsets.all(0.0),
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
