import 'package:flutter/material.dart';
import 'package:whg_github/common/style/whg_style.dart';
import 'package:whg_github/ui/view/card_item.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/28
 *
 * @Description 详情issue列表头部，PreferredSizeWidget
 *
 * PS: Stay hungry,Stay foolish.
 */

typedef void SelectItemChanged<int>(int value);

class RepositoryIssueListHeader extends StatefulWidget
    implements PreferredSizeWidget {
  final SelectItemChanged selectItemChanged;

  RepositoryIssueListHeader(this.selectItemChanged);

  @override
  Size get preferredSize {
    return new Size.fromHeight(50.0);
  }

  @override
  RepositoryIssueListHeaderState createState() =>
      RepositoryIssueListHeaderState(selectItemChanged);
}

class RepositoryIssueListHeaderState extends State<RepositoryIssueListHeader> {
  int selectIndex = 0;
  final SelectItemChanged selectItemChanged;

  RepositoryIssueListHeaderState(this.selectItemChanged);

  @override
  Widget build(BuildContext context) {
    return WhgCardItem(
        color: Color(WhgColors.primaryValue),
        margin: EdgeInsets.all(10.0),
        shape: new RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        child: new Padding(
            padding: new EdgeInsets.only(
                left: 0.0, top: 5.0, right: 0.0, bottom: 5.0),
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: _renderItem(WhgStrings.repos_tab_issue_all, 0),
                ),
                new Container(
                    width: 1.0,
                    height: 30.0,
                    color: Color(WhgColors.subLightTextColor)),
                new Expanded(
                    child: _renderItem(WhgStrings.repos_tab_issue_open, 1)),
                new Container(
                    width: 1.0,
                    height: 30.0,
                    color: Color(WhgColors.subLightTextColor)),
                new Expanded(
                  child: _renderItem(WhgStrings.repos_tab_issue_closed, 2),
                ),
              ],
            )));
  }

  _renderItem(String name, int index) {
    var style = index == selectIndex
        ? WhgConstant.middleTextWhite
        : WhgConstant.middleSubText;

    return FlatButton(
        onPressed: () {
          setState(() {
            selectIndex = index;
          });
          if (selectItemChanged != null) {
            selectItemChanged(index);
          }
        },
        child: new Text(
          name,
          style: style,
          textAlign: TextAlign.center,
        ));
  }
}
