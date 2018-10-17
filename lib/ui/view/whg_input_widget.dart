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
  WhgInputWidgetState createState() => new WhgInputWidgetState();
}

class WhgInputWidgetState extends State<WhgInputWidget> {
  WhgInputWidgetState() : super();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onChanged: widget.onChange,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        hintText: widget.hintText,
        icon: widget.iconData == null ? null : new Icon(widget.iconData),
      ),
    );
  }
}
