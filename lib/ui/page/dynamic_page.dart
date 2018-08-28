import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:whg_github/common/bean/event_view_model.dart';
import 'package:whg_github/common/config/config.dart';
import 'package:whg_github/common/dao/event_dao.dart';
import 'package:whg_github/common/redux/whg_state.dart';
import 'package:whg_github/common/utils/eventutils.dart';
import 'package:whg_github/ui/view/event_item.dart';
import 'package:whg_github/ui/view/whg_pullload_widget.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/22
 *
 * @Description 我的动态页面
 *
 * PS: Stay hungry,Stay foolish.
 */

class DynamicPage extends StatefulWidget {
  @override
  DynamicPageState createState() => DynamicPageState();
}

class DynamicPageState extends State<DynamicPage>
    with AutomaticKeepAliveClientMixin {
  final WhgPullLoadWidgetControl control = WhgPullLoadWidgetControl();
  final List dataList = new List();

  bool isLoading = false;
  int page = 1;

  //刷新数据
  Future<Null> _handleRefresh() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page = 1;
    var result = await EventDao.getEventReceived(_getStore(), page: page);
    //更新数据
    setState(() {
      control.needLoadMore =
          (result != null && result.length == Config.PAGE_SIZE);
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
    var result = await EventDao.getEventReceived(_getStore(), page: page);
    setState(() {
      control.needLoadMore = (result != null);
    });
    isLoading = false;
    return null;
  }

  Store<WhgState> _getStore() {
    return StoreProvider.of(context);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    control.dataList = _getStore().state.eventList;
    if (control.dataList.length == 0) {
      if (!mounted) {
        return;
      }
      _handleRefresh();
    }
    super.didChangeDependencies();
  }

  _renderEventItem(EventViewModel e) {
    return new EventItem(
      e,
      onPressed: () {
        EventUtils.ActionUtils(context, e.eventMap, "");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.
    return StoreBuilder<WhgState>(
      builder: (context, store) {
        return WhgPullLoadWidget(
            (BuildContext context, int index) =>
                _renderEventItem(control.dataList[index]),
            _handleRefresh,
            _onLoadMore,
            control);
      },
    );
  }
}
