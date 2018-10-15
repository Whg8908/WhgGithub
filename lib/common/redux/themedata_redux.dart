import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

/**
 *
 * 通过 flutter_redux 的 combineReducers 与 TypedReducer，
 * 将 RefreshThemeDataAction 类 和 _refresh 方法绑定起来，
 * 最终会返回一个 ThemeData 实例。
 * 也就是说：用户每次发出一个 RefreshThemeDataAction
 * 最终都会触发 _refresh 方法，然后更新 WhgState 中的 themeData。
 */
final ThemeDataReducer = combineReducers<ThemeData>([
  TypedReducer<ThemeData, RefreshThemeDataAction>(_refresh),
]);

ThemeData _refresh(ThemeData themeData, action) {
  themeData = action.themeData;
  return themeData;
}

class RefreshThemeDataAction {
  final ThemeData themeData;

  RefreshThemeDataAction(this.themeData);
}
