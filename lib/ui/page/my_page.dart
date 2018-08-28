import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:whg_github/common/config/config.dart';
import 'package:whg_github/common/dao/event_dao.dart';
import 'package:whg_github/common/redux/whg_state.dart';
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

class MyPageState extends State<MyPage> with AutomaticKeepAliveClientMixin {
  bool isLoading = false;

  int page = 1;

  final List dataList = new List();

  final WhgPullLoadWidgetControl pullLoadWidgetControl =
      WhgPullLoadWidgetControl();

  Future<Null> _handleRefresh() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page = 1;

    var result = await EventDao.getEventDao(_getUserName(), page: page);
    //刷新item
    if (result != null && result.length > 0) {
      pullLoadWidgetControl.dataList.clear();
      setState(() {
        pullLoadWidgetControl.dataList.addAll(result);
      });
    }
    //更新是否能加载更多
    setState(() {
      pullLoadWidgetControl.needLoadMore =
          (result != null && result.length == Config.PAGE_SIZE);
    });
    isLoading = false;

    return null;
  }

  Future<Null> _onLoadMore() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page++;
    var result = await EventDao.getEventDao(_getUserName(), page: page);
    if (result != null && result.length > 0) {
      setState(() {
        pullLoadWidgetControl.dataList.addAll(result);
      });
    }
    setState(() {
      pullLoadWidgetControl.needLoadMore = (result != null);
    });
    isLoading = false;
    return null;
  }

  _renderEventItem(userInfo, index) {
    if (index == 0) {
      return new UserHeaderItem(userInfo);
    }
    return new EventItem(pullLoadWidgetControl.dataList[index - 1]);
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
  bool get wantKeepAlive => true;

  @override
  void initState() {
    pullLoadWidgetControl.needHeader = true;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<WhgState>(
      builder: (context, store) {
        return WhgPullLoadWidget(
            (BuildContext context, int index) =>
                _renderEventItem(store.state.userInfo, index),
            _handleRefresh,
            _onLoadMore,
            pullLoadWidgetControl);
      },
    );
  }
}
