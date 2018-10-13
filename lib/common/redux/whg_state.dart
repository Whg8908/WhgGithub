import 'package:flutter/material.dart';
import 'package:github/common/bean/Event.dart';
import 'package:github/common/bean/TrendingRepoModel.dart';
import 'package:github/common/bean/User.dart';
import 'package:github/common/redux/event_redux.dart';
import 'package:github/common/redux/themedata_redux.dart';
import 'package:github/common/redux/trend_redux.dart';
import 'package:github/common/redux/user_redux.dart';

class WhgState {
  ///用户信息
  User userInfo;

  ThemeData themeData;

  ///用户接受到的事件列表
  List<Event> eventList = new List();

  ///用户接受到的事件列表
  List<TrendingRepoModel> trendList = new List();

  WhgState({this.userInfo, this.eventList, this.trendList, this.themeData});
}

class UserActions {
  final User userInfo;

  UserActions(this.userInfo);
}

WhgState appReducer(WhgState state, dynamic action) {
  return WhgState(
    ///通过 UserReducer 将 WhgState 内的 userInfo 和 action 关联在一起
    userInfo: UserReducer(state.userInfo, action),

    ///通过 EventReducer 将 WhgState 内的 eventList 和 action 关联在一起

    eventList: EventReducer(state.eventList, action),

    ///通过 TrendReducer 将 WhgState 内的 trendList 和 action 关联在一起
    trendList: TrendReducer(state.trendList, action),

    themeData: ThemeDataReducer(state.themeData, action),
  );
}
