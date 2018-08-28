import 'package:flutter/material.dart';
import 'package:whg_github/common/dao/repos_dao.dart';
import 'package:whg_github/common/style/whg_style.dart';
import 'package:whg_github/ui/page/repository_detail_info_page.dart';
import 'package:whg_github/ui/page/repository_detail_readme_page.dart';
import 'package:whg_github/ui/view/whg_tabbar_widget.dart';

class RepositoryDetailPage extends StatefulWidget {
  final String userName;
  final String reposName;

  RepositoryDetailPage(this.userName, this.reposName);

  @override
  RepositoryDetailPageState createState() =>
      new RepositoryDetailPageState(userName, reposName);
}

class RepositoryDetailPageState extends State<RepositoryDetailPage>
    with AutomaticKeepAliveClientMixin {
  final String userName;
  final String reposName;

  final ReposDetailInfoPageControl reposDetailInfoPageControl =
      new ReposDetailInfoPageControl();

  RepositoryDetailPageState(this.userName, this.reposName);

  _getReposDetail() async {
    var result = await ReposDao.getRepositoryDetailDao(userName, reposName);
    if (result != null && result.result) {
      setState(() {
        reposDetailInfoPageControl.reposHeaderViewModel = result.data;
      });
    }
  }

  @override
  void didChangeDependencies() {
    this._getReposDetail();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return new WhgTabBarWidget(
        type: WhgTabBarWidget.TOP_TAB,
        tabItems: [
          new Tab(text: WhgStrings.repos_tab_readme),
          new Tab(text: WhgStrings.repos_tab_info),
          new Tab(text: WhgStrings.repos_tab_file),
          new Tab(text: WhgStrings.repos_tab_issue),
        ],
        tabViews: [
          RepostroyDetailReadmePage(),
          RepositoryDetailInfoPage(
              reposDetailInfoPageControl, userName, reposName),
          new Icon(WhgICons.MAIN_DT),
          new Icon(WhgICons.MAIN_DT),
          new Icon(WhgICons.MAIN_DT),
        ],
        backgroundColor: WhgColors.primarySwatch,
        indicatorColor: Colors.white,
        title: reposName);
  }

  @override
  bool get wantKeepAlive => true;
}
