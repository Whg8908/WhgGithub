import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_statusbar/flutter_statusbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_version/get_version.dart';
import 'package:github/common/config/config.dart';
import 'package:github/common/delegate/whg_localizations.dart';
import 'package:github/common/local/local_storage.dart';
import 'package:github/common/net/address.dart';
import 'package:github/common/redux/local_redux.dart';
import 'package:github/common/redux/themedata_redux.dart';
import 'package:github/common/redux/whg_state.dart';
import 'package:github/common/style/whg_string_base.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/common/utils/navigatorutils.dart';
import 'package:github/ui/view/issue_edit_dialog.dart';
import 'package:github/ui/view/whg_flex_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:redux/redux.dart';
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
                            child:
                                SpinKitCubeGrid(color: Color(WhgColors.white))),
                        new Container(height: 10.0),
                        new Container(
                            child: new Text(
                                CommonUtils.getLocale(context).loading_text,
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
                    color: Color(WhgColors.white),
                    height: 0.5,
                  ),
                  new WhgFlexButton(
                    color: Color(WhgColors.white),
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
    BuildContext context,
    List commitMaps,
    ValueChanged<int> onTap, {
    width = 250.0,
    height = 400.0,
    List<Color> colorList,
  }) {
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
                color: Color(WhgColors.white),
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
                      color: colorList != null
                          ? colorList[index]
                          : Theme.of(context).primaryColor,
                      text: commitMaps[index],
                      textColor: Theme.of(context).primaryColor,
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
                applicationName: CommonUtils.getLocale(context).app_name,
                applicationVersion: CommonUtils.getLocale(context).app_version +
                    ": " +
                    versionName,
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
              content: new Text(CommonUtils.getLocale(context).app_back_tip),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text(CommonUtils.getLocale(context).app_cancel)),
                new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: new Text(CommonUtils.getLocale(context).app_ok))
              ],
            ));
  }

  static copy(String data, BuildContext context) {
    Clipboard.setData(new ClipboardData(text: data));
    Fluttertoast.showToast(
        msg: CommonUtils.getLocale(context).option_share_copy_success);
  }

  static launchOutURL(String url, BuildContext context) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(
          msg: CommonUtils.getLocale(context).option_web_launcher_error +
              ": " +
              url);
    }
  }

  static showLanguageDialog(BuildContext context, Store store) {
    List<String> list = [
      CommonUtils.getLocale(context).home_language_default,
      CommonUtils.getLocale(context).home_language_zh,
      CommonUtils.getLocale(context).home_language_en,
    ];
    CommonUtils.showCommitOptionDialog(context, list, (index) {
      CommonUtils.changeLocale(store, index);
      LocalStorage.put(Config.LOCALE, index.toString());
    }, colorList: CommonUtils.getThemeListColor(), height: 150.0);
  }

  static pushTheme(Store store, int index) {
    ThemeData themeData;
    List<Color> colors = getThemeListColor();
    themeData = new ThemeData(
        primarySwatch: colors[index], platform: TargetPlatform.iOS);
    store.dispatch(new RefreshThemeDataAction(themeData));
  }

  static List<Color> getThemeListColor() {
    return [
      WhgColors.primarySwatch,
      Colors.brown,
      Colors.blue,
      Colors.teal,
      Colors.amber,
      Colors.blueGrey,
      Colors.deepOrange,
    ];
  }

  /**
   * 切换语言
   */
  static changeLocale(Store<WhgState> store, int index) {
    Locale locale = store.state.platformLocale;
    switch (index) {
      case 1:
        locale = Locale('zh', 'CH');
        break;
      case 2:
        locale = Locale('en', 'US');
        break;
    }
    store.dispatch(RefreshLocaleAction(locale));
  }

  static WhgStringBase getLocale(BuildContext context) {
    return WhgLocalizations.of(context).currentLocalized;
  }

//  static getLocalPath() async {
//    Directory appDir;
//    if (Platform.isIOS) {
//      appDir = await getApplicationDocumentsDirectory();
//    } else {
//      appDir = await getExternalStorageDirectory();
//    }
//
//    List<Permissions> permissions =
//        await Permission.getPermissionStatus([PermissionName.Storage]);
//    permissions.forEach((permission) async {
//      if (permission.permissionStatus != PermissionStatus.allow) {
//        final res =
//            await Permission.requestSinglePermission(PermissionName.Storage);
//        if (res != PermissionStatus.allow) {
//          return null;
//        }
//      }
//    });
//
//    String appDocPath = appDir.path + "/whggithubappflutter";
//    Directory appPath = Directory(appDocPath);
//    await appPath.create(recursive: true);
//    return appPath;
//  }

  static getLocalPath() async {
    Directory appDir;
    if (Platform.isIOS) {
      appDir = await getApplicationDocumentsDirectory();
    } else {
      appDir = await getExternalStorageDirectory();
    }
    PermissionStatus permission = null;
    if (Platform.isAndroid) {
      permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
    } else {
      permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.photos);
    }

    if (permission != PermissionStatus.granted) {
      Map<PermissionGroup, PermissionStatus> permissions = null;
      if (Platform.isAndroid) {
        permissions = await PermissionHandler()
            .requestPermissions([PermissionGroup.storage]);
      } else {
        permissions = await PermissionHandler()
            .requestPermissions([PermissionGroup.photos]);
      }

      if (Platform.isAndroid) {
        if (permissions[PermissionGroup.storage] != PermissionStatus.granted) {
          return null;
        }
      } else {
        if (permissions[PermissionGroup.photos] != PermissionStatus.granted) {
          return null;
        }
      }
    }
    String appDocPath = appDir.path + "/gsygithubappflutter";
    Directory appPath = Directory(appDocPath);
    await appPath.create(recursive: true);
    return appPath;
  }

  static saveImage(String url) async {
    Future<String> _findPath(String imageUrl) async {
      final cache = await CacheManager.getInstance();
      final file = await cache.getFile(imageUrl);
      if (file == null) {
        return null;
      }
      Directory localPath = await CommonUtils.getLocalPath();
      if (localPath == null) {
        return null;
      }
      final name = splitFileNameByPath(file.path);
      final result = await file.copy(localPath.path + name);
      return result.path;
    }

    return _findPath(url);
  }

  static splitFileNameByPath(String path) {
    return path.substring(path.lastIndexOf("/"));
  }
}
