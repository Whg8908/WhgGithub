import 'package:flutter/material.dart';
import 'package:whg_github/common/style/whg_style.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/23
 *
 * @Description  定制化更高的Card
 *
 * PS: Stay hungry,Stay foolish.
 */
class WhgCardItem extends StatelessWidget {
  final Widget child;
  final EdgeInsets margin;
  final Color color;
  final RoundedRectangleBorder shape;
  final double elevation;

  WhgCardItem(
      {@required this.child,
      this.margin,
      this.color,
      this.shape,
      this.elevation = 5.0});

  @override
  Widget build(BuildContext context) {
    EdgeInsets margin = this.margin;
    RoundedRectangleBorder shape = this.shape;
    Color color = this.color;
    if (margin == null) {
      margin = EdgeInsets.all(10.0);
    }
    if (shape == null) {
      shape = new RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)));
    }
    if (color == null) {
      color = new Color(WhgColors.cardWhite);
    }
    return new Card(
        elevation: elevation,
        shape: shape,
        color: color,
        margin: margin,
        child: child);
  }
}
