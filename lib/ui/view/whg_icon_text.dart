import 'package:flutter/material.dart';

class WhgIconText extends StatelessWidget {
  final String iconText;

  final IconData iconData;

  final TextStyle textStyle;

  final Color iconColor;

  final double padding;

  final double iconSize;
  final VoidCallback onPressed;

  final MainAxisAlignment mainAxisAlignment;

  final MainAxisSize mainAxisSize;

  final CrossAxisAlignment crossAxisAlignment;

  WhgIconText(
    this.iconData,
    this.iconText,
    this.textStyle,
    this.iconColor,
    this.iconSize, {
    this.padding = 0.0,
    this.onPressed,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      children: <Widget>[
        Icon(
          iconData,
          size: iconSize,
          color: iconColor,
        ),
        SizedBox(
          width: padding,
        ),
        Text(
          iconText,
          style: textStyle,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        )
      ],
    );
  }
}
