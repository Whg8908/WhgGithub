import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:github/common/dao/repos_dao.dart';
import 'package:github/common/redux/whg_state.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/common/utils/navigatorutils.dart';
import 'package:github/common/viewmodel/repos_view_model.dart';
import 'package:github/common/viewmodel/trend_type_model.dart';
import 'package:github/ui/base/whg_list_state.dart';
import 'package:github/ui/view/card_item.dart';
import 'package:github/ui/view/repos_item.dart';
import 'package:github/ui/view/whg_pullload_widget.dart';
import 'package:redux/redux.dart';

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
  TrendTypeModel selectTime = TrendTime[0];
  TrendTypeModel selectType = TrendType[0];

  @override
  Future<Null> handleRefresh() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page = 1;
    await ReposDao.getTrendDao(_getStore(),
        since: selectTime.value, languageType: selectType.value);
    setState(() {
      pullLoadWidgetControl.needLoadMore = false;
    });
    isLoading = false;
    return null;
  }

  @override
  requestRefresh() async {
    return null;
  }

  @override
  requestLoadMore() async {
    return null;
  }

  @override
  bool get isRefreshFirst => false;

  @override
  void didChangeDependencies() {
    pullLoadWidgetControl.dataList = _getStore().state.trendList;
    if (pullLoadWidgetControl.dataList.length == 0) {
      showRefreshLoading();
    }
    super.didChangeDependencies();
  }

  Store<WhgState> _getStore() {
    return StoreProvider.of(context);
  }

  _renderItem(e) {
    ReposViewModel reposViewModel = ReposViewModel.fromTrendMap(e);
    return new ReposItem(reposViewModel, onPressed: () {
      NavigatorUtils.goReposDetail(
          context, reposViewModel.ownerName, reposViewModel.repositoryName);
    });
  }

  _renderHeader() {
    return new WhgCardItem(
      color: Color(WhgColors.primaryValue),
      margin: EdgeInsets.all(10.0),
      shape: new RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      child: new Padding(
        padding:
            new EdgeInsets.only(left: 0.0, top: 5.0, right: 0.0, bottom: 5.0),
        child: new Row(
          children: <Widget>[
            _renderHeaderPopItem(selectTime.name, TrendTime,
                (TrendTypeModel result) {
              setState(() {
                selectTime = result;
              });
              showRefreshLoading();
            }),
            new Container(
                height: 10.0, width: 0.5, color: Color(WhgColors.white)),
            _renderHeaderPopItem(selectType.name, TrendType,
                (TrendTypeModel result) {
              setState(() {
                selectType = result;
              });
              showRefreshLoading();
            }),
          ],
        ),
      ),
    );
  }

  //下拉菜单列表
  _renderHeaderPopItem(String data, List<TrendTypeModel> list,
      PopupMenuItemSelected<TrendTypeModel> onSelected) {
    return new Expanded(
      child: new PopupMenuButton<TrendTypeModel>(
        child: new Center(
            child: new Text(data, style: WhgConstant.middleTextWhite)),
        onSelected: onSelected,
        itemBuilder: (BuildContext context) {
          return _renderHeaderPopItemChild(list);
        },
      ),
    );
  }

  //下拉菜单item
  _renderHeaderPopItemChild(List<TrendTypeModel> data) {
    List<PopupMenuEntry<TrendTypeModel>> list = new List();
    for (TrendTypeModel item in data) {
      list.add(PopupMenuItem<TrendTypeModel>(
        value: item,
        child: new Text(item.name),
      ));
    }
    return list;
  }

  @override
  void dispose() {
    super.dispose();
    clearData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new StoreBuilder<WhgState>(
      builder: (context, store) {
        return Scaffold(
          backgroundColor: Color(WhgColors.mainBackgroundColor),
          appBar: new AppBar(
            flexibleSpace: _renderHeader(),
            backgroundColor: Color(WhgColors.mainBackgroundColor),
            leading: new Container(),
            elevation: 0.0,
          ),
          body: WhgPullLoadWidget(
            (BuildContext context, int index) =>
                _renderItem(pullLoadWidgetControl.dataList[index]),
            handleRefresh,
            onLoadMore,
            pullLoadWidgetControl,
            refreshKey: refreshIndicatorKey,
          ),
        );
      },
    );
  }
}
