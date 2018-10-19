import 'package:flutter/material.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/common/utils/commonutils.dart';
import 'package:github/common/utils/navigatorutils.dart';
import 'package:github/ui/page/dynamic_page.dart';
import 'package:github/ui/page/home_drawer.dart';
import 'package:github/ui/page/my_page.dart';
import 'package:github/ui/page/trend_page.dart';
import 'package:github/ui/view/whg_tabbar_widget.dart';
import 'package:github/ui/view/whg_title_bar.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/10/12
 *
 * @Description 主页面
 *
 * PS: Stay hungry,Stay foolish.
 */

class HomePage extends StatelessWidget {
  static const String sName = "home";

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [
      _renderTab(WhgICons.MAIN_DT, CommonUtils.getLocale(context).home_dynamic),
      _renderTab(WhgICons.MAIN_QS, CommonUtils.getLocale(context).home_trend),
      _renderTab(WhgICons.MAIN_MY, CommonUtils.getLocale(context).home_my),
    ];
    return WillPopScope(
        onWillPop: () {
          return CommonUtils.dialogExitApp(context);
        },
        child: WhgTabBarWidget(
            //tabview+viewpager组合(上/下)
            drawer: HomeDrawer(),
            type: WhgTabBarWidget.BOTTOM_TAB,
            tabItems: tabs,
            tabViews: [
              DynamicPage(), //动态页面
              TrendPage(), //趋势页面
              MyPage(), //我的页面
            ],
            backgroundColor: WhgColors.primarySwatch,
            indicatorColor: Color(WhgColors.white),
            title: WhgTitleBar(
              //自定义titlebar
              CommonUtils.getLocale(context).app_name,
              iconData: WhgICons.MAIN_SEARCH,
              needRightLocalIcon: true,
              onPressed: () {
                NavigatorUtils.goSearchPage(context);
              },
            )));
  }

  _renderTab(icon, text) {
    return new Tab(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[new Icon(icon, size: 16.0), new Text(text)],
      ),
    );
  }
}
