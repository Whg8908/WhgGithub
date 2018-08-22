import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:whg_github/common/bean/User.dart';
import 'package:whg_github/common/redux/whg_state.dart';
import 'package:whg_github/common/style/whg_style.dart';
import 'package:whg_github/ui/page/home_page.dart';
import 'package:whg_github/ui/page/login_page.dart';
import 'package:whg_github/ui/page/welcome_page.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/22
 *
 * @Description App首页
 *
 * PS: Stay hungry,Stay foolish.
 */
void main() => runApp(new FlutterReduxApp());

class FlutterReduxApp extends StatelessWidget {
  //全局store
  final store = new Store<WhgState>(appReducer,
      initialState:
          new WhgState(userInfo: User.empty(), eventList: new List()));

  FlutterReduxApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: new MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: new ThemeData(
            primarySwatch: WhgColors.primarySwatch,
          ),
          routes: {
            WelComePage.sName: (context) {
              return WelComePage();
            },
            HomePage.sName: (context) {
              return HomePage();
            },
            LoginPage.sName: (context) {
              return LoginPage();
            },
          }),
    );
  }
}
