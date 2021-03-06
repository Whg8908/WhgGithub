import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/common/utils/commonutils.dart';
import 'package:github/common/viewmodel/whg_option_model.dart';
import 'package:share/share.dart';

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
  final List<WhgOptionModel> otherList;

  final String url;

  WhgCommonOptionWidget(this.url, {this.otherList});

  @override
  Widget build(BuildContext context) {
    String text = CommonUtils.getLocale(context).option_share_title + url;

    List<WhgOptionModel> list = [
      new WhgOptionModel(CommonUtils.getLocale(context).option_web,
          CommonUtils.getLocale(context).option_web, (model) {
        CommonUtils.launchOutURL(url, context);
      }),
      new WhgOptionModel(CommonUtils.getLocale(context).option_copy,
          CommonUtils.getLocale(context).option_copy, (model) {
        Clipboard.setData(new ClipboardData(text: url));
        Fluttertoast.showToast(
            msg: CommonUtils.getLocale(context).option_share_copy_success);
      }),
      new WhgOptionModel(CommonUtils.getLocale(context).option_share,
          CommonUtils.getLocale(context).option_share, (model) {
        Share.share(text);
      }),
    ];

    if (otherList != null && otherList.length > 0) {
      list.addAll(otherList);
    }
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
