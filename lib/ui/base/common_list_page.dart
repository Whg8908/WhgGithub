import 'package:flutter/material.dart';
import 'package:github/common/dao/repos_dao.dart';
import 'package:github/common/dao/user_dao.dart';
import 'package:github/common/utils/navigatorutils.dart';
import 'package:github/common/viewmodel/repos_view_model.dart';
import 'package:github/common/viewmodel/user_item_view_model.dart';
import 'package:github/ui/base/whg_list_state.dart';
import 'package:github/ui/view/repos_item.dart';
import 'package:github/ui/view/user_item.dart';
import 'package:github/ui/view/whg_pullload_widget.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/9/3
 *
 * @Description   通用的list页面
 *
 * PS: Stay hungry,Stay foolish.
 */
class CommonListPage extends StatefulWidget {
  final String userName;

  final String reposName;

  final String showType;

  final String dataType;

  final String title;

  CommonListPage(this.showType, this.dataType, this.title,
      {this.userName, this.reposName});

  @override
  CommonListPageState createState() => new CommonListPageState(
      this.showType, this.dataType, this.title, this.userName, this.reposName);
}

class CommonListPageState extends State<CommonListPage>
    with
        AutomaticKeepAliveClientMixin<CommonListPage>,
        WhgListState<CommonListPage> {
  final String userName;

  final String reposName;

  final String showType;

  final String dataType;

  final String title;

  CommonListPageState(
      this.showType, this.dataType, this.title, this.userName, this.reposName);

  @override
  bool get isRefreshFirst => true;

  @override
  bool get needHeader => false;

  @override
  bool get wantKeepAlive => true;

  @override
  requestRefresh() async {
    return await _getDataLogic();
  }

  @override
  requestLoadMore() async {
    return await _getDataLogic();
  }

  _renderItem(index) {
    if (pullLoadWidgetControl.dataList == 0) {
      return null;
    }

    var data = pullLoadWidgetControl.dataList[index];
    switch (showType) {
      case 'repository':
        ReposViewModel reposViewModel = ReposViewModel.fromMap(data);
        return new ReposItem(reposViewModel, onPressed: () {
          NavigatorUtils.goReposDetail(
              context, reposViewModel.ownerName, reposViewModel.repositoryName);
        });
      case 'user':
        return new UserItem(UserItemViewModel.fromMap(data), onPressed: () {
          NavigatorUtils.goPerson(context, data.login);
        });
      case 'org':
        return new UserItem(UserItemViewModel.fromOrgMap(data), onPressed: () {
          NavigatorUtils.goPerson(context, data.login);
        });
      case 'issue':
        return null;
      case 'release':
        return null;
      case 'notify':
        return null;
    }
  }

  _getDataLogic() async {
    switch (dataType) {
      case 'follower':
        return await UserDao.getFollowerListDao(userName, page,
            needDb: page <= 1);
      case 'followed':
        return await UserDao.getFollowedListDao(userName, page,
            needDb: page <= 1);
      case 'user_repos':
        return await ReposDao.getUserRepositoryDao(userName, page, null,
            needDb: page <= 1);
      case 'user_star':
        return await ReposDao.getStarRepositoryDao(userName, page, null,
            needDb: page <= 1);
      case 'repo_star':
        return await ReposDao.getRepositoryStarDao(userName, reposName, page,
            needDb: page <= 1);
      case 'repo_watcher':
        return await ReposDao.getRepositoryWatcherDao(userName, reposName, page,
            needDb: page <= 1);
      case 'repo_fork':
        return await ReposDao.getRepositoryForksDao(userName, reposName, page,
            needDb: page <= 1);
      case 'repo_release':
        return null;
      case 'repo_tag':
        return null;
      case 'notify':
        return null;
      case 'history':
        return await ReposDao.getHistoryDao(page);
      case 'topics':
        return await ReposDao.searchTopicRepositoryDao(userName, page: page);
      case 'user_be_stared':
        return null;
      case 'user_orgs':
        return await UserDao.getUserOrgsDao(userName, page, needDb: page <= 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: WhgPullLoadWidget(
          (BuildContext context, int index) => _renderItem(index),
          handleRefresh,
          onLoadMore,
          pullLoadWidgetControl,
          refreshKey: refreshIndicatorKey),
    );
  }
}
