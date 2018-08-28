import 'dart:async';

import 'package:flutter/material.dart';
import 'package:whg_github/common/bean/issue_item_view_model.dart';
import 'package:whg_github/common/config/config.dart';
import 'package:whg_github/common/dao/issue_dao.dart';
import 'package:whg_github/common/style/whg_style.dart';
import 'package:whg_github/ui/view/issue_item.dart';
import 'package:whg_github/ui/view/repository_issue_list_header.dart';
import 'package:whg_github/ui/view/whg_pullload_widget.dart';

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

class RepositoryDetailIssuePageState extends State<RepositoryDetailIssuePage>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  final String userName;
  final String reposName;
  String issueState;
  bool isLoading = false;
  int page = 1;
  final List dataList = List();
  final WhgPullLoadWidgetControl whgPullLoadWidgetControl =
      WhgPullLoadWidgetControl();

  RepositoryDetailIssuePageState(this.userName, this.reposName);

  @override
  bool get wantKeepAlive => true;

  Future<Null> _onRefresh() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page = 1;
    var res = await IssueDao.getRepositoryIssueDao(
        userName, reposName, issueState,
        page: page);
    if (res != null && res.result) {
      whgPullLoadWidgetControl.dataList.clear();
      setState(() {
        whgPullLoadWidgetControl.dataList.addAll(res.data);
      });
    }
    setState(() {
      whgPullLoadWidgetControl.needLoadMore = (res != null &&
          res.data != null &&
          res.data.length == Config.PAGE_SIZE);
    });
    isLoading = false;
  }

  Future<Null> _onLoadMore() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page++;
    var res = await IssueDao.getRepositoryIssueDao(
        userName, reposName, issueState,
        page: page);
    if (res != null && res.result) {
      setState(() {
        whgPullLoadWidgetControl.dataList.addAll(res.data);
      });
    }
    setState(() {
      whgPullLoadWidgetControl.needLoadMore = (res != null &&
          res.data != null &&
          res.data.length == Config.PAGE_SIZE);
    });
    isLoading = false;
    return null;
  }

  _renderEventItem(index) {
    IssueItemViewModel issueItemViewModel =
        whgPullLoadWidgetControl.dataList[index];
    return new IssueItem(
      issueItemViewModel,
      onPressed: () {},
    );
  }

  @override
  void initState() {
    super.initState();
    whgPullLoadWidgetControl.needHeader = false;
    whgPullLoadWidgetControl.dataList = dataList;
    if (whgPullLoadWidgetControl.dataList.length == 0) {
      new Future.delayed(const Duration(seconds: 0), () {
        _refreshIndicatorKey.currentState.show().then((e) {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.
    return new Scaffold(
      backgroundColor: Color(WhgColors.mainBackgroundColor),
      appBar: new AppBar(
        leading: new Container(),
        flexibleSpace: Container(
          padding: new EdgeInsets.only(
              left: 20.0, top: 12.0, right: 20.0, bottom: 12.0),
          color: Colors.white,
          child: new TextField(
              autofocus: false,
              decoration: new InputDecoration.collapsed(
                hintText: WhgStrings.repos_issue_search,
                hintStyle: WhgConstant.subSmallText,
              ),
              style: WhgConstant.smallText,
              onSubmitted: (result) {}),
        ),
        elevation: 0.0,
        backgroundColor: Color(WhgColors.mainBackgroundColor),
        bottom: new RepositoryIssueListHeader((selectIndex) {}),
      ),
      body: WhgPullLoadWidget(
        (BuildContext context, int index) => _renderEventItem(index),
        _onRefresh,
        _onLoadMore,
        whgPullLoadWidgetControl,
        refreshKey: _refreshIndicatorKey,
      ),
    );
  }
}
