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

class WhgSelectItemWidget extends StatefulWidget
    implements PreferredSizeWidget {
  final SelectItemChanged selectItemChanged;
  final List<String> itemName;

  WhgSelectItemWidget(this.itemName, this.selectItemChanged);

  @override
  Size get preferredSize {
    return new Size.fromHeight(50.0);
  }

  @override
  RepositoryIssueListHeaderState createState() =>
      RepositoryIssueListHeaderState(this.itemName, this.selectItemChanged);
}

class RepositoryIssueListHeaderState extends State<WhgSelectItemWidget> {
  int selectIndex = 0;
  final SelectItemChanged selectItemChanged;
  final List<String> itemNames;

  RepositoryIssueListHeaderState(this.itemNames, this.selectItemChanged);

  _renderList() {
    List<Widget> list = new List();
    for (int i = 0; i < itemNames.length; i++) {
      if (i == itemNames.length - 1) {
        list.add(_renderItem(itemNames[i], i));
      } else {
        list.add(_renderItem(itemNames[i], i));
        list.add(new Container(
            width: 1.0,
            height: 26.0,
            color: Color(WhgColors.subLightTextColor)));
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return WhgCardItem(
        color: Color(WhgColors.primaryValue),
        margin: EdgeInsets.all(6.0),
        shape: new RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        child: new Padding(
          padding:
              new EdgeInsets.only(left: 0.0, top: 4.0, right: 0.0, bottom: 4.0),
          child: Row(
            children: _renderList(),
          ),
        ));
  }

  Widget _renderItem(String name, int index) {
    var style = index == selectIndex
        ? WhgConstant.middleTextWhite
        : WhgConstant.middleSubText;

    return Expanded(
        child: FlatButton(
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
            )));
  }
}
