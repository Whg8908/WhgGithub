import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:whg_github/common/bean/whg_option_model.dart';
import 'package:whg_github/common/style/whg_style.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/9/12
 *
 * @Description   titlebar更多按钮
 *
 * PS: Stay hungry,Stay foolish.
 */

class WhgCommonOptionWidget extends StatelessWidget {
  List<WhgOptionModel> list = [
    new WhgOptionModel("浏览器打开", "浏览器打开", (model) {
      Fluttertoast.showToast(msg: model.name);
    }),
    new WhgOptionModel("复制链接", "复制链接", (model) {
      Fluttertoast.showToast(msg: model.name);
    }),
    new WhgOptionModel("分享", "分享", (model) {
      Fluttertoast.showToast(msg: model.name);
    }),
  ];

  @override
  Widget build(BuildContext context) {
    return _renderHeaderPopItem(list);
  }

  //item,data,select
  _renderHeaderPopItem(List<WhgOptionModel> list) {
    return new PopupMenuButton<WhgOptionModel>(
      child: new Icon(WhgICons.MORE),
      onSelected: (model) {
        model.selected(model);
      },
      itemBuilder: (BuildContext context) {
        return _renderHeaderPopItemChild(list);
      },
    );
  }

  //item view
  _renderHeaderPopItemChild(List<WhgOptionModel> data) {
    List<PopupMenuEntry<WhgOptionModel>> list = new List();
    for (WhgOptionModel item in data) {
      list.add(PopupMenuItem<WhgOptionModel>(
        value: item,
        child: new Text(item.name),
      ));
    }
    return list;
  }
}
