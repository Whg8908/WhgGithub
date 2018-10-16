import 'package:flutter/material.dart';
import 'package:github/common/config/config.dart';
import 'package:github/common/dao/repos_dao.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/common/utils/commonutils.dart';
import 'package:github/common/utils/navigatorutils.dart';
import 'package:github/common/viewmodel/filter_model.dart';
import 'package:github/common/viewmodel/repos_view_model.dart';
import 'package:github/common/viewmodel/user_item_view_model.dart';
import 'package:github/ui/base/whg_list_state.dart';
import 'package:github/ui/page/whg_search_drawer.dart';
import 'package:github/ui/view/repos_item.dart';
import 'package:github/ui/view/serach_bottom_widget.dart';
import 'package:github/ui/view/user_item.dart';
import 'package:github/ui/view/whg_pullload_widget.dart';

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

  String type = searchFilterType[0].value;
  String sort = sortType[0].value;
  String language = searchLanguageType[0].value;

  _renderEventItem(index) {
    var data = pullLoadWidgetControl.dataList[index];
    if (selectIndex == 0) {
      ReposViewModel reposViewModel = ReposViewModel.fromMap(data);
      return new ReposItem(reposViewModel, onPressed: () {
        NavigatorUtils.goReposDetail(
            context, reposViewModel.ownerName, reposViewModel.repositoryName);
      });
    } else if (selectIndex == 1) {
      return new UserItem(UserItemViewModel.fromMap(data), onPressed: () {
        NavigatorUtils.goPerson(
            context, UserItemViewModel.fromMap(data).userName);
      });
    }
  }

  _resolveSelectIndex() {
    clearData();
    showRefreshLoading();
  }

  _getDataLogic() async {
    return await ReposDao.searchRepositoryDao(searchText, language, type, sort,
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
      endDrawer: new WhgSearchDrawer(
        (String type) {
          this.type = type;
          Navigator.pop(context);
          _resolveSelectIndex();
        },
        (String sort) {
          this.sort = sort;
          Navigator.pop(context);
          _resolveSelectIndex();
        },
        (String language) {
          this.language = language;
          Navigator.pop(context);
          _resolveSelectIndex();
        },
      ),
      backgroundColor: Color(WhgColors.mainBackgroundColor),
      appBar: new AppBar(
          title: new Text(CommonUtils.getLocale(context).search_title),
          bottom: new SearchBottom((value) {
            searchText = value;
          }, (value) {
            searchText = value;
            if (searchText == null || searchText.trim().length == 0) {
              return;
            }
            _resolveSelectIndex();
          }, () {
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

  @override
  void dispose() {
    super.dispose();
    _clearSelect(sortType);
    sortType[0].select = true;
    _clearSelect(searchLanguageType);
    searchLanguageType[0].select = true;
    _clearSelect(searchFilterType);
    searchFilterType[0].select = true;
  }

  _clearSelect(List<FilterModel> list) {
    for (FilterModel model in list) {
      model.select = false;
    }
  }
}
