import 'package:flutter/material.dart';

/**
 * 自定义全屏按钮
 */
class WhgFlexButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final VoidCallback onPress;
  final double fontSize;

  WhgFlexButton(
      {Key key,
      this.text,
      this.color,
      this.textColor,
      this.onPress,
      this.fontSize = 20.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        if (this.onPress != null) {
          this.onPress();
        }
      },
      padding: const EdgeInsets.only(
          left: 20.0, top: 12.0, right: 20.0, bottom: 12.0),
      textColor: textColor,
      color: color,
      child: new Flex(
        mainAxisAlignment: MainAxisAlignment.center,
        direction: Axis.horizontal,
        children: <Widget>[
          new Text(text, style: new TextStyle(fontSize: 20.0))
        ],
      ),
    );
  }
}
