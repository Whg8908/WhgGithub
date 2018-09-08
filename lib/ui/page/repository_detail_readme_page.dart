import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:whg_github/common/dao/repos_dao.dart';
import 'package:whg_github/ui/page/repository_detail_page.dart';

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

class RepostroyDetailReadmePageState extends State<RepostroyDetailReadmePage> {
  final String userName;
  final String reposName;
  final BranchControl branchControl;

  bool isShow = false;
  String markdownData = "";

  RepostroyDetailReadmePageState(
      this.userName, this.reposName, this.branchControl);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: MarkdownBody(data: markdownData),
        ));
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
