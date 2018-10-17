import 'package:flutter/material.dart';
import 'package:github/common/bean/RepoCommit.dart';
import 'package:github/common/bean/Repository.dart';
import 'package:github/common/dao/repos_dao.dart';
import 'package:github/common/utils/eventutils.dart';
import 'package:github/common/utils/navigatorutils.dart';
import 'package:github/common/viewmodel/event_view_model.dart';
import 'package:github/common/viewmodel/repos_header_view_model.dart';
import 'package:github/ui/base/whg_list_state.dart';
import 'package:github/ui/page/repository_detail_page.dart';
import 'package:github/ui/view/event_item.dart';
import 'package:github/ui/view/repos_header_item.dart';
import 'package:github/ui/view/whg_pullload_widget.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/27
 *
 * @Description   仓库详情动态信息
 *
 * PS: Stay hungry,Stay foolish.
 */
class RepositoryDetailInfoListPage extends StatefulWidget {
  final ReposDetailInfoPageControl reposDetailInfoPageControl;
  final String userName;
  final String reposName;
  final ReposDetailParentControl reposDetailParentControl;

  RepositoryDetailInfoListPage(this.reposDetailInfoPageControl, this.userName,
      this.reposName, this.reposDetailParentControl,
      {Key key})
      : super(key: key);

  @override
  RepositoryDetailInfoPageState createState() =>
      new RepositoryDetailInfoPageState(reposDetailInfoPageControl, userName,
          reposName, this.reposDetailParentControl);
}

class RepositoryDetailInfoPageState extends State<RepositoryDetailInfoListPage>
    with
        AutomaticKeepAliveClientMixin<RepositoryDetailInfoListPage>,
        WhgListState<RepositoryDetailInfoListPage> {
  final ReposDetailInfoPageControl reposDetailInfoPageControl;
  final String userName;
  final String reposName;
  final ReposDetailParentControl reposDetailParentControl;

  int selectIndex = 0;

  RepositoryDetailInfoPageState(this.reposDetailInfoPageControl, this.userName,
      this.reposName, this.reposDetailParentControl);

  @protected
  requestRefresh() async {
    _getReposDetail();
    return await _getDataLogic();
  }

  _getReposDetail() {
    ReposDao.getRepositoryDetailDao(
            userName, reposName, reposDetailParentControl.currentBranch)
        .then((result) {
      if (result != null && result.result) {
        setState(() {
          reposDetailInfoPageControl.repository = result.data;
        });
        return result.next;
      }
      return new Future.value(null);
    }).then((result) {
      if (result != null && result.result) {
        setState(() {
          reposDetailInfoPageControl.repository = result.data;
        });
      }
    });
  }

  @protected
  requestLoadMore() async {
    return await _getDataLogic();
  }

  _renderEventItem(index) {
    if (index == 0) {
      return new ReposHeaderItem(
          ReposHeaderViewModel.fromHttpMap(
              userName, reposName, reposDetailInfoPageControl.repository),
          (index) {
        selectIndex = index;
        clearData();
        showRefreshLoading();
      });
    }

    if (selectIndex == 1) {
      return new EventItem(
        EventViewModel.fromCommitMap(pullLoadWidgetControl.dataList[index - 1]),
        onPressed: () {
          RepoCommit model = pullLoadWidgetControl.dataList[index - 1];
          NavigatorUtils.goPushDetailPage(
              context, userName, reposName, model.sha, false);
        },
        needImage: false,
      );
    }
    return new EventItem(
      EventViewModel.fromEventMap(pullLoadWidgetControl.dataList[index - 1]),
      onPressed: () {
        EventUtils.ActionUtils(
            context,
            pullLoadWidgetControl.dataList[index - 1],
            userName + "/" + reposName);
      },
    );
  }

  _getDataLogic() async {
    if (selectIndex == 1) {
      return await ReposDao.getReposCommitsDao(userName, reposName,
          page: page,
          branch: reposDetailParentControl.currentBranch,
          needDb: page <= 1);
    }
    return await ReposDao.getRepositoryEventDao(userName, reposName,
        page: page,
        branch: reposDetailParentControl.currentBranch,
        needDb: page <= 1);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.
    return WhgPullLoadWidget(
      (BuildContext context, int index) => _renderEventItem(index),
      handleRefresh,
      onLoadMore,
      pullLoadWidgetControl,
      refreshKey: refreshIndicatorKey,
    );
  }

  @override
  bool get needHeader => true;

  @override
  bool get isRefreshFirst => true;
}

class ReposDetailInfoPageControl {
  Repository repository = Repository.empty();
}
