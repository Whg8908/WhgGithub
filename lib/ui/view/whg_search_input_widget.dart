import 'package:flutter/material.dart';
import 'package:github/common/style/whg_style.dart';

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

  final VoidCallback onSubmitPressed;

  WhgSearchInputWidget(this.onChanged, this.onSubmitted, this.onSubmitPressed);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
          border:
              new Border.all(color: Theme.of(context).primaryColor, width: 0.3),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).primaryColorDark, blurRadius: 4.0)
          ]),
      padding:
          new EdgeInsets.only(left: 20.0, top: 8.0, right: 20.0, bottom: 8.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
                  autofocus: false,
                  decoration: new InputDecoration.collapsed(
                    hintText: WhgStrings.repos_issue_search,
                    hintStyle: WhgConstant.middleSubText,
                  ),
                  style: WhgConstant.middleText,
                  onChanged: onChanged,
                  onSubmitted: onSubmitted)),
          new RawMaterialButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.only(right: 5.0, left: 10.0),
              constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
              child: new Icon(
                WhgICons.SEARCH,
                size: 15.0,
                color: Theme.of(context).primaryColorDark,
              ),
              onPressed: onSubmitPressed)
        ],
      ),
    );
  }
}
