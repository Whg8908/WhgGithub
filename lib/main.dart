import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:whg_github/common/bean/User.dart';
import 'package:whg_github/common/redux/whg_state.dart';
import 'package:whg_github/common/style/whg_style.dart';
import 'package:whg_github/ui/page/home_page.dart';
import 'package:whg_github/ui/page/login_page.dart';
import 'package:whg_github/ui/page/welcome_page.dart';

void main() => runApp(new FlutterReduxApp());

class FlutterReduxApp extends StatelessWidget {
  final store = new Store<WhgState>(appReducer,
      initialState: new WhgState(userInfo: User.empty()));

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
            "/": (context) {
              return WelComePage();
            },
            "home": (context) {
              return HomePage();
            },
            "login": (context) {
              return LoginPage();
            },
          }),
    );
  }
}
