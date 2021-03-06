import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github/ui/base/common_list_page.dart';
import 'package:github/ui/page/code_detail_page.dart';
import 'package:github/ui/page/code_detail_page_web.dart';
import 'package:github/ui/page/home_page.dart';
import 'package:github/ui/page/issue_detail_page.dart';
import 'package:github/ui/page/login_page.dart';
import 'package:github/ui/page/notify_page.dart';
import 'package:github/ui/page/person_page.dart';
import 'package:github/ui/page/photo_view_page.dart';
import 'package:github/ui/page/push_detail_page.dart';
import 'package:github/ui/page/release_page.dart';
import 'package:github/ui/page/repository_detail_page.dart';
import 'package:github/ui/page/search_page.dart';
import 'package:github/ui/page/user_profile_page.dart';
import 'package:github/ui/view/whg_webview.dart';

class NavigatorUtils {
  static pushReplacementNamed(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  static pushNamed(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  static goHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, HomePage.sName);
  }

  static goLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, LoginPage.sName);
  }

  static goPerson(BuildContext context, String userName) {
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new PersonPage(userName)));
  }

  ///仓库详情
  static Future<Null> goReposDetail(
      BuildContext context, String userName, String reposName) {
    return Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) =>
                new RepositoryDetailPage(userName, reposName)));
  }

  ///issue详情
  static Future<Null> goIssueDetail(
      BuildContext context, String userName, String reposName, String num,
      {bool needRightLocalIcon = false}) {
    return Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new IssueDetailPage(
                  userName,
                  reposName,
                  num,
                  needHomeIcon: needRightLocalIcon,
                )));
  }

  ///通用列表
  static gotoCommonList(
      BuildContext context, String title, String showType, String dataType,
      {String userName, String reposName}) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new CommonListPage(
                  showType,
                  dataType,
                  title,
                  userName: userName,
                  reposName: reposName,
                )));
  }

  ///文件代码详情
  static gotoCodeDetailPage(BuildContext context,
      {String title,
      String userName,
      String reposName,
      String path,
      String data,
      String branch,
      String htmlUrl}) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new CodeDetailPage(
                  title: title,
                  userName: userName,
                  reposName: reposName,
                  path: path,
                  data: data,
                  branch: branch,
                  htmlUrl: htmlUrl,
                )));
  }

  ///仓库详情通知
  static Future<Null> goNotifyPage(BuildContext context) {
    return Navigator.push(
        context, new MaterialPageRoute(builder: (context) => new NotifyPage()));
  }

  ///搜索
  static Future<Null> goSearchPage(BuildContext context) {
    return Navigator.push(
        context, new MaterialPageRoute(builder: (context) => new SearchPage()));
  }

  ///提交详情
  static Future<Null> goPushDetailPage(BuildContext context, String userName,
      String reposName, String sha, bool needHomeIcon) {
    return Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new PushDetailPage(
                  sha,
                  userName,
                  reposName,
                  needHomeIcon: needHomeIcon,
                )));
  }

  ///全屏Web页面
  static Future<Null> goWhgWebView(
      BuildContext context, String url, String title) {
    return Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new WhgWebView(url, title),
      ),
    );
  }

  ///文件代码详情Web
  static gotoCodeDetailPageWeb(BuildContext context,
      {String title,
      String userName,
      String repoName,
      String path,
      String data,
      String branch,
      String htmlUrl}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CodeDetailPageWeb(
                title: title,
                userName: userName,
                repoName: repoName,
                path: path,
                data: data,
                branch: branch,
                htmlUrl: htmlUrl)));
  }

  ///仓库版本列表
  static Future<Null> goReleasePage(
      BuildContext context, String userName, String reposName) {
    return Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new ReleasePage(userName, reposName)));
  }

  ///根据平台跳转文件代码详情Web
  static gotoCodeDetailPlatform(BuildContext context,
      {String title,
      String userName,
      String reposName,
      String path,
      String data,
      String branch,
      String htmlUrl}) {
    if (Platform.isIOS) {
      NavigatorUtils.gotoCodeDetailPage(
        context,
        title: title,
        reposName: reposName,
        userName: userName,
        path: path,
        branch: branch,
      );
    } else {
      NavigatorUtils.gotoCodeDetailPageWeb(
        context,
        title: title,
        repoName: reposName,
        userName: userName,
        path: path,
        branch: branch,
      );
    }
  }

  ///图片预览
  static gotoPhotoViewPage(BuildContext context, String url) {
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new PhotoViewPage(url)));
  }

  ///用户配置
  static gotoUserProfileInfo(BuildContext context) {
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new UserProfileInfo()));
  }
}
