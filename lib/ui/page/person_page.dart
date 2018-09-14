import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:whg_github/common/bean/User.dart';
import 'package:whg_github/common/dao/event_dao.dart';
import 'package:whg_github/common/dao/repos_dao.dart';
import 'package:whg_github/common/dao/user_dao.dart';
import 'package:whg_github/common/net/address.dart';
import 'package:whg_github/common/style/whg_style.dart';
import 'package:whg_github/common/utils/commonutils.dart';
import 'package:whg_github/common/utils/eventutils.dart';
import 'package:whg_github/common/utils/navigatorutils.dart';
import 'package:whg_github/ui/base/whg_list_state.dart';
import 'package:whg_github/ui/view/event_item.dart';
import 'package:whg_github/ui/view/user_header_item.dart';
import 'package:whg_github/ui/view/user_item.dart';
import 'package:whg_github/ui/view/whg_common_option_widget.dart';
import 'package:whg_github/ui/view/whg_pullload_widget.dart';
import 'package:whg_github/ui/view/whg_title_bar.dart';

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

  bool focusStatus = false;

  String focus = "";

  String launchUrl = "";

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
    return await _getDataLogic();
  }

  @override
  Future<Null> handleRefresh() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page = 1;
    var userResult = await UserDao.getUserInfo(userName);
    if (userResult != null && userResult.result) {
      userInfo = userResult.data;
      setState(() {
        userInfo = userResult.data;
      });
    } else {
      return null;
    }
    var res = await _getDataLogic();
    if (res != null && res.result) {
      pullLoadWidgetControl.dataList.clear();
      setState(() {
        pullLoadWidgetControl.dataList.addAll(res.data);
        launchUrl = Address.hostWeb + userInfo.login;
      });
    }
    resolveDataResult(res);
    isLoading = false;
    _getFocusStatus();
    ReposDao.getUserRepository100StatusDao(_getUserName()).then((res) {
      if (res != null && res.result) {
        setState(() {
          beStaredCount = res.data.toString();
        });
      }
    });
    return null;
  }

  @override
  requestRefresh() async {}

  _getDataLogic() async {
    if (userInfo.type == "Organization") {
      return await UserDao.getMemberDao(_getUserName(), page);
    }
    return await EventDao.getEventDao(_getUserName(), page: page);
  }

  _getFocusStatus() async {
    var focusRes = await UserDao.checkFollowDao(userName);
    setState(() {
      focus = (focusRes != null && focusRes.result)
          ? WhgStrings.user_focus
          : WhgStrings.user_un_focus;
      focusStatus = (focusRes != null && focusRes.result);
    });
  }

  _renderEventItem(index) {
    if (index == 0) {
      return new UserHeaderItem(userInfo, beStaredCount);
    }
    if (userInfo.type == "Organization") {
      return new UserItem(pullLoadWidgetControl.dataList[index - 1],
          onPressed: () {
        NavigatorUtils.goPerson(
            context, pullLoadWidgetControl.dataList[index - 1].userName);
      });
    } else {
      return new EventItem(pullLoadWidgetControl.dataList[index - 1],
          onPressed: () {
        EventUtils.ActionUtils(
            context, pullLoadWidgetControl.dataList[index - 1].eventMap, "");
      });
    }
  }

  _getUserName() {
    if (userInfo == null) {
      return new User.empty();
    }
    return userInfo.login;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Scaffold(
        appBar: new AppBar(
            title: WhgTitleBar(
          (userInfo != null && userInfo.login != null) ? userInfo.login : "",
          rightWidget: WhgCommonOptionWidget(launchUrl),
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (focus == '') {
              return;
            }
            if (userInfo.type == "Organization") {
              Fluttertoast.showToast(msg: WhgStrings.user_focus_no_support);
              return;
            }
            CommonUtils.showLoadingDialog(context);
            UserDao.doFollowDao(userName, focusStatus).then((res) {
              Navigator.pop(context);
              _getFocusStatus();
            });
          },
          child: Text(focus),
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
