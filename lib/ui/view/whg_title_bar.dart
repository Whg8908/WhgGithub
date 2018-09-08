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

  final bool needRightIcon;

  WhgTitleBar(this.title,
      {this.iconData, this.onPressed, this.needRightIcon = false});

  @override
  Widget build(BuildContext context) {
    Widget right = (needRightIcon)
        ? new IconButton(
            icon: new Icon(
              iconData,
              size: 17.0,
            ),
            onPressed: onPressed)
        : new Container();
    return Container(
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          right
        ],
      ),
    );
  }
}
