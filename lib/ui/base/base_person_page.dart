import 'package:flutter/material.dart';
import 'package:github/common/bean/Event.dart';
import 'package:github/common/bean/User.dart';
import 'package:github/common/bean/UserOrg.dart';
import 'package:github/common/dao/user_dao.dart';
import 'package:github/common/utils/eventutils.dart';
import 'package:github/common/utils/navigatorutils.dart';
import 'package:github/common/viewmodel/event_view_model.dart';
import 'package:github/common/viewmodel/user_item_view_model.dart';
import 'package:github/ui/base/whg_list_state.dart';
import 'package:github/ui/view/event_item.dart';
import 'package:github/ui/view/user_header_item.dart';
import 'package:github/ui/view/user_item.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/10/16
 *
 * @Description
 *
 * PS: Stay hungry,Stay foolish.
 */
abstract class BasePersonState<T extends StatefulWidget> extends State<T>
    with AutomaticKeepAliveClientMixin<T>, WhgListState<T> {
  final List<UserOrg> orgList = new List();

  @protected
  getUserOrg(String userName) {
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

  @protected
  renderItem(index, User userInfo, String beStaredCount, Color notifyColor,
      VoidCallback refreshCallBack, List<UserOrg> orgList) {
    if (index == 0) {
      return new UserHeaderItem(
          userInfo, beStaredCount, Theme.of(context).primaryColor,
          notifyColor: notifyColor,
          refreshCallBack: refreshCallBack,
          orgList: orgList);
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

  @override
  bool get wantKeepAlive => true;

  @override
  bool get isRefreshFirst => true;

  @override
  bool get needHeader => true;
}
