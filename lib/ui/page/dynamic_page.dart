import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:whg_github/common/bean/event_view_model.dart';
import 'package:whg_github/common/dao/event_dao.dart';
import 'package:whg_github/common/redux/whg_state.dart';
import 'package:whg_github/common/utils/eventutils.dart';
import 'package:whg_github/ui/base/whg_list_state.dart';
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

class DynamicPageState extends WhgListState<DynamicPage> {
  Store<WhgState> _getStore() {
    return StoreProvider.of(context);
  }

  @override
  requestRefresh() async {
    return await EventDao.getEventReceived(_getStore(), page: page);
  }

  @override
  requestLoadMore() async {
    return await EventDao.getEventReceived(_getStore(), page: page);
  }

  @override
  bool get isRefreshFirst => false;

  @override
  List get getDataList => _getStore().state.eventList;

  _renderEventItem(EventViewModel e) {
    return new EventItem(
      e,
      onPressed: () {
        EventUtils.ActionUtils(context, e.eventMap, "");
      },
    );
  }

  @override
  clearData() {
    super.clearData();
    if (_getStore().state.eventList != null) {
      _getStore().state.eventList.clear();
    }
  }

  @override
  void dispose() {
    super.dispose();
    clearData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.
    return StoreBuilder<WhgState>(
      builder: (context, store) {
        return WhgPullLoadWidget(
          (BuildContext context, int index) =>
              _renderEventItem(pullLoadWidgetControl.dataList[index]),
          handleRefresh,
          onLoadMore,
          pullLoadWidgetControl,
          refreshKey: refreshIndicatorKey,
        );
      },
    );
  }
}
