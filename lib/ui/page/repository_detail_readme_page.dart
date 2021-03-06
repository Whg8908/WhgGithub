import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:github/common/dao/repos_dao.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/common/utils/commonutils.dart';
import 'package:github/ui/page/repository_detail_page.dart';
import 'package:github/ui/view/whg_markdown_widget.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/27
 *
 * @Description
 *
 * PS: Stay hungry,Stay foolish.
 */
class RepostroyDetailReadmePage extends StatefulWidget {
  final String userName;
  final String reposName;
  final ReposDetailParentControl reposDetailParentControl;

  RepostroyDetailReadmePage(
      this.userName, this.reposName, this.reposDetailParentControl,
      {Key key})
      : super(key: key);

  @override
  RepostroyDetailReadmePageState createState() =>
      new RepostroyDetailReadmePageState(
          this.userName, this.reposName, this.reposDetailParentControl);
}

class RepostroyDetailReadmePageState extends State<RepostroyDetailReadmePage>
    with AutomaticKeepAliveClientMixin {
  final String userName;
  final String reposName;
  final ReposDetailParentControl reposDetailParentControl;

  bool isShow = false;
  String markdownData;

  @override
  bool get wantKeepAlive => true;

  RepostroyDetailReadmePageState(
      this.userName, this.reposName, this.reposDetailParentControl);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (markdownData == null) {
      return Center(
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
                  child: new Text(CommonUtils.getLocale(context).loading_text,
                      style: WhgConstant.middleText)),
            ],
          ),
        ),
      );
    }
    return WhgMarkdownWidget(markdownData: markdownData);
  }

  @override
  void initState() {
    isShow = true;
    super.initState();
    refreshReadme();
  }

  @override
  void dispose() {
    isShow = false;
    super.dispose();
  }

  refreshReadme() {
    ReposDao.getRepositoryDetailReadmeDao(
            userName, reposName, reposDetailParentControl.currentBranch)
        .then((res) {
      if (res != null && res.result) {
        if (isShow) {
          setState(() {
            markdownData = res.data;
          });
          return res.next;
        }
      }
      return new Future.value(null);
    }).then((res) {
      if (res != null && res.result) {
        if (isShow) {
          setState(() {
            markdownData = res.data;
          });
        }
      }
    });
  }
}
