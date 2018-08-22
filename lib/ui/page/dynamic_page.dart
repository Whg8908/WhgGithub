import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:whg_github/common/bean/User.dart';
import 'package:whg_github/common/redux/user_redux.dart';
import 'package:whg_github/common/redux/whg_state.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/22
 *
 * @Description 我的动态页面
 *
 * PS: Stay hungry,Stay foolish.
 */

class DynamicPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreBuilder<WhgState>(
      builder: (context, store) {
        new Future.delayed(const Duration(seconds: 2), () {
          User user = store.state.userInfo;
          user.login = "new login";
          user.name = "new name";
          store.dispatch(new UpdataUserAction(user));
        });
        return new Text(
          store.state.userInfo.login,
          style: Theme.of(context).textTheme.display1,
        );
      },
    );
  }
}
