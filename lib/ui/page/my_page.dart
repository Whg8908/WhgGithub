import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:whg_github/common/bean/event_view_model.dart';
import 'package:whg_github/common/dao/event_dao.dart';
import 'package:whg_github/common/dao/repos_dao.dart';
import 'package:whg_github/common/redux/whg_state.dart';
import 'package:whg_github/common/utils/eventutils.dart';
import 'package:whg_github/ui/base/whg_list_state.dart';
import 'package:whg_github/ui/view/event_item.dart';
import 'package:whg_github/ui/view/user_header_item.dart';
import 'package:whg_github/ui/view/whg_pullload_widget.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/22
 *
 * @Description  我的页面
 *
 * PS: Stay hungry,Stay foolish.
 */

class MyPage extends StatefulWidget {
  @override
  MyPageState createState() => MyPageState();
}

class MyPageState extends WhgListState<MyPage> {
  String beSharedCount = '---';

  @override
  requestRefresh() async {
    ReposDao.getUserRepository100StatusDao(_getUserName()).then((res) {
      if (res != null && res.result) {
        setState(() {
          beSharedCount = res.data;
        });
      }
    });

    return await EventDao.getEventDao(_getUserName(), page: page);
  }

  @override
  requestLoadMore() async {
    return await EventDao.getEventDao(_getUserName(), page: page);
  }

  @override
  bool get isRefreshFirst => false;

  @override
  bool get needHeader => true;

  _renderEventItem(userInfo, index) {
    if (index == 0) {
      return new UserHeaderItem(userInfo, beSharedCount);
    }

    EventViewModel eventViewModel = pullLoadWidgetControl.dataList[index - 1];

    return new EventItem(
      eventViewModel,
      onPressed: () {
        EventUtils.ActionUtils(context, eventViewModel.eventMap, "");
      },
    );
  }

  _getUserName() {
    if (_getStore().state.userInfo == null) {
      return null;
    }
    return _getStore().state.userInfo.login;
  }

  Store<WhgState> _getStore() {
    return StoreProvider.of(context);
  }

  @override
  List get getDataList => super.getDataList;

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.
    return StoreBuilder<WhgState>(
      builder: (context, store) {
        return WhgPullLoadWidget(
          (BuildContext context, int index) =>
              _renderEventItem(store.state.userInfo, index),
          handleRefresh,
          onLoadMore,
          pullLoadWidgetControl,
          refreshKey: refreshIndicatorKey,
        );
      },
    );
  }
}
