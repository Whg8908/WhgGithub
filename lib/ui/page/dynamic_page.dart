import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:github/common/bean/Event.dart';
import 'package:github/common/config/config.dart';
import 'package:github/common/dao/event_dao.dart';
import 'package:github/common/redux/whg_state.dart';
import 'package:github/common/utils/eventutils.dart';
import 'package:github/common/viewmodel/event_view_model.dart';
import 'package:github/ui/base/whg_list_state.dart';
import 'package:github/ui/view/event_item.dart';
import 'package:github/ui/view/whg_pullload_widget.dart';
import 'package:redux/redux.dart';
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
    with
        AutomaticKeepAliveClientMixin<DynamicPage>,
        WhgListState<DynamicPage>,
        WidgetsBindingObserver {
  @override
  Future<Null> handleRefresh() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page = 1;
    var result =
        await EventDao.getEventReceived(_getStore(), page: page, needDb: true);
    setState(() {
      pullLoadWidgetControl.needLoadMore =
          (result != null && result.length == Config.PAGE_SIZE);
    });
    isLoading = false;
    return null;
  }

  @override
  Future<Null> onLoadMore() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page++;
    var result = await EventDao.getEventReceived(_getStore(), page: page);
    setState(() {
      pullLoadWidgetControl.needLoadMore = (result != null);
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
  requestRefresh() async {}

  @override
  requestLoadMore() async {}

  @override
  bool get isRefreshFirst => false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    pullLoadWidgetControl.dataList = _getStore().state.eventList;
    if (pullLoadWidgetControl.dataList.length == 0) {
      showRefreshLoading();
    }
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (pullLoadWidgetControl.dataList.length != 0) {
        showRefreshLoading();
      }
    }
  }

//listview的item
  _renderEventItem(Event e) {
    EventViewModel eventViewModel = EventViewModel.fromEventMap(e);

    return new EventItem(
      eventViewModel,
      onPressed: () {
        EventUtils.ActionUtils(context, e, "");
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
