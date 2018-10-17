import 'package:flutter/material.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/ui/view/card_item.dart';

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
  final double elevation;
  final double height;
  final EdgeInsets margin;

  WhgSelectItemWidget(
    this.itemName,
    this.selectItemChanged, {
    this.elevation = 5.0,
    this.height = 70.0,
    this.margin = const EdgeInsets.all(10.0),
  });

  @override
  Size get preferredSize {
    return new Size.fromHeight(height);
  }

  @override
  RepositoryIssueListHeaderState createState() =>
      RepositoryIssueListHeaderState();
}

class RepositoryIssueListHeaderState extends State<WhgSelectItemWidget> {
  int selectIndex = 0;

  RepositoryIssueListHeaderState();

  _renderList() {
    List<Widget> list = new List();
    for (int i = 0; i < widget.itemName.length; i++) {
      if (i == widget.itemName.length - 1) {
        list.add(_renderItem(widget.itemName[i], i));
      } else {
        list.add(_renderItem(widget.itemName[i], i));
        list.add(new Container(
            width: 1.0,
            height: 25.0,
            color: Color(WhgColors.subLightTextColor)));
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return WhgCardItem(
        elevation: widget.elevation,
        margin: widget.margin,
        color: Theme.of(context).primaryColor,
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
        : WhgConstant.middleSubLightText;

    return Expanded(
        child: RawMaterialButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
            padding: EdgeInsets.all(10.0),
            onPressed: () {
              if (selectIndex != index) {
                //防止重复点击
                widget.selectItemChanged?.call(index);
              }
              setState(() {
                selectIndex = index;
              });
            },
            child: new Text(
              name,
              style: style,
              textAlign: TextAlign.center,
            )));
  }
}
