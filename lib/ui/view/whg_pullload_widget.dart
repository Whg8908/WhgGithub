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
 * @Description
 *
 * PS: Stay hungry,Stay foolish.
 */

class WhgPullLoadWidget extends StatefulWidget {
  final IndexedWidgetBuilder itemBuilder;

  final NotificationListenerCallback<Notification> notificationListenerCallback;

  final RefreshCallback onRefresh;

  final WhgPullLoadWidgetControl control;

  WhgPullLoadWidget(this.itemBuilder, this.notificationListenerCallback,
      this.onRefresh, this.control);

  @override
  WhgPullLoadWidgetState createState() => WhgPullLoadWidgetState(
      this.itemBuilder,
      this.notificationListenerCallback,
      this.onRefresh,
      this.control);
}

class WhgPullLoadWidgetState extends State<WhgPullLoadWidget> {
  final IndexedWidgetBuilder itemBuilder;

  final NotificationListenerCallback<Notification> notificationListenerCallback;

  final RefreshCallback onRefresh;

  final WhgPullLoadWidgetControl control;

  WhgPullLoadWidgetState(this.itemBuilder, this.notificationListenerCallback,
      this.onRefresh, this.control);

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
        return NotificationListener(
          onNotification: notificationListenerCallback,
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.builder(
              itemBuilder: itemBuilder,
              itemCount: control.count,
              physics: const AlwaysScrollableScrollPhysics(),
            ),
          ),
        );
      },
    );
  }
}

class WhgPullLoadWidgetControl {
  int count = 5;
}
