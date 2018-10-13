import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:github/common/dao/repos_dao.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/common/utils/htmlutils.dart';
import 'package:github/ui/view/whg_title_bar.dart';
import 'package:github/ui/view/whg_webview.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/9/18
 *
 * @Description   CodeDetailPageWeb
 *
 * PS: Stay hungry,Stay foolish.
 */

class CodeDetailPageWeb extends StatefulWidget {
  final String title;
  final String userName;
  final String repoName;
  final String path;
  final String data;
  final String branch;
  final String htmlUrl;

  CodeDetailPageWeb(
      {this.title,
      this.userName,
      this.repoName,
      this.path,
      this.data,
      this.branch,
      this.htmlUrl});

  @override
  CodeDetailPageWebState createState() => new CodeDetailPageWebState(
      this.title,
      this.userName,
      this.repoName,
      this.path,
      this.data,
      this.branch,
      this.htmlUrl);
}

class CodeDetailPageWebState extends State<CodeDetailPageWeb> {
  final String title;
  final String userName;
  final String repoName;
  final String path;
  String data;
  final String branch;
  final String htmlUrl;

  CodeDetailPageWebState(this.title, this.userName, this.repoName, this.path,
      this.data, this.branch, this.htmlUrl);

  @override
  void initState() {
    super.initState();
    if (data == null) {
      print("333333333");
      ReposDao.getReposFileDirDao(userName, repoName,
              path: path, branch: branch, text: true, isHtml: true)
          .then((res) {
        if (res != null && res.result) {
          String data2 = HtmlUtils.resolveHtmlFile(res, "java");
          String url = new Uri.dataFromString(data2,
                  mimeType: 'text/html', encoding: Encoding.getByName("utf-8"))
              .toString();
          setState(() {
            this.data = url;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return new Scaffold(
        appBar: new AppBar(
          title: WhgTitleBar(title),
        ),
        body: new Center(
          child: new Container(
            width: 200.0,
            height: 200.0,
            padding: new EdgeInsets.all(4.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new SpinKitDoubleBounce(color: Theme.of(context).primaryColor),
                new Container(width: 10.0),
                new Container(
                    child: new Text(WhgStrings.loading_text,
                        style: WhgConstant.middleText)),
              ],
            ),
          ),
        ),
      );
    }
    return WhgWebView(data, title);
  }
}
