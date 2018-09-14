import 'package:flutter/material.dart';
import 'package:whg_github/common/bean/event_view_model.dart';
import 'package:whg_github/common/bean/repos_header_view_model.dart';
import 'package:whg_github/common/dao/repos_dao.dart';
import 'package:whg_github/common/utils/eventutils.dart';
import 'package:whg_github/common/utils/navigatorutils.dart';
import 'package:whg_github/ui/base/whg_list_state.dart';
import 'package:whg_github/ui/page/repository_detail_page.dart';
import 'package:whg_github/ui/view/event_item.dart';
import 'package:whg_github/ui/view/repos_header_item.dart';
import 'package:whg_github/ui/view/whg_pullload_widget.dart';

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
  final BranchControl branchControl;

  RepositoryDetailInfoListPage(this.reposDetailInfoPageControl, this.userName,
      this.reposName, this.branchControl,
      {Key key})
      : super(key: key);

  @override
  RepositoryDetailInfoPageState createState() =>
      new RepositoryDetailInfoPageState(
          reposDetailInfoPageControl, userName, reposName, this.branchControl);
}

class RepositoryDetailInfoPageState
    extends WhgListState<RepositoryDetailInfoListPage> {
  final ReposDetailInfoPageControl reposDetailInfoPageControl;
  final String userName;
  final String reposName;
  final BranchControl branchControl;

  int selectIndex = 0;

  RepositoryDetailInfoPageState(this.reposDetailInfoPageControl, this.userName,
      this.reposName, this.branchControl);

  @protected
  requestRefresh() async {
    return await _getDataLogic();
  }

  @protected
  requestLoadMore() async {
    return await _getDataLogic();
  }

  _renderEventItem(index) {
    if (index == 0) {
      return new ReposHeaderItem(
          reposDetailInfoPageControl.reposHeaderViewModel, (index) {
        selectIndex = index;
        clearData();
        showRefreshLoading();
      });
    }

    EventViewModel eventViewModel = pullLoadWidgetControl.dataList[index - 1];

    if (selectIndex == 1) {
      return new EventItem(
        eventViewModel,
        onPressed: () {
          EventViewModel model = pullLoadWidgetControl.dataList[index - 1];
          var map = model.eventMap;
          NavigatorUtils.goPushDetailPage(
              context, userName, reposName, map["sha"], false);
        },
        needImage: false,
      );
    }

    return new EventItem(eventViewModel, onPressed: () {
      EventUtils.ActionUtils(
          context, eventViewModel.eventMap, userName + "/" + reposName);
    }, needImage: true);
  }

  _getDataLogic() async {
    if (selectIndex == 1) {
      return await ReposDao.getReposCommitsDao(userName, reposName,
          page: page, branch: branchControl.currentBranch);
    }
    return await ReposDao.getRepositoryEventDao(userName, reposName,
        page: page, branch: branchControl.currentBranch);
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
  ReposHeaderViewModel reposHeaderViewModel = new ReposHeaderViewModel();
}
