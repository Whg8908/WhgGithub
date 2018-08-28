import 'dart:async';

import 'package:flutter/material.dart';
import 'package:whg_github/common/bean/event_view_model.dart';
import 'package:whg_github/common/bean/repos_header_view_model.dart';
import 'package:whg_github/common/config/config.dart';
import 'package:whg_github/common/dao/repos_dao.dart';
import 'package:whg_github/common/utils/eventutils.dart';
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
class RepositoryDetailInfoPage extends StatefulWidget {
  final ReposDetailInfoPageControl reposDetailInfoPageControl;
  final String userName;
  final String reposName;

  RepositoryDetailInfoPage(
      this.reposDetailInfoPageControl, this.userName, this.reposName);

  @override
  RepositoryDetailInfoPageState createState() =>
      new RepositoryDetailInfoPageState(
          reposDetailInfoPageControl, userName, reposName);
}

class RepositoryDetailInfoPageState extends State<RepositoryDetailInfoPage>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  final ReposDetailInfoPageControl reposDetailInfoPageControl;
  final String userName;
  final String reposName;

  RepositoryDetailInfoPageState(
      this.reposDetailInfoPageControl, this.userName, this.reposName);

  final List dataList = new List();

  bool isLoading = false;
  int page = 1;
  final WhgPullLoadWidgetControl pullLoadWidgetControl =
      new WhgPullLoadWidgetControl();

//刷新数据
  Future<Null> _onRefresh() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page = 1;
    var res =
        await ReposDao.getRepositoryEventDao(userName, reposName, page: page);
    if (res != null && res.result) {
      pullLoadWidgetControl.dataList.clear();
      setState(() {
        pullLoadWidgetControl.dataList.addAll(res.data);
      });
    }
    setState(() {
      pullLoadWidgetControl.needLoadMore = (res != null &&
          res.data != null &&
          res.data.length == Config.PAGE_SIZE);
    });
    isLoading = false;
    return null;
  }

//加载更多
  Future<Null> _onLoadMore() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page++;
    var res =
        await ReposDao.getRepositoryEventDao(userName, reposName, page: page);
    if (res != null && res.result) {
      setState(() {
        pullLoadWidgetControl.dataList.addAll(res.data);
      });
    }
    setState(() {
      pullLoadWidgetControl.needLoadMore = (res != null &&
          res.data != null &&
          res.data.length == Config.PAGE_SIZE);
    });
    isLoading = false;
    return null;
  }

  _renderEventItem(index) {
    if (index == 0) {
      return new ReposHeaderItem(
          reposDetailInfoPageControl.reposHeaderViewModel);
    }

    EventViewModel eventViewModel = pullLoadWidgetControl.dataList[index - 1];

    return new EventItem(
      eventViewModel,
      onPressed: () {
        EventUtils.ActionUtils(context, eventViewModel.eventMap, "");
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    pullLoadWidgetControl.needHeader = true;
    pullLoadWidgetControl.dataList = dataList;
    if (pullLoadWidgetControl.dataList.length == 0) {
      new Future.delayed(const Duration(seconds: 0), () {
        _refreshIndicatorKey.currentState.show().then((e) {});
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.
    return WhgPullLoadWidget(
      (BuildContext context, int index) => _renderEventItem(index),
      _onRefresh,
      _onLoadMore,
      pullLoadWidgetControl,
      refreshKey: _refreshIndicatorKey,
    );
  }
}

class ReposDetailInfoPageControl {
  ReposHeaderViewModel reposHeaderViewModel = new ReposHeaderViewModel();
}
