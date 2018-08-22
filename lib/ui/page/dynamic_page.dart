import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:whg_github/common/redux/whg_state.dart';
import 'package:whg_github/ui/view/eventitem.dart';
import 'package:whg_github/ui/view/whg_pullload_widget.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/22
 *
 * @Description 我的动态页面
 *
 * PS: Stay hungry,Stay foolish.
 */

class DynamicPage extends StatefulWidget {
  @override
  DynamicPageState createState() => DynamicPageState();
}

class DynamicPageState extends State<DynamicPage> {
  final WhgPullLoadWidgetControl control = WhgPullLoadWidgetControl();

  Future<Null> _handleRefresh() async {
    setState(() {
      control.count = 5;
    });
    return null;
  }

  bool _onNotifycation<Notification>(Notification notify) {
    if (notify is! OverscrollNotification) {
      return true;
    }
    setState(() {
      control.count += 5;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<WhgState>(
      builder: (context, store) {
        return WhgPullLoadWidget(
          (BuildContext context, int index) => EventItem(),
          _onNotifycation,
          _handleRefresh,
          control,
        );
      },
    );
  }
}
