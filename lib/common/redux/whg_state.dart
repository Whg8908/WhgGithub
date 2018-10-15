import 'package:flutter/material.dart';
import 'package:github/common/bean/Event.dart';
import 'package:github/common/bean/TrendingRepoModel.dart';
import 'package:github/common/bean/User.dart';
import 'package:github/common/redux/event_redux.dart';
import 'package:github/common/redux/themedata_redux.dart';
import 'package:github/common/redux/trend_redux.dart';
import 'package:github/common/redux/user_redux.dart';

/**
 *
 *
 * 如下代码，WhgState 的每一个参数，是通过独立的自定义 Reducer 返回的。
 * 比如 themeData 是通过 ThemeDataReducer 方法产生的，
 * ThemeDataReducer 其实是将 ThemeData 和一系列 Theme 相关的 Action 绑定起来，用于和其他参数分开。
 * 这样就可以独立的维护和管理 WhgState 中的每一个参数。
 */

///全局Redux store 的对象，保存State数据,用于储存需要共享的数据
class WhgState {
  ///用户信息
  User userInfo;

  ///主题
  ThemeData themeData;

  ///用户接受到的事件列表
  List<Event> eventList = new List();

  ///用户接受到的事件列表
  List<TrendingRepoModel> trendList = new List();

  WhgState({this.userInfo, this.eventList, this.trendList, this.themeData});
}

///将 WhgState 内的每一个参数，和对应的 action 绑定起来，返回完整的 WhgState 。
///这样我们就确定了 State 和 Reducer 用于创建 Store
///创建 Reducer
///源码中 Reducer 是一个方法 typedef State Reducer<State>(State state, dynamic action);
///我们自定义了 appReducer 用于创建 store
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
