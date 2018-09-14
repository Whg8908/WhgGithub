import 'dart:io';

import 'package:flutter/material.dart';
import 'package:github/common/bean/file_item_view_model.dart';
import 'package:github/common/dao/repos_dao.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/common/utils/commonutils.dart';
import 'package:github/common/utils/htmlutils.dart';
import 'package:github/common/utils/navigatorutils.dart';
import 'package:github/ui/base/whg_list_state.dart';
import 'package:github/ui/page/repository_detail_page.dart';
import 'package:github/ui/view/card_item.dart';
import 'package:github/ui/view/whg_pullload_widget.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/29
 *
 * @Description 文件列表页面
 *
 * PS: Stay hungry,Stay foolish.
 */

class RepositoryDetailFileListPage extends StatefulWidget {
  final String userName;
  final String reposName;
  final BranchControl branchControl;

  RepositoryDetailFileListPage(
      this.userName, this.reposName, this.branchControl,
      {Key key})
      : super(key: key);

  @override
  RepositoryDetailFileListPageState createState() =>
      new RepositoryDetailFileListPageState(
          this.userName, this.reposName, branchControl);
}

class RepositoryDetailFileListPageState
    extends WhgListState<RepositoryDetailFileListPage> {
  final String userName;
  final String reposName;
  final BranchControl branchControl;

  String path = '';

  String searchText;
  String issueState;

  RepositoryDetailFileListPageState(
      this.userName, this.reposName, this.branchControl);

  @override
  bool get wantKeepAlive => true;

  @override
  bool get needHeader => false;

  @override
  bool get isRefreshFirst => true;

  @override
  requestLoadMore() async {
    return await _getDataLogic(this.searchText);
  }

  @override
  requestRefresh() async {
    return await _getDataLogic(this.searchText);
  }

  _getDataLogic(String searchString) async {
    return await ReposDao.getReposFileDirDao(userName, reposName,
        path: path, branch: branchControl.currentBranch);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.
    return new Scaffold(
      backgroundColor: Color(WhgColors.mainBackgroundColor),
      appBar: new AppBar(
        flexibleSpace: _renderHeader(),
        backgroundColor: Color(WhgColors.mainBackgroundColor),
        leading: new Container(),
        elevation: 0.0,
      ),
      body: WhgPullLoadWidget(
        (BuildContext context, int index) => _renderEventItem(index),
        handleRefresh,
        onLoadMore,
        pullLoadWidgetControl,
        refreshKey: refreshIndicatorKey,
      ),
    );
  }

  List<String> headerList = ["."];

  _renderHeader() {
    return new Container(
      margin: new EdgeInsets.only(left: 3.0, right: 3.0),
      child: new ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return new RawMaterialButton(
            constraints: new BoxConstraints(minWidth: 0.0, minHeight: 0.0),
            padding: new EdgeInsets.all(4.0),
            onPressed: () {
              _resolveHeaderClick(index);
            },
            child: new Text(headerList[index] + " > ",
                style: WhgConstant.smallText),
          );
        },
        itemCount: headerList.length,
      ),
    );
  }

  _renderEventItem(index) {
    FileItemViewModel fileItemViewModel = pullLoadWidgetControl.dataList[index];
    IconData iconData = (fileItemViewModel.type == "file")
        ? WhgICons.REPOS_ITEM_FILE
        : WhgICons.REPOS_ITEM_DIR;
    Widget trailing = (fileItemViewModel.type == "file")
        ? null
        : new Icon(WhgICons.REPOS_ITEM_NEXT, size: 12.0);

    return new WhgCardItem(
      margin: EdgeInsets.only(left: 10.0, top: 5.0, right: 10.0, bottom: 5.0),
      child: new ListTile(
        leading: new Icon(
          iconData,
          size: 15.0,
        ),
        trailing: trailing,
        title:
            new Text(fileItemViewModel.name, style: WhgConstant.subSmallText),
        onTap: () {
          _resolveItemClick(fileItemViewModel);
        },
      ),
    );
  }

  //item点击事件
  _resolveItemClick(FileItemViewModel fileItemViewModel) {
    if (fileItemViewModel.type == "dir") {
      this.setState(() {
        headerList.add(fileItemViewModel.name);
      });
      String path = headerList.sublist(1, headerList.length).join("/");
      this.setState(() {
        this.path = path;
      });
      this.showRefreshLoading();
    } else {
      String path = headerList.sublist(1, headerList.length).join("/") +
          "/" +
          fileItemViewModel.name;
      if (CommonUtils.isImageEnd(fileItemViewModel.name)) {
        //todo 图片
      } else {
        if (Platform.isIOS) {
          NavigatorUtils.gotoCodeDetailPage(
            context,
            title: fileItemViewModel.name,
            reposName: reposName,
            userName: userName,
            path: path,
            branch: branchControl.currentBranch,
          );
        } else {
          CommonUtils.showLoadingDialog(context);
          ReposDao.getReposFileDirDao(userName, reposName,
                  path: path, branch: branchControl.currentBranch, text: true)
              .then((res) {
            if (res != null && res.result) {
              Navigator.pop(context);
              String data = HtmlUtils.resolveHtmlFile(res, "java");
              CommonUtils.launchWebView(context, fileItemViewModel.name, data);
            }
          });
        }
      }
    }
  }

  ///头部列表点击
  _resolveHeaderClick(index) {
    if (headerList[index] != ".") {
      List<String> newHeaderList = headerList.sublist(0, index + 1);
      String path = newHeaderList.sublist(1, newHeaderList.length).join("/");
      this.setState(() {
        this.path = path;
        headerList = newHeaderList;
      });
      this.showRefreshLoading();
    } else {
      setState(() {
        path = "";
        headerList = ["."];
      });
      this.showRefreshLoading();
    }
  }
}
