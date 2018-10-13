import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:github/common/dao/user_dao.dart';
import 'package:github/common/redux/whg_state.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/common/utils/commonutils.dart';
import 'package:github/common/utils/navigatorutils.dart';
import 'package:redux/redux.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/22
 *
 * @Description  欢迎页面
 *
 * PS: Stay hungry,Stay foolish.
 */

class WelComePage extends StatefulWidget {
  static final String sName = "/";

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelComePage> {
  bool hadInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (hadInit) {
      return;
    }
    hadInit = true;

    ///防止多次进入
    Store<WhgState> store = StoreProvider.of(context);
    CommonUtils.initStatusBarHeight(context);
    new Future.delayed(const Duration(seconds: 2), () {
      UserDao.initUserInfo(store).then((res) {
        if (res != null && res.result) {
          NavigatorUtils.goHome(context);
        } else {
          NavigatorUtils.goLogin(context);
        }
        return true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<WhgState>(
      builder: (context, store) {
        return Container(
            color: Color(WhgColors.white),
            child: Image(
                fit: BoxFit.cover,
                image: AssetImage("static/images/welcome.png")));
      },
    );
  }
}
