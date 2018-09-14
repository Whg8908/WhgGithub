import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:whg_github/common/dao/repos_dao.dart';
import 'package:whg_github/common/style/whg_style.dart';
import 'package:whg_github/ui/page/repository_detail_page.dart';
import 'package:whg_github/ui/view/whg_markdown_widget.dart';

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
  final BranchControl branchControl;

  RepostroyDetailReadmePage(this.userName, this.reposName, this.branchControl,
      {Key key})
      : super(key: key);

  @override
  RepostroyDetailReadmePageState createState() =>
      new RepostroyDetailReadmePageState(
          this.userName, this.reposName, this.branchControl);
}

class RepostroyDetailReadmePageState extends State<RepostroyDetailReadmePage>
    with AutomaticKeepAliveClientMixin {
  final String userName;
  final String reposName;
  final BranchControl branchControl;

  bool isShow = false;
  String markdownData;

  @override
  bool get wantKeepAlive => true;

  RepostroyDetailReadmePageState(
      this.userName, this.reposName, this.branchControl);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (markdownData == null) {
      return Center(
        child: new Container(
          width: 140.0,
          height: 140.0,
          padding: new EdgeInsets.all(4.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new SpinKitDoubleBounce(color: Color(WhgColors.primaryValue)),
              new Container(width: 10.0),
              new Container(
                  child: new Text(WhgStrings.loading_text,
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
            userName, reposName, branchControl.currentBranch)
        .then((res) {
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
