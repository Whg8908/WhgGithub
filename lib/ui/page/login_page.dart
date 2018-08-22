import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:whg_github/common/config/config.dart';
import 'package:whg_github/common/dao/user_dao.dart';
import 'package:whg_github/common/local/local_storage.dart';
import 'package:whg_github/common/style/whg_style.dart';
import 'package:whg_github/common/utils/navigatorutils.dart';
import 'package:whg_github/ui/view/whg_flex_button.dart';
import 'package:whg_github/ui/view/whg_input_widget.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/21
 *
 * @Description  登录页面
 *
 * PS: Stay hungry,Stay foolish.
 */
class LoginPage extends StatefulWidget {
  static const String sName = "login";

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  LoginPageState() : super();

  var _userName = "";
  var _passWord = "";

  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passWordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initParams();
  }

  Future initParams() async {
    _userName = await LocalStorage.get(Config.USER_NAME_KEY);
    _passWord = await LocalStorage.get(Config.PW_KEY);
    if (_userName != null) {
      _userNameController.value = new TextEditingValue(text: _userName);
    }
    if (_passWord != null) {
      _passWordController.value = new TextEditingValue(text: _passWord);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(WhgColors.primaryValue),
      child: Center(
        child: Card(
          color: Color(WhgColors.cardWhite),
          margin: const EdgeInsets.all(30.0),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 20.0, top: 60.0, right: 30.0, bottom: 80.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image(
                  image: AssetImage('static/images/logo.png'),
                  width: 80.0,
                  height: 80.0,
                ),
                SizedBox(
                  height: 10.0,
                ),
                WhgInputWidget(
                  hintText: WhgStrings.login_username_hint_text,
                  iconData: Icons.access_alarm,
                  onChange: (String value) {
                    _userName = value;
                  },
                  controller: _userNameController,
                ),
                SizedBox(
                  height: 10.0,
                ),
                WhgInputWidget(
                  hintText: WhgStrings.login_password_hint_text,
                  obscureText: true,
                  iconData: Icons.access_alarm,
                  onChange: (String value) {
                    _passWord = value;
                  },
                  controller: _passWordController,
                ),
                SizedBox(
                  height: 30.0,
                ),
                WhgFlexButton(
                  text: WhgStrings.login_text,
                  color: Color(WhgColors.primaryValue),
                  textColor: Color(WhgColors.textWhite),
                  onPress: () {
                    if (_userName == null || _userName.length == 0) {
                      return;
                    }
                    if (_passWord == null || _passWord.length == 0) {
                      return;
                    }
                    UserDao.login(_userName, _passWord, (data) {
                      if (data != null && data.result == true) {
                        Fluttertoast.showToast(msg: WhgStrings.login_success);
                        NavigatorUtils.goHome(context);
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
