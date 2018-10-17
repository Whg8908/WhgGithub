import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:github/common/bean/Notification.dart' as Model;
import 'package:github/common/dao/user_dao.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/common/utils/commonutils.dart';
import 'package:github/common/utils/navigatorutils.dart';
import 'package:github/common/viewmodel/event_view_model.dart';
import 'package:github/ui/base/whg_list_state.dart';
import 'package:github/ui/view/event_item.dart';
import 'package:github/ui/view/repository_issue_list_header.dart';
import 'package:github/ui/view/whg_pullload_widget.dart';
import 'package:github/ui/view/whg_title_bar.dart';

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

class NotifyPageState extends State<NotifyPage>
    with AutomaticKeepAliveClientMixin<NotifyPage>, WhgListState<NotifyPage> {
  final SlidableController slidableController = new SlidableController();

  int selectIndex;

  _renderItem(index) {
    Model.Notification notification = pullLoadWidgetControl.dataList[index];
    if (selectIndex != 0) {
      return _renderEventItem(notification);
    }
    return new Slidable(
      controller: slidableController,
      delegate: new SlidableDrawerDelegate(),
      actionExtentRatio: 0.25,
      child: _renderEventItem(notification),
      secondaryActions: <Widget>[
        new IconSlideAction(
          caption: CommonUtils.getLocale(context).notify_readed,
          color: Colors.redAccent,
          icon: Icons.delete,
          onTap: () {
            UserDao.setNotificationAsReadDao(notification.id.toString())
                .then((res) {
              showRefreshLoading();
            });
          },
        ),
      ],
    );
  }

  _renderEventItem(Model.Notification notification) {
    EventViewModel eventViewModel =
        EventViewModel.fromNotify(context, notification);
    return new EventItem(eventViewModel, onPressed: () {
      if (notification.unread) {
        UserDao.setNotificationAsReadDao(notification.id.toString());
      }
      if (notification.subject.type == 'Issue') {
        String url = notification.subject.url;
        List<String> tmp = url.split("/");
        String number = tmp[tmp.length - 1];
        String userName = notification.repository.owner.login;
        String reposName = notification.repository.name;
        NavigatorUtils.goIssueDetail(context, userName, reposName, number,
                needRightLocalIcon: true)
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
          CommonUtils.getLocale(context).notify_title,
          iconData: WhgICons.NOTIFY_ALL_READ,
          needRightLocalIcon: true,
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
            CommonUtils.getLocale(context).notify_tab_unread,
            CommonUtils.getLocale(context).notify_tab_part,
            CommonUtils.getLocale(context).notify_tab_all,
          ],
          (selectIndex) {
            this.selectIndex = selectIndex;
            _resolveSelectIndex();
          },
          height: 30.0,
          elevation: 0.0,
          margin: const EdgeInsets.all(0.0),
        ),
        elevation: 4.0,
      ),
      body: WhgPullLoadWidget(
        (BuildContext context, int index) => _renderItem(index),
        handleRefresh,
        onLoadMore,
        pullLoadWidgetControl,
        refreshKey: refreshIndicatorKey,
      ),
    );
  }
}
