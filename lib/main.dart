import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:github/common/bean/User.dart';
import 'package:github/common/delegate/whg_localications.dart';
import 'package:github/common/delegate/whg_locallizations_delegate.dart';
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
  ///1.创建
  ///在创建 Store 的同时,  initialState 对 WhgState 进行了初始化，
  /// 然后通过 StoreProvider 加载了 Store 并且包裹了 MaterialApp 。
  /// 至此我们完成了 Redux 中的初始化构建。

  ///创建 Store 需要 reducer ，而 reducer 实际上是一个带有 state 和 action 的方法，并返回新的 State
  /// 创建Store，引用 WhgState 中的 appReducer 创建 Reducer
  /// initialState 初始化 State
  final store = new Store<WhgState>(appReducer,
      initialState: new WhgState(
          userInfo: User.empty(),
          eventList: new List(),
          trendList: new List(),
          themeData: new ThemeData(
            primarySwatch: WhgColors.primarySwatch,
          ),
          locale: Locale('zh', 'CH')));

  FlutterReduxApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// 通过 StoreProvider 应用 store
    return StoreProvider(
      store: store,
      child: new MaterialApp(
          theme: store.state.themeData,
          localizationsDelegates: [
            //类似于国际化
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            WhgLocalizationsDelegate.delegate,
          ],
          supportedLocales: [store.state.locale],
          //去掉右上角debug图标
          debugShowCheckedModeBanner: false,
          //注册页面,类似于在androidmanifest注册是一样
          routes: {
            WelComePage.sName: (context) {
              store.state.platformLocale = Localizations.localeOf(context);
              return WelComePage();
            },
            HomePage.sName: (context) {
              return new WhgLocalizations(
                child: new HomePage(),
              );
            },
            LoginPage.sName: (context) {
              return new WhgLocalizations(
                child: LoginPage(),
              );
            },
          }),
    );
  }
}
