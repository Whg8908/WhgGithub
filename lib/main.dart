import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:github/common/bean/User.dart';
import 'package:github/common/delegate/material_localizations_delegate.dart';
import 'package:github/common/redux/whg_state.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/ui/page/home_page.dart';
import 'package:github/ui/page/login_page.dart';
import 'package:github/ui/page/welcome_page.dart';
import 'package:redux/redux.dart';

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
  /// 创建Store，引用 GSYState 中的 appReducer 创建 Reducer
  /// initialState 初始化 State
  final store = new Store<WhgState>(appReducer,
      initialState: new WhgState(
          userInfo: User.empty(),
          eventList: new List(),
          trendList: new List()));

  FlutterReduxApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// 通过 StoreProvider 应用 store
    return StoreProvider(
      store: store,
      child: new MaterialApp(
          localizationsDelegates: [
            //类似于国际化
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            MaterialLocalizationsDelegate(),
          ],
          supportedLocales: [
            const Locale('zh', 'CH'),
            const Locale('en', 'US'),
          ],
          //去掉右上角debug图标
          debugShowCheckedModeBanner: false,
          theme: new ThemeData(
            primarySwatch: WhgColors.primarySwatch,
          ),
          //注册页面,类似于在androidmanifest注册是一样
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
