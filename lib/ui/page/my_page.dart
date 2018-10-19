import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:github/common/dao/event_dao.dart';
import 'package:github/common/dao/repos_dao.dart';
import 'package:github/common/dao/user_dao.dart';
import 'package:github/common/redux/user_redux.dart';
import 'package:github/common/redux/whg_state.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/ui/base/base_person_page.dart';
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

class MyPageState extends BasePersonState<MyPage> {
  String beSharedCount = '---';

  Color notifyColor = const Color(WhgColors.subTextColor);

  @override
  requestRefresh() async {
    UserDao.getUserInfo(null).then((res) {
      if (res != null && res.result) {
        _getStore().dispatch(UpdataUserAction(res.data));

        getUserOrg(_getUserName());
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
      Color newColor;

      if (res != null && res.result && res.data.length > 0) {
        newColor = Color(WhgColors.actionBlue);
      } else {
        newColor = Color(WhgColors.subLightTextColor);
      }

      if (isShow) {
        setState(() {
          notifyColor = newColor;
        });
      }
    });
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

  @override
  void didChangeDependencies() {
    if (pullLoadWidgetControl.dataList.length == 0) {
      showRefreshLoading();
    }
    super.didChangeDependencies();
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
      ///应用
      builder: (context, store) {
        return WhgPullLoadWidget(
          (BuildContext context, int index) => renderItem(
                  index, store.state.userInfo, beSharedCount, notifyColor, () {
                _refreshNotify();
              }, orgList),
          handleRefresh,
          onLoadMore,
          pullLoadWidgetControl,
          refreshKey: refreshIndicatorKey,
        );
      },
    );
  }
}
