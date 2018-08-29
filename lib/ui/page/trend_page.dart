import 'package:flutter/material.dart';
import 'package:whg_github/common/bean/repos_view_model.dart';
import 'package:whg_github/common/dao/repos_dao.dart';
import 'package:whg_github/common/utils/navigatorutils.dart';
import 'package:whg_github/ui/base/whg_list_state.dart';
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

class TrendPageState extends WhgListState<TrendPage> {
  @override
  requestRefresh() async {
    return await ReposDao.getTrendDao(since: 'daily');
  }

  @override
  requestLoadMore() async {
    return null;
  }

  @override
  bool get isRefreshFirst => true;

  _renderItem(ReposViewModel e) {
    return new ReposItem(
      e,
      onPressed: () {
        NavigatorUtils.goReposDetail(context, e.ownerName, e.repositoryName);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WhgPullLoadWidget(
      (BuildContext context, int index) =>
          _renderItem(pullLoadWidgetControl.dataList[index]),
      handleRefresh,
      onLoadMore,
      pullLoadWidgetControl,
      refreshKey: refreshIndicatorKey,
    );
  }
}
