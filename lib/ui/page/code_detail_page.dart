import 'package:flutter/material.dart';
import 'package:whg_github/common/dao/repos_dao.dart';
import 'package:whg_github/common/net/address.dart';
import 'package:whg_github/common/style/whg_style.dart';
import 'package:whg_github/ui/view/whg_common_option_widget.dart';
import 'package:whg_github/ui/view/whg_markdown_widget.dart';
import 'package:whg_github/ui/view/whg_title_bar.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/9/8
 *
 * @Description  CodeDetailPage
 *
 * PS: Stay hungry,Stay foolish.
 */

class CodeDetailPage extends StatefulWidget {
  final String userName;

  final String reposName;

  final String path;

  final String data;

  final String title;

  final String branch;

  CodeDetailPage(
      {this.userName,
      this.reposName,
      this.path,
      this.data,
      this.title,
      this.branch});

  @override
  CodeDetailPageState createState() => new CodeDetailPageState(this.userName,
      this.reposName, this.path, this.data, this.title, this.branch);
}

class CodeDetailPageState extends State<CodeDetailPage> {
  final String userName;

  final String reposName;

  final String path;

  String data;

  final String title;

  final String branch;

  CodeDetailPageState(this.userName, this.reposName, this.path, this.data,
      this.title, this.branch);

  @override
  void initState() {
    super.initState();
    if (data == null) {
      ReposDao.getReposFileDirDao(userName, reposName,
              path: path, branch: branch, text: true)
          .then((res) {
        if (res != null && res.result) {
          setState(() {
            data = res.data;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentBranch = ((branch == null) ? "" : ("/" + branch));
    String url = Address.hostWeb +
        userName +
        "/" +
        reposName +
        "/blob" +
        currentBranch +
        path;

    Widget widget = (data == null)
        ? new Center(
            child: new Container(
              width: 140.0,
              height: 140.0,
              padding: new EdgeInsets.all(4.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new CircularProgressIndicator(),
                  new Container(width: 10.0),
                  new Container(
                      child: new Text(WhgStrings.loading_text,
                          style: WhgConstant.middleText)),
                ],
              ),
            ),
          )
        : new WhgMarkdownWidget(markdownData: data);

    return new Scaffold(
      appBar: AppBar(
        title: new WhgTitleBar(
          title,
          needRightLocalIcon: false,
          rightWidget: WhgCommonOptionWidget(url),
        ),
      ),
      body: widget,
    );
  }
}
