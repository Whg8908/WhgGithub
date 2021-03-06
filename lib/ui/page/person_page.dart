import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:github/common/bean/User.dart';
import 'package:github/common/bean/UserOrg.dart';
import 'package:github/common/dao/event_dao.dart';
import 'package:github/common/dao/repos_dao.dart';
import 'package:github/common/dao/user_dao.dart';
import 'package:github/common/utils/commonutils.dart';
import 'package:github/ui/base/base_person_page.dart';
import 'package:github/ui/view/whg_common_option_widget.dart';
import 'package:github/ui/view/whg_pullload_widget.dart';
import 'package:github/ui/view/whg_title_bar.dart';

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

class PersonPageState extends BasePersonState<PersonPage> {
  final String userName;
  User userInfo = User.empty();

  final List<UserOrg> orgList = new List();

  String beStaredCount = "---";

  bool focusStatus = false;

  String focus = "";

  String launchUrl = "";

  PersonPageState(this.userName);

  @override
  bool get isRefreshFirst => true;

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
    var userResult = await UserDao.getUserInfo(userName, needDb: true);
    if (userResult != null && userResult.result) {
      _resolveUserInfo(userResult);
      if (userResult.next != null) {
        userResult.next.then((resNext) {
          _resolveUserInfo(resNext);
        });
      }
    } else {
      return null;
    }
    var res = await _getDataLogic();
    resolveRefreshResult(res);
    resolveDataResult(res);
    if (res.next != null) {
      var resNext = await res.next;
      resolveRefreshResult(resNext);
      resolveDataResult(resNext);
    }
    isLoading = false;
    _getFocusStatus();
    ReposDao.getUserRepository100StatusDao(_getUserName()).then((res) {
      if (res != null && res.result) {
        if (isShow) {
          setState(() {
            beStaredCount = res.data.toString();
          });
        }
      }
    });
    return null;
  }

  _resolveUserInfo(res) {
    if (isShow) {
      setState(() {
        userInfo = res.data;
      });
    }
  }

  @override
  requestRefresh() async {}

  _getDataLogic() async {
    if (userInfo.type == "Organization") {
      return await UserDao.getMemberDao(_getUserName(), page);
    }

    getUserOrg(_getUserName());

    return await EventDao.getEventDao(_getUserName(),
        page: page, needDb: page <= 1);
  }

  _getFocusStatus() async {
    var focusRes = await UserDao.checkFollowDao(userName);
    if (isShow) {
      setState(() {
        focus = (focusRes != null && focusRes.result)
            ? CommonUtils.getLocale(context).user_focus
            : CommonUtils.getLocale(context).user_un_focus;
        focusStatus = (focusRes != null && focusRes.result);
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
              Fluttertoast.showToast(
                  msg: CommonUtils.getLocale(context).user_focus_no_support);
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
          (BuildContext context, int index) =>
              renderItem(index, userInfo, beStaredCount, null, null, orgList),
          handleRefresh,
          onLoadMore,
          pullLoadWidgetControl,
          refreshKey: refreshIndicatorKey,
        ));
  }
}
