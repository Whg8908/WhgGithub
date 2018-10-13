import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:github/common/config/config.dart';
import 'package:github/common/dao/user_dao.dart';
import 'package:github/common/local/local_storage.dart';
import 'package:github/common/redux/whg_state.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/common/utils/commonutils.dart';
import 'package:github/common/utils/navigatorutils.dart';
import 'package:github/ui/view/whg_flex_button.dart';
import 'package:github/ui/view/whg_input_widget.dart';

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

  //edittext控制器
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
    _userNameController.value = new TextEditingValue(text: _userName ?? "");
    _passWordController.value = new TextEditingValue(text: _passWord ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<WhgState>(builder: (context, store) {
      return new GestureDetector(
        //手势控制
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
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
                      image: AssetImage(WhgICons.DEFAULT_USER_ICON),
                      width: 80.0,
                      height: 80.0,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    WhgInputWidget(
                      //自定义的带有图片的edittext
                      hintText: WhgStrings.login_username_hint_text,
                      iconData: WhgICons.LOGIN_USER,
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
                      iconData: WhgICons.LOGIN_PW,
                      onChange: (String value) {
                        _passWord = value;
                      },
                      controller: _passWordController,
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    WhgFlexButton(
                      //自适应屏幕宽的按钮
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
                        CommonUtils.showLoadingDialog(context);
                        UserDao.login(_userName, _passWord, store).then((res) {
                          Navigator.pop(context);
                          if (res != null && res.result) {
                            new Future.delayed(const Duration(seconds: 1), () {
                              NavigatorUtils.goHome(context);
                            });
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
