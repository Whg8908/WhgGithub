import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
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
  final List<WhgOptionModel> otherList;
  final String url;

  WhgCommonOptionWidget(this.url, {this.otherList});

  @override
  Widget build(BuildContext context) {
    String text = WhgStrings.option_share_title + url;

    List<WhgOptionModel> list = [
      new WhgOptionModel(WhgStrings.option_web, WhgStrings.option_web, (model) {
        _launchURL();
      }),
      new WhgOptionModel(WhgStrings.option_copy, WhgStrings.option_copy,
          (model) {
        Clipboard.setData(new ClipboardData(text: url));
        Fluttertoast.showToast(msg: WhgStrings.option_share_copy_success);
      }),
      new WhgOptionModel(WhgStrings.option_share, WhgStrings.option_share,
          (model) {
        Share.share(text);
      }),
    ];
    return _renderHeaderPopItem(list);
  }

  _launchURL() async {
    //url_launcher
    if (await canLaunch(url)) {
      print(url);
      await launch(url);
    } else {
      Fluttertoast.showToast(
          msg: WhgStrings.option_web_launcher_error + ": " + url);
    }
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
