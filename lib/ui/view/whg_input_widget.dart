import 'package:flutter/material.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/21
 *
 * @Description  带有图标的输入框
 *
 * PS: Stay hungry,Stay foolish.
 */
class WhgInputWidget extends StatefulWidget {
  final String hintText;
  final IconData iconData;
  final bool obscureText;
  final ValueChanged<String> onChange;
  final TextEditingController controller;

  WhgInputWidget(
      {Key key,
      this.hintText,
      this.iconData,
      this.onChange,
      this.controller,
      this.obscureText = false})
      : super(key: key);

  @override
  WhgInputWidgetState createState() => new WhgInputWidgetState(
      hintText, iconData, onChange, controller, obscureText);
}

class WhgInputWidgetState extends State<WhgInputWidget> {
  final String hintText;
  final IconData iconData;
  final bool obscureText;
  final ValueChanged<String> onChange;
  final TextEditingController controller;

  WhgInputWidgetState(this.hintText, this.iconData, this.onChange,
      this.controller, this.obscureText)
      : super();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChange,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        icon: iconData == null ? null : new Icon(iconData),
      ),
    );
  }
}
