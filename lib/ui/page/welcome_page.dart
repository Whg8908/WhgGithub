import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:github/common/dao/user_dao.dart';
import 'package:github/common/redux/whg_state.dart';
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

class WelComePage extends StatelessWidget {
  //默认的跳转路径
  static const String sName = "/";

  @override
  Widget build(BuildContext context) {
    //获取全局的store
    Store<WhgState> store = StoreProvider.of(context);

    new Future.delayed(const Duration(seconds: 1), () {
      UserDao.initUserInfo(store).then((res) {
        if (res != null && res.result) {
          NavigatorUtils.goHome(context);
        } else {
          NavigatorUtils.goLogin(context);
        }
      });
    });

    return StoreBuilder<WhgState>(
      builder: (context, store) {
        return Container(
            color: Colors.white,
            child: Image(
                fit: BoxFit.cover,
                image: AssetImage("static/images/welcome.png")));
      },
    );
  }
}
