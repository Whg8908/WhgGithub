import 'package:flutter/material.dart';
import 'package:whg_github/common/style/whg_style.dart';
import 'package:whg_github/ui/page/dynamic_page.dart';
import 'package:whg_github/ui/page/home_drawer.dart';
import 'package:whg_github/ui/page/my_age.dart';
import 'package:whg_github/ui/page/trend_page.dart';
import 'package:whg_github/ui/view/whg_tabbar_widget.dart';

class HomePage extends StatelessWidget {
  static const String sName = "home";

  @override
  Widget build(BuildContext context) {
    return WhgTabBarWidget(
        drawer: HomeDrawer(),
        type: WhgTabBarWidget.BOTTOM_TAB,
        tabItems: [
          new Tab(icon: new Icon(WhgICons.MAIN_DT)),
          new Tab(icon: new Icon(WhgICons.MAIN_QS)),
          new Tab(icon: new Icon(WhgICons.MAIN_MY)),
        ],
        tabViews: [
          DynamicPage(),
          TrendPage(),
          MyPage(),
        ],
        backgroundColor: WhgColors.primarySwatch,
        indicatorColor: Colors.white,
        title: WhgStrings.appName);
  }
}
