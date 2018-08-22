import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:whg_github/common/config/config.dart';
import 'package:whg_github/common/dao/user_dao.dart';
import 'package:whg_github/common/redux/whg_state.dart';
import 'package:whg_github/common/utils/navigatorutils.dart';

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
  static const String sName = "/";

  @override
  Widget build(BuildContext context) {
    toNext(res) {
      if (Config.DEBUG) {
        print(res);
        print(res.result);
      }
      if (res != null && res.result) {
        NavigatorUtils.goHome(context);
      } else {
        NavigatorUtils.goLogin(context);
      }
    }

    return StoreBuilder<WhgState>(
      builder: (context, store) {
        new Future.delayed(const Duration(seconds: 2), () {
          UserDao.initUserInfo(store).then((res) {
            toNext(res);
          });
        });
        return Container(
            color: Colors.white,
            child: Image(image: AssetImage("static/images/welcome.png")));
      },
    );
  }
}
