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
    return Row(
      children: <Widget>[
        Expanded(
          child: RaisedButton(
            onPressed: () {
              if (this.onPress != null) {
                this.onPress();
              }
            },
            padding: const EdgeInsets.only(
                left: 20.0, top: 12.0, right: 20.0, bottom: 12.0),
            textColor: textColor,
            color: color,
            child: Text(
              text,
              style: TextStyle(fontSize: fontSize),
            ),
          ),
        ),
      ],
    );
  }
}
