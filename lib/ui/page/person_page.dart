import 'package:flutter/material.dart';
import 'package:github/common/bean/Event.dart';
import 'package:github/common/bean/User.dart';
import 'package:github/common/bean/UserOrg.dart';
import 'package:github/common/dao/event_dao.dart';
import 'package:github/common/dao/repos_dao.dart';
import 'package:github/common/dao/user_dao.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/common/utils/commonutils.dart';
import 'package:github/common/utils/eventutils.dart';
import 'package:github/common/utils/fluttertoast.dart';
import 'package:github/common/utils/navigatorutils.dart';
import 'package:github/common/viewmodel/event_view_model.dart';
import 'package:github/common/viewmodel/user_item_view_model.dart';
import 'package:github/ui/base/whg_list_state.dart';
import 'package:github/ui/view/event_item.dart';
import 'package:github/ui/view/user_header_item.dart';
import 'package:github/ui/view/user_item.dart';
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

class PersonPageState extends WhgListState<PersonPage> {
  final String userName;
  User userInfo = User.empty();

  final List<UserOrg> orgList = new List();

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

    ///从Dao中获取数据
    ///如果第一次返回的是网络数据，next为空
    ///如果返回的是数据库数据，next不为空
    ///这样数据库返回数据较快，马上显示
    ///next异步再请求后，再更新

    ///用户信息
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

    _getUserOrg();

    return await EventDao.getEventDao(_getUserName(),
        page: page, needDb: page <= 1);
  }

  _getUserOrg() {
    if (page <= 1) {
      UserDao.getUserOrgsDao(userName, page, needDb: true).then((res) {
        if (res != null && res.result) {
          setState(() {
            orgList.clear();
            orgList.addAll(res.data);
          });
          return res.next;
        }
        return new Future.value(null);
      }).then((res) {
        if (res != null && res.result) {
          setState(() {
            orgList.clear();
            orgList.addAll(res.data);
          });
        }
      });
    }
  }

  _getFocusStatus() async {
    var focusRes = await UserDao.checkFollowDao(userName);
    if (isShow) {
      setState(() {
        focus = (focusRes != null && focusRes.result)
            ? WhgStrings.user_focus
            : WhgStrings.user_un_focus;
        focusStatus = (focusRes != null && focusRes.result);
      });
    }
  }

  _renderEventItem(index) {
    if (index == 0) {
      return new UserHeaderItem(userInfo, beStaredCount, orgList: orgList);
    }
    if (userInfo.type == "Organization") {
      return new UserItem(
          UserItemViewModel.fromMap(pullLoadWidgetControl.dataList[index - 1]),
          onPressed: () {
        NavigatorUtils.goPerson(
            context,
            UserItemViewModel.fromMap(pullLoadWidgetControl.dataList[index - 1])
                .userName);
      });
    } else {
      Event event = pullLoadWidgetControl.dataList[index - 1];
      return new EventItem(EventViewModel.fromEventMap(event), onPressed: () {
        EventUtils.ActionUtils(context, event, "");
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
