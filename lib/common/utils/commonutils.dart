import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_statusbar/flutter_statusbar.dart';
import 'package:get_version/get_version.dart';
import 'package:github/common/net/address.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/common/utils/fluttertoast.dart';
import 'package:github/common/utils/navigatorutils.dart';
import 'package:github/ui/view/issue_edit_dialog.dart';
import 'package:github/ui/view/whg_flex_button.dart';
import 'package:url_launcher/url_launcher.dart';

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

  static double sStaticBarHeight = 0.0;

  static void initStatusBarHeight(context) async {
    sStaticBarHeight =
        await FlutterStatusbar.height / MediaQuery.of(context).devicePixelRatio;
  }

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
    if (date == null || date.toString() == null) {
      return "";
    } else if (date.toString().length < 10) {
      return date.toString();
    }
    return date.toString().substring(0, 11);
  }

  static String getUserChartAddress(String userName) {
    return Address.graphicHost +
        WhgColors.primaryValueString.replaceAll("#", "") +
        "/" +
        userName;
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
          return new Material(
              color: Colors.transparent,
              child: WillPopScope(
                onWillPop: () => new Future.value(false),
                child: Center(
                  child: new Container(
                    width: 200.0,
                    height: 200.0,
                    padding: new EdgeInsets.all(4.0),
                    decoration: new BoxDecoration(
                      color: Colors.transparent,
                      //用一个BoxDecoration装饰器提供背景图片
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                            child: SpinKitCubeGrid(color: Colors.white)),
                        new Container(height: 10.0),
                        new Container(
                            child: new Text(WhgStrings.loading_text,
                                style: WhgConstant.normalTextWhite)),
                      ],
                    ),
                  ),
                ),
              ));
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

  static Future<Null> showCommitOptionDialog(
      BuildContext context, List commitMaps, ValueChanged<int> onTap,
      {width = 250.0, height = 400.0}) {
    print(commitMaps.length);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: new Container(
              width: width,
              height: height,
              padding: new EdgeInsets.all(4.0),
              margin: new EdgeInsets.all(20.0),
              decoration: new BoxDecoration(
                color: Colors.white,
                //用一个BoxDecoration装饰器提供背景图片
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              child: new ListView.builder(
                  itemCount: commitMaps.length,
                  itemBuilder: (context, index) {
                    return WhgFlexButton(
                      maxLines: 2,
                      mainAxisAlignment: MainAxisAlignment.start,
                      fontSize: 14.0,
                      color: Color(WhgColors.primaryValue),
                      text: commitMaps[index],
                      textColor: Color(WhgColors.white),
                      onPress: () {
                        Navigator.pop(context);
                        onTap(index);
                      },
                    );
                  }),
            ),
          );
        });
  }

  static String versionName = "";

  //简介dialog
  static void showAboutDailog(BuildContext context) {
    GetVersion.projectVersion.then((versionName) {
      versionName ??= "Null";
      showDialog(
          context: context,
          builder: (BuildContext context) => AboutDialog(
                applicationName: WhgStrings.app_name,
                applicationVersion: WhgStrings.app_version + ": " + versionName,
                applicationIcon: new Image(
                    image: new AssetImage(WhgICons.DEFAULT_USER_ICON),
                    width: 50.0,
                    height: 50.0),
                applicationLegalese: "http://github.com/Whg8908",
              ));
    });
  }

  static launchUrl(context, String url) {
    if (url == null && url.length == 0) return;
    Uri parseUrl = Uri.parse(url);

    bool isImage = isImageEnd(parseUrl.toString());
    if (parseUrl.toString().endsWith("?raw=true")) {
      isImage = isImageEnd(parseUrl.toString().replaceAll("?raw=true", ""));
    }
    if (isImage) {
      NavigatorUtils.gotoPhotoViewPage(context, url);
      return;
    }
    if (parseUrl != null &&
        parseUrl.host == "github.com" &&
        parseUrl.path.length > 0) {
      List<String> pathnames = parseUrl.path.split("/");
      if (pathnames.length == 2) {
        //解析人
        String userName = pathnames[1];
        NavigatorUtils.goPerson(context, userName);
      } else if (pathnames.length >= 3) {
        String userName = pathnames[1];
        String repoName = pathnames[2];
        //解析仓库
        if (pathnames.length == 3) {
          NavigatorUtils.goReposDetail(context, userName, repoName);
        } else {
          launchWebView(context, "", url);
        }
      }
    } else if (url != null && url.startsWith("http")) {
      launchWebView(context, "", url);
    }
  }

  static void launchWebView(BuildContext context, String title, String url) {
    if (url.startsWith("http")) {
      NavigatorUtils.goWhgWebView(context, url, title);
    } else {
      NavigatorUtils.goWhgWebView(
          context,
          new Uri.dataFromString(url,
                  mimeType: 'text/html', encoding: Encoding.getByName("utf-8"))
              .toString(),
          title);
    }
  }

  /// 单击提示退出
  static Future<bool> dialogExitApp(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => new AlertDialog(
              content: new Text(WhgStrings.app_back_tip),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text(WhgStrings.app_cancel)),
                new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: new Text(WhgStrings.app_ok))
              ],
            ));
  }

  static copy(String data) {
    Clipboard.setData(new ClipboardData(text: data));
    Fluttertoast.showToast(msg: WhgStrings.option_share_copy_success);
  }

  static launchOutURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(
          msg: WhgStrings.option_web_launcher_error + ": " + url);
    }
  }
}
