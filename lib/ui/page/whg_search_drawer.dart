import 'package:flutter/material.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/common/viewmodel/filter_model.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/9/8
 *
 * @Description
 *
 * PS: Stay hungry,Stay foolish.
 */

typedef void SearchSelectItemChanged<String>(String value);

class WhgSearchDrawer extends StatefulWidget {
  final SearchSelectItemChanged<String> typeCallback;
  final SearchSelectItemChanged<String> sortCallback;
  final SearchSelectItemChanged<String> languageCallback;

  WhgSearchDrawer(this.typeCallback, this.sortCallback, this.languageCallback);

  @override
  WhgSearchDrawerState createState() => WhgSearchDrawerState(
      this.typeCallback, this.sortCallback, this.languageCallback);
}

class WhgSearchDrawerState extends State<WhgSearchDrawer> {
  final double itemWidth = 200.0;

  final SearchSelectItemChanged<String> typeCallback;
  final SearchSelectItemChanged<String> sortCallback;
  final SearchSelectItemChanged<String> languageCallback;

  WhgSearchDrawerState(
      this.typeCallback, this.sortCallback, this.languageCallback);

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.white,
      child: new SingleChildScrollView(
        child: new Column(
          children: _renderList(),
        ),
      ),
    );
  }

  _renderList() {
    List<Widget> list = new List();
    list.add(new Container(
      height: 50.0,
      width: itemWidth,
    ));
    list.add(_renderTitle("类型"));
    for (int i = 0; i < searchFilterType.length; i++) {
      FilterModel model = searchFilterType[i];
      list.add(_renderItem(model, searchFilterType, i, this.typeCallback));
      list.add(_renderDivider());
    }
    list.add(_renderTitle("排序"));

    for (int i = 0; i < sortType.length; i++) {
      FilterModel model = sortType[i];
      list.add(_renderItem(model, sortType, i, this.sortCallback));
      list.add(_renderDivider());
    }
    list.add(_renderTitle("语言"));
    for (int i = 0; i < searchLanguageType.length; i++) {
      FilterModel model = searchLanguageType[i];
      list.add(
          _renderItem(model, searchLanguageType, i, this.languageCallback));
      list.add(_renderDivider());
    }
    return list;
  }

  _renderTitle(String title) {
    return new Container(
      color: Color(WhgColors.primaryValue),
      width: itemWidth + 50,
      height: 50.0,
      child: new Center(
        child: new Text(
          title,
          style: WhgConstant.middleTextWhite,
          textAlign: TextAlign.start,
        ),
      ),
    );
  }

  _renderDivider() {
    return Container(
      color: Color(WhgColors.subTextColor),
      width: itemWidth,
      height: 0.3,
    );
  }

  _renderItem(FilterModel model, List<FilterModel> list, int index,
      SearchSelectItemChanged<String> select) {
    return new Container(
      height: 50.0,
      child: new FlatButton(
        onPressed: () {
          setState(() {
            for (FilterModel model in list) {
              model.select = false;
            }
            list[index].select = true;
          });
          if (select != null) {
            select(model.value);
          }
        },
        child: new Container(
          width: itemWidth,
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Center(
                  child:
                      new Checkbox(value: model.select, onChanged: (value) {})),
              new Center(child: Text(model.name)),
            ],
          ),
        ),
      ),
    );
  }
}
