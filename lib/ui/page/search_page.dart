import 'package:flutter/material.dart';
import 'package:whg_github/common/config/config.dart';
import 'package:whg_github/common/dao/repos_dao.dart';
import 'package:whg_github/common/style/whg_style.dart';
import 'package:whg_github/common/utils/navigatorutils.dart';
import 'package:whg_github/ui/base/whg_list_state.dart';
import 'package:whg_github/ui/view/repos_item.dart';
import 'package:whg_github/ui/view/serach_bottom_widget.dart';
import 'package:whg_github/ui/view/user_item.dart';
import 'package:whg_github/ui/view/whg_pullload_widget.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/9/8
 *
 * @Description   搜索页面
 *
 * PS: Stay hungry,Stay foolish.
 */

class SearchPage extends StatefulWidget {
  @override
  SearchPageState createState() => new SearchPageState();
}

class SearchPageState extends WhgListState<SearchPage> {
  int selectIndex = 0;

  String searchText;

  _renderEventItem(index) {
    var data = pullLoadWidgetControl.dataList[index];
    if (selectIndex == 0) {
      return new ReposItem(data, onPressed: () {
        NavigatorUtils.goReposDetail(
            context, data.ownerName, data.repositoryName);
      });
    } else if (selectIndex == 1) {
      return new UserItem(data, onPressed: () {
        NavigatorUtils.goPerson(context, data.userName);
      });
    }
  }

  _resolveSelectIndex() {
    clearData();
    showRefreshLoading();
  }

  _getDataLogic() async {
    return await ReposDao.searchRepositoryDao(searchText, null, null, null,
        selectIndex == 0 ? null : 'user', page, Config.PAGE_SIZE);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  bool get needHeader => false;

  @override
  bool get isRefreshFirst => false;

  @override
  requestLoadMore() async {
    return await _getDataLogic();
  }

  @override
  requestRefresh() async {
    return await _getDataLogic();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.
    return new Scaffold(
      backgroundColor: Color(WhgColors.mainBackgroundColor),
      appBar: new AppBar(
          title: new Text(WhgStrings.search_title),
          bottom: new SearchBottom((value) {}, (value) {
            searchText = value;
            if (searchText == null || searchText.trim().length == 0) {
              return;
            }
            _resolveSelectIndex();
          }, (selectIndex) {
            this.selectIndex = selectIndex;
            _resolveSelectIndex();
          })),
      body: WhgPullLoadWidget(
        (BuildContext context, int index) => _renderEventItem(index),
        handleRefresh,
        onLoadMore,
        pullLoadWidgetControl,
        refreshKey: refreshIndicatorKey,
      ),
    );
  }
}
