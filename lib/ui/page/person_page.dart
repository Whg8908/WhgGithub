import 'package:flutter/material.dart';
import 'package:whg_github/common/bean/User.dart';
import 'package:whg_github/common/dao/event_dao.dart';
import 'package:whg_github/common/dao/repos_dao.dart';
import 'package:whg_github/common/dao/user_dao.dart';
import 'package:whg_github/ui/base/whg_list_state.dart';
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

class PersonPageState extends WhgListState<PersonPage> {
  final String userName;
  User userInfo = User.empty();

  String beStaredCount = "---";

  PersonPageState(this.userName);

  @override
  bool get isRefreshFirst => false;

  @override
  bool get wantKeepAlive => true;

  @override
  bool get needHeader => true;

  @override
  void initState() {
    pullLoadWidgetControl.needHeader = true;
    super.initState();
  }

  @override
  requestLoadMore() async {
    return await EventDao.getEventDao(_getUserName(), page: page);
  }

  @override
  requestRefresh() async {
    ReposDao.getUserRepository100StatusDao(_getUserName()).then((res) {
      if (res != null && res.result) {
        setState(() {
          beStaredCount = res.data.toString();
        });
      }
    });

    var userResult = await UserDao.getUserInfo(userName);
    if (userResult != null && userResult.result) {
      setState(() {
        userInfo = userResult.data;
      });
    } else {
      return null;
    }

    return await EventDao.getEventDao(_getUserName(), page: page);
  }

  _renderEventItem(index) {
    if (index == 0) {
      return new UserHeaderItem(userInfo, beStaredCount);
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
          handleRefresh,
          onLoadMore,
          pullLoadWidgetControl,
          refreshKey: refreshIndicatorKey,
        ));
  }
}
