import 'package:flutter/material.dart';
import 'package:whg_github/common/style/whg_style.dart';

class WhgCardItem extends StatelessWidget {
  final Widget child;

  WhgCardItem({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      color: Color(WhgColors.cardWhite),
      margin: const EdgeInsets.all(10.0),
      child: child,
    );
  }
}
