import 'dart:async';

import 'package:flutter/material.dart';
import 'package:whg_github/common/bean/repos_view_model.dart';
import 'package:whg_github/common/dao/repos_dao.dart';
import 'package:whg_github/common/utils/navigatorutils.dart';
import 'package:whg_github/ui/view/repos_item.dart';
import 'package:whg_github/ui/view/whg_pullload_widget.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/22
 *
 * @Description
 *
 * PS: Stay hungry,Stay foolish.
 */

class TrendPage extends StatefulWidget {
  @override
  TrendPageState createState() => TrendPageState();
}

class TrendPageState extends State<TrendPage>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  bool isLoading = false;

  int page = 1;

  final List dataList = new List();

  final WhgPullLoadWidgetControl pullLoadWidgetControl =
      new WhgPullLoadWidgetControl();

  Future<Null> _handleRefresh() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page = 1;
    var res = await ReposDao.getTrendDao(since: 'daily');
    if (res != null && res.result && res.data.length > 0) {
      setState(() {
        pullLoadWidgetControl.dataList = res.data;
      });
    }
    setState(() {
      pullLoadWidgetControl.needLoadMore = false;
    });
    isLoading = false;
    return null;
  }

  Future<Null> _onLoadMore() async {
    return null;
  }

  _renderItem(ReposViewModel e) {
    return new ReposItem(
      e,
      onPressed: () {
        NavigatorUtils.goReposDetail(context, e.ownerName, e.repositoryName);
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    if (pullLoadWidgetControl.dataList.length == 0) {
      new Future.delayed(const Duration(seconds: 0), () {
        _refreshIndicatorKey.currentState.show().then((e) {});
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WhgPullLoadWidget(
      (BuildContext context, int index) =>
          _renderItem(pullLoadWidgetControl.dataList[index]),
      _handleRefresh,
      _onLoadMore,
      pullLoadWidgetControl,
      refreshKey: _refreshIndicatorKey,
    );
  }
}
