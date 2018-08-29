import 'package:flutter/material.dart';
import 'package:whg_github/common/style/whg_style.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/29
 *
 * @Description 搜索控件
 *
 * PS: Stay hungry,Stay foolish.
 */

class WhgSearchInputWidget extends StatelessWidget {
  final ValueChanged<String> onSubmitted;
  final ValueChanged<String> onChanged;

  WhgSearchInputWidget(this.onChanged, this.onSubmitted);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          color: Colors.white,
          border:
              new Border.all(color: Color(WhgColors.subTextColor), width: 0.3)),
      padding:
          new EdgeInsets.only(left: 20.0, top: 8.0, right: 20.0, bottom: 8.0),
      child: new TextField(
        autofocus: false,
        decoration: new InputDecoration.collapsed(
          hintText: WhgStrings.repos_issue_search,
          hintStyle: WhgConstant.subSmallText,
        ),
        style: WhgConstant.middleText,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
      ),
    );
  }
}
