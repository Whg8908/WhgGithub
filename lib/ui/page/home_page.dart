import 'package:flutter/material.dart';
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
          new Icon(Icons.directions_car),
          new Icon(Icons.directions_transit),
          new Icon(Icons.directions_bike),
        ],
        backgroundColor: Colors.deepOrange,
        indicatorColor: Colors.white,
        title: "Title");
  }
}
