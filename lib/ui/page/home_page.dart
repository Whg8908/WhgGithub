import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:whg_github/common/bean/User.dart';
import 'package:whg_github/common/redux/user_redux.dart';
import 'package:whg_github/common/redux/whg_state.dart';
import 'package:whg_github/common/style/whg_style.dart';
import 'package:whg_github/ui/view/whg_tabbar_widget.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WhgTabBarWidget(
        type: WhgTabBarWidget.BOTTOM_TAB,
        tabItems: [
          new Tab(icon: new Icon(Icons.directions_car)),
          new Tab(icon: new Icon(Icons.directions_transit)),
          new Tab(icon: new Icon(Icons.directions_bike)),
        ],
        tabViews: [
          StoreBuilder<WhgState>(
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
          ),
          StoreConnector<WhgState, String>(
            converter: (store) => store.state.userInfo.name,
            builder: (context, count) {
              return new Text(
                count,
                style: Theme.of(context).textTheme.display1,
              );
            },
          ),
          Icon(Icons.directions_bike),
        ],
        backgroundColor: WhgColors.primarySwatch,
        indicatorColor: Colors.white,
        title: "Title");
  }
}
