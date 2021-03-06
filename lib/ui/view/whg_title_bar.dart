import 'package:flutter/material.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/9/8
 *
 * @Description
 *
 * PS: Stay hungry,Stay foolish.
 */
class WhgTitleBar extends StatelessWidget {
  final String title;

  final IconData iconData;

  final VoidCallback onPressed;

  final bool needRightLocalIcon;

  final Widget rightWidget;

  WhgTitleBar(this.title,
      {this.iconData,
      this.onPressed,
      this.needRightLocalIcon = false,
      this.rightWidget});

  @override
  Widget build(BuildContext context) {
    Widget widget = rightWidget;
    if (rightWidget == null) {
      widget = (needRightLocalIcon)
          ? new IconButton(
              icon: new Icon(
                iconData,
                size: 19.0,
              ),
              onPressed: onPressed)
          : new Container();
    }
    return Container(
      padding: EdgeInsets.all(0.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          widget,
        ],
      ),
    );
  }
}
