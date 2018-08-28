import 'dart:async';

import 'package:flutter/material.dart';
import 'package:whg_github/common/bean/User.dart';
import 'package:whg_github/common/config/config.dart';
import 'package:whg_github/common/dao/event_dao.dart';
import 'package:whg_github/common/dao/user_dao.dart';
import 'package:whg_github/ui/view/event_item.dart';
import 'package:whg_github/ui/view/user_header_item.dart';
import 'package:whg_github/ui/view/whg_pullload_widget.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/23
 *
 * @Description PersonPage个人页面
 *
 * PS: Stay hungry,Stay foolish.
 */

class PersonPage extends StatefulWidget {
  static final String sName = "person";

  final String userName;

  PersonPage(this.userName, {Key key}) : super(key: key);

  @override
  PersonPageState createState() => PersonPageState(userName);
}

class PersonPageState extends State<PersonPage>
    with AutomaticKeepAliveClientMixin {
  final String userName;
  User userInfo = User.empty();

  bool isLoading = false;

  int page = 1;

  final List dataList = new List();

  final WhgPullLoadWidgetControl pullLoadWidgetControl =
      new WhgPullLoadWidgetControl();

  PersonPageState(this.userName);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    pullLoadWidgetControl.needHeader = true;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    pullLoadWidgetControl.dataList = dataList;
    if (pullLoadWidgetControl.dataList.length == 0) {
      _handleRefresh();
    }
    super.didChangeDependencies();
  }

  Future<Null> _handleRefresh() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page = 1;
    var userResult = await UserDao.getUserInfo(userName);
    if (userResult != null && userResult.result) {
      setState(() {
        userInfo = userResult.data;
      });
    } else {
      return null;
    }

    var result = await EventDao.getEventDao(_getUserName(), page: page);
    if (result != null && result.length > 0) {
      pullLoadWidgetControl.dataList.clear();
      setState(() {
        pullLoadWidgetControl.dataList.addAll(result);
      });
    }
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

  _renderEventItem(index) {
    if (index == 0) {
      return new UserHeaderItem(userInfo);
    }
    return new EventItem(pullLoadWidgetControl.dataList[index - 1]);
  }

  _getUserName() {
    if (userInfo == null) {
      return new User.empty();
    }
    return userInfo.login;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text((userInfo != null && userInfo.login != null)
              ? userInfo.login
              : ""),
        ),
        body: WhgPullLoadWidget(
            (BuildContext context, int index) => _renderEventItem(index),
            _handleRefresh,
            _onLoadMore,
            pullLoadWidgetControl));
  }
}
