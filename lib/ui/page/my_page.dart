import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:github/common/bean/Event.dart';
import 'package:github/common/bean/UserOrg.dart';
import 'package:github/common/dao/event_dao.dart';
import 'package:github/common/dao/repos_dao.dart';
import 'package:github/common/dao/user_dao.dart';
import 'package:github/common/redux/whg_state.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/common/utils/eventutils.dart';
import 'package:github/common/utils/navigatorutils.dart';
import 'package:github/common/viewmodel/event_view_model.dart';
import 'package:github/common/viewmodel/user_item_view_model.dart';
import 'package:github/ui/base/whg_list_state.dart';
import 'package:github/ui/view/event_item.dart';
import 'package:github/ui/view/user_header_item.dart';
import 'package:github/ui/view/user_item.dart';
import 'package:github/ui/view/whg_pullload_widget.dart';
import 'package:redux/redux.dart';

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

  Color notifyColor = const Color(WhgColors.subTextColor);

  final List<UserOrg> orgList = new List();

  @override
  requestRefresh() async {
    UserDao.getUserInfo(null).then((res) {
      if (res != null && res.result) {
        _getStore().dispatch(UserActions(res.data));

        _getUserOrg(_getUserName());
      }
    });

    ReposDao.getUserRepository100StatusDao(_getUserName()).then((res) {
      if (res != null && res.result) {
        if (isShow) {
          setState(() {
            beSharedCount = res.data.toString();
          });
        }
      }
    });
    _refreshNotify();

    return await _getDataLogic();
  }

  @override
  requestLoadMore() async {
    return await _getDataLogic();
  }

  _getDataLogic() async {
    if (getUserType() == "Organization") {
      return await UserDao.getMemberDao(_getUserName(), page);
    }
    return await EventDao.getEventDao(_getUserName(),
        page: page, needDb: page <= 1);
  }

  @override
  bool get isRefreshFirst => false;

  @override
  bool get needHeader => true;

  _refreshNotify() {
    UserDao.getNotifyDao(false, false, 0).then((res) {
      if (res != null && res.result && res.data.length > 0) {
        notifyColor = Colors.blue;
      } else {
        notifyColor = Color(WhgColors.subTextColor);
      }
    });
  }

  _renderEventItem(userInfo, index) {
    if (index == 0) {
      return new UserHeaderItem(
        userInfo,
        beSharedCount,
        notifyColor: notifyColor,
        refreshCallBack: () {
          _refreshNotify();
        },
        orgList: orgList,
      );
    }

    if (getUserType() == "Organization") {
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

  getUserType() {
    if (_getStore().state.userInfo == null) {
      return null;
    }
    return _getStore().state.userInfo.type;
  }

  _getUserName() {
    if (_getStore().state.userInfo == null) {
      return null;
    }
    return _getStore().state.userInfo.login;
  }

  _getUserOrg(String userName) {
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
