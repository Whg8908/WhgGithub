import 'package:flutter/material.dart';
import 'package:whg_github/common/style/whg_style.dart';
import 'package:whg_github/ui/page/dynamic_page.dart';
import 'package:whg_github/ui/page/home_drawer.dart';
import 'package:whg_github/ui/page/my_page.dart';
import 'package:whg_github/ui/page/trend_page.dart';
import 'package:whg_github/ui/view/whg_tabbar_widget.dart';
import 'package:whg_github/ui/view/whg_title_bar.dart';

class HomePage extends StatelessWidget {
  static const String sName = "home";

  @override
  Widget build(BuildContext context) {
    return WhgTabBarWidget(
        drawer: HomeDrawer(),
        type: WhgTabBarWidget.BOTTOM_TAB,
        tabItems: [
          new Tab(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Icon(WhgICons.MAIN_DT, size: 16.0),
                new Text(WhgStrings.home_dynamic)
              ],
            ),
          ),
          new Tab(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Icon(WhgICons.MAIN_QS, size: 16.0),
                new Text(WhgStrings.home_trend)
              ],
            ),
          ),
          new Tab(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Icon(WhgICons.MAIN_MY, size: 16.0),
                new Text(WhgStrings.home_my)
              ],
            ),
          ),
        ],
        tabViews: [
          DynamicPage(),
          TrendPage(),
          MyPage(),
        ],
        backgroundColor: WhgColors.primarySwatch,
        indicatorColor: Colors.white,
        title: WhgTitleBar(
          WhgStrings.app_name,
          iconData: WhgICons.MAIN_SEARCH,
          needRightIcon: true,
          onPressed: () {},
        ));
  }
}
