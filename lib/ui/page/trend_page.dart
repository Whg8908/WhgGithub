import 'package:flutter/material.dart';
import 'package:whg_github/common/bean/repos_view_model.dart';
import 'package:whg_github/common/bean/trend_type_model.dart';
import 'package:whg_github/common/dao/repos_dao.dart';
import 'package:whg_github/common/style/whg_style.dart';
import 'package:whg_github/common/utils/navigatorutils.dart';
import 'package:whg_github/ui/base/whg_list_state.dart';
import 'package:whg_github/ui/view/card_item.dart';
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
            _renderHeaderPopItem("aaa", [
              new TrendTypeModel("fff", "fff"),
              new TrendTypeModel("fff", "fff")
            ], (TrendTypeModel result) {
              setState(() {});
            }),
            new Container(height: 10.0, width: 0.5, color: Colors.white),
            _renderHeaderPopItem("bbb", [
              new TrendTypeModel("fff", "fff"),
              new TrendTypeModel("fff", "fff")
            ], (TrendTypeModel result) {
              setState(() {});
            }),
          ],
        ),
      ),
    );
  }

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
  Widget build(BuildContext context) {
    super.build(context);
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
  }
}
