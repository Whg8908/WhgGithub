import 'package:flutter/material.dart';
import 'package:whg_github/common/dao/repos_dao.dart';
import 'package:whg_github/common/utils/navigatorutils.dart';
import 'package:whg_github/ui/base/whg_list_state.dart';
import 'package:whg_github/ui/view/repos_item.dart';
import 'package:whg_github/ui/view/whg_pullload_widget.dart';

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

class CommonListPageState extends WhgListState<CommonListPage> {
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
  bool get needHeader => true;

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
    var data = pullLoadWidgetControl.dataList[index];
    switch (showType) {
      case 'repository':
        return new ReposItem(data, onPressed: () {
          NavigatorUtils.goReposDetail(
              context, data.ownerName, data.repositoryName);
        });
      case 'user':
        return null;
      case 'org':
        return null;
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
        return null;
      case 'followed':
        return null;
      case 'user_repos':
        return await ReposDao.getUserRepositoryDao(userName, page, null);
      case 'user_star':
        return await ReposDao.getStarRepositoryDao(userName, page, null);
      case 'repo_star':
        return null;
      case 'repo_watcher':
        return null;
      case 'repo_fork':
        return await ReposDao.getRepositoryForksDao(userName, reposName, page);
      case 'repo_release':
        return null;
      case 'repo_tag':
        return null;
      case 'notify':
        return null;
      case 'history':
        return null;
      case 'topics':
        return null;
      case 'user_be_stared':
        return null;
      case 'user_orgs':
        return null;
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
