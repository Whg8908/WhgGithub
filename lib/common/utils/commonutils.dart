import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:whg_github/common/style/whg_style.dart';
import 'package:whg_github/ui/view/issue_edit_dialog.dart';
import 'package:whg_github/ui/view/whg_flex_button.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/22
 *
 * @Description   常用工具类
 *
 * PS: Stay hungry,Stay foolish.
 */
class CommonUtils {
  static final double MILLIS_LIMIT = 1000.0;

  static final double SECONDS_LIMIT = 60 * MILLIS_LIMIT;

  static final double MINUTES_LIMIT = 60 * SECONDS_LIMIT;

  static final double HOURS_LIMIT = 24 * MINUTES_LIMIT;

  static final double DAYS_LIMIT = 30 * HOURS_LIMIT;

  static String getNewsTimeStr(DateTime date) {
    int subTime =
        DateTime.now().millisecondsSinceEpoch - date.millisecondsSinceEpoch;

    if (subTime < MILLIS_LIMIT) {
      return "刚刚";
    } else if (subTime < SECONDS_LIMIT) {
      return (subTime / MILLIS_LIMIT).round().toString() + " 秒前";
    } else if (subTime < MINUTES_LIMIT) {
      return (subTime / SECONDS_LIMIT).round().toString() + " 分钟前";
    } else if (subTime < HOURS_LIMIT) {
      return (subTime / MINUTES_LIMIT).round().toString() + " 小时前";
    } else if (subTime < DAYS_LIMIT) {
      return (subTime / HOURS_LIMIT).round().toString() + " 天前";
    } else {
      return getDateStr(date);
    }
  }

  static String getDateStr(DateTime date) {
    return date.toString().substring(0, 11);
  }

  static getFullName(String repository_url) {
    if (repository_url != null &&
        repository_url.substring(repository_url.length - 1) == "/") {
      repository_url = repository_url.substring(0, repository_url.length - 1);
    }
    String fullName = '';
    if (repository_url != null) {
      List<String> splicurl = repository_url.split("/");
      if (splicurl.length > 2) {
        fullName =
            splicurl[splicurl.length - 2] + "/" + splicurl[splicurl.length - 1];
      }
    }
    return fullName;
  }

  static const IMAGE_END = [".png", ".jpg", ".jpeg", ".gif", ".svg"];

  static isImageEnd(path) {
    bool image = false;
    for (String item in IMAGE_END) {
      if (path.indexOf(item) + item.length == path.length) {
        image = true;
      }
    }
    return image;
  }

  static Future<Null> showLoadingDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: new Container(
              width: 140.0,
              height: 140.0,
              padding: new EdgeInsets.all(4.0),
              decoration: new BoxDecoration(
                color: Colors.transparent,
                //用一个BoxDecoration装饰器提供背景图片
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SpinKitCubeGrid(
                    color: Colors.white,
                  ),
                  new Container(width: 10.0),
                  new Container(
                      child: new Text(WhgStrings.loading_text,
                          style: WhgConstant.middleTextWhite)),
                ],
              ),
            ),
          );
        });
  }

  static Future<Null> showEditDialog(
    BuildContext context,
    String dialogTitle,
    ValueChanged<String> onTitleChanged,
    ValueChanged<String> onContentChanged,
    VoidCallback onPressed, {
    TextEditingController titleController,
    TextEditingController valueController,
    bool needTitle = true,
  }) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: new IssueEditDialog(
              dialogTitle,
              onTitleChanged,
              onContentChanged,
              onPressed,
              titleController: titleController,
              valueController: valueController,
              needTitle: needTitle,
            ),
          );
        });
  }

  static Future<Null> showConfirmDialog(
      BuildContext context,
      String leftTitle,
      String rightTile,
      VoidCallback onCanclePressed,
      VoidCallback onConfirmPressed) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return new Center(
            child: new Container(
              decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  color: Colors.white,
                  border: new Border.all(
                      color: Color(WhgColors.subTextColor), width: 0.3)),
              margin: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new WhgFlexButton(
                    color: Colors.white,
                    fontSize: 18.0,
                    textColor: Color(WhgColors.subTextColor),
                    text: leftTitle,
                    onPress: () {
                      if (onCanclePressed != null) {
                        onCanclePressed();
                      }
                    },
                  ),
                  Container(
                    color: Color(WhgColors.lineColor),
                    height: 0.5,
                  ),
                  new WhgFlexButton(
                    color: Colors.white,
                    fontSize: 18.0,
                    text: rightTile,
                    textColor: Color(WhgColors.subTextColor),
                    onPress: () {
                      if (onConfirmPressed != null) {
                        onConfirmPressed();
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
