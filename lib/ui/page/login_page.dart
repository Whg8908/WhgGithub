import 'package:flutter/material.dart';
import 'package:whg_github/common/style/whg_style.dart';
import 'package:whg_github/ui/view/whg_flex_button.dart';
import 'package:whg_github/ui/view/whg_input_widget.dart';

class LoginPage extends StatelessWidget {
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
                  hintText: "1111",
                  iconData: Icons.access_alarm,
                ),
                SizedBox(
                  height: 10.0,
                ),
                WhgInputWidget(
                  hintText: "1111",
                  iconData: Icons.access_alarm,
                ),
                SizedBox(
                  height: 30.0,
                ),
                WhgFlexButton(
                  text: WhgStrings.login_text,
                  color: Color(WhgColors.primaryValue),
                  textColor: Color(WhgColors.textWhite),
                  onPress: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
