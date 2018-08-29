import 'package:flutter/material.dart';
import 'package:whg_github/common/bean/issue_item_view_model.dart';
import 'package:whg_github/common/dao/issue_dao.dart';
import 'package:whg_github/common/style/whg_style.dart';
import 'package:whg_github/ui/base/whg_list_state.dart';
import 'package:whg_github/ui/view/issue_item.dart';
import 'package:whg_github/ui/view/repository_issue_list_header.dart';
import 'package:whg_github/ui/view/whg_pullload_widget.dart';
import 'package:whg_github/ui/view/whg_search_input_widget.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/28
 *
 * @Description issue列表页面
 *
 * PS: Stay hungry,Stay foolish.
 */

class RepositoryDetailIssuePage extends StatefulWidget {
  final String userName;
  final String reposName;

  RepositoryDetailIssuePage(this.userName, this.reposName);

  @override
  RepositoryDetailIssuePageState createState() =>
      new RepositoryDetailIssuePageState(userName, reposName);
}

class RepositoryDetailIssuePageState
    extends WhgListState<RepositoryDetailIssuePage> {
  final String userName;
  final String reposName;
  String issueState;
  String searchText;
  int selectIndex;

  RepositoryDetailIssuePageState(this.userName, this.reposName);

  @override
  bool get wantKeepAlive => true;

  @protected
  requestRefresh() async {
    return await _getDataLogic(this.searchText);
  }

  @protected
  requestLoadMore() async {
    return await _getDataLogic(this.searchText);
  }

  _getDataLogic(String searchString) async {
    if (searchString == null || searchString.trim().length == 0) {
      return await IssueDao.getRepositoryIssueDao(
          userName, reposName, issueState,
          page: page);
    }
    return await IssueDao.searchRepositoryIssue(
        searchString, userName, reposName, this.issueState,
        page: this.page);
  }

  _renderEventItem(index) {
    IssueItemViewModel issueItemViewModel =
        pullLoadWidgetControl.dataList[index];
    return new IssueItem(
      issueItemViewModel,
      onPressed: () {},
    );
  }

  //type选择来刷新数据
  _resolveSelectIndex() {
    clearData();
    switch (selectIndex) {
      case 0:
        issueState = null;
        break;
      case 1:
        issueState = 'open';
        break;
      case 2:
        issueState = "closed";
        break;
    }
    showRefreshLoading();
  }

  @override
  bool get isRefreshFirst => true;

  @override
  bool get needHeader => false;

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.
    return new Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          WhgICons.ISSUE_ITEM_ADD,
          size: 55.0,
          color: Color(WhgColors.textWhite),
        ),
      ),
      backgroundColor: Color(WhgColors.mainBackgroundColor),
      appBar: new AppBar(
        leading: new Container(),
        flexibleSpace: WhgSearchInputWidget((value) {
          this.searchText = value;
        }, (value) {
          _resolveSelectIndex();
        }),
        elevation: 0.0,
        backgroundColor: Color(WhgColors.mainBackgroundColor),
        bottom: new WhgSelectItemWidget([
          WhgStrings.repos_tab_issue_all,
          WhgStrings.repos_tab_issue_open,
          WhgStrings.repos_tab_issue_closed,
        ], (selectIndex) {
          this.selectIndex = selectIndex;
          _resolveSelectIndex();
        }),
      ),
      body: WhgPullLoadWidget(
        (BuildContext context, int index) => _renderEventItem(index),
        handleRefresh,
        onLoadMore,
        pullLoadWidgetControl,
        refreshKey: refreshIndicatorKey,
      ),
    );
  }
}
