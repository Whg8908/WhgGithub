import 'dart:async';

import 'package:flutter/material.dart';
import 'package:github/common/config/config.dart';
import 'package:github/ui/view/whg_pullload_widget.dart';
/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/28
 *
 * @Description 列表刷新的基类
 *
 * PS: Stay hungry,Stay foolish.
 */

abstract class WhgListState<T extends StatefulWidget> extends State<T>
    with AutomaticKeepAliveClientMixin {
  bool isShow = false;

  bool isLoading = false;

  int page = 1;

  final List dataList = new List();

  final WhgPullLoadWidgetControl pullLoadWidgetControl =
      new WhgPullLoadWidgetControl();

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @protected
  Future<Null> handleRefresh() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page = 1;
    var res = await requestRefresh();
    if (res != null && res.result) {
      pullLoadWidgetControl.dataList.clear();
      if (isShow) {
        setState(() {
          pullLoadWidgetControl.dataList.addAll(res.data);
        });
      }
    }
    resolveDataResult(res);
    isLoading = false;
    return null;
  }

  @protected
  Future<Null> onLoadMore() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page++;
    var res = await requestLoadMore();
    if (res != null && res.result) {
      if (isShow) {
        setState(() {
          pullLoadWidgetControl.dataList.addAll(res.data);
        });
      }
    }
    resolveDataResult(res);
    isLoading = false;
    return null;
  }

  @protected
  resolveDataResult(res) {
    if (isShow) {
      setState(() {
        pullLoadWidgetControl.needLoadMore = (res != null &&
            res.data != null &&
            res.data.length == Config.PAGE_SIZE);
      });
    }
  }

  @protected
  showRefreshLoading() {
    new Future.delayed(const Duration(seconds: 0), () {
      refreshIndicatorKey.currentState.show().then((e) {});
    });
  }

  @protected
  clearData() {
    if (isShow) {
      setState(() {
        pullLoadWidgetControl.dataList.clear();
      });
    }
  }

  @protected
  requestRefresh() async {}

  @protected
  requestLoadMore() async {}

  @protected
  bool get isRefreshFirst;

  @protected
  bool get needHeader => false;

  @override
  bool get wantKeepAlive => true;

  @override
  List get getDataList => dataList;

  @override
  void initState() {
    isShow = true;
    super.initState();
    pullLoadWidgetControl.needHeader = needHeader;
    if (isRefreshFirst) {
      pullLoadWidgetControl.dataList = getDataList;
      if (pullLoadWidgetControl.dataList.length == 0) {
        showRefreshLoading();
      }
    }
  }

  @override
  void didChangeDependencies() {
    pullLoadWidgetControl.dataList = getDataList;
    if (pullLoadWidgetControl.dataList.length == 0 && !isRefreshFirst) {
      showRefreshLoading();
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    isShow = false;
    isLoading = false;
    super.dispose();
  }
}
