import 'package:flutter/material.dart';
import 'package:whg_github/common/bean/bottom_status_view_model.dart';
import 'package:whg_github/common/config/config.dart';
import 'package:whg_github/common/dao/repos_dao.dart';
import 'package:whg_github/common/style/whg_style.dart';
import 'package:whg_github/common/utils/commonutils.dart';
import 'package:whg_github/ui/page/repository_detail_file_list_page.dart';
import 'package:whg_github/ui/page/repository_detail_info_list_page.dart';
import 'package:whg_github/ui/page/repository_detail_issue_list_page.dart';
import 'package:whg_github/ui/page/repository_detail_readme_page.dart';
import 'package:whg_github/ui/view/whg_icon_text.dart';
import 'package:whg_github/ui/view/whg_tabbar_widget.dart';

class RepositoryDetailPage extends StatefulWidget {
  final String userName;
  final String reposName;

  RepositoryDetailPage(this.userName, this.reposName);

  @override
  RepositoryDetailPageState createState() =>
      new RepositoryDetailPageState(userName, reposName);
}

class RepositoryDetailPageState extends State<RepositoryDetailPage> {
  final String userName;
  final String reposName;

  BottomStatusModel bottomStatusModel;
  final TarWidgetControl tarBarControl = new TarWidgetControl();

  final ReposDetailInfoPageControl reposDetailInfoPageControl =
      new ReposDetailInfoPageControl();

  final BranchControl branchControl = new BranchControl("master");

  final GlobalKey<RepositoryDetailFileListPageState> fileListKey =
      new GlobalKey<RepositoryDetailFileListPageState>();

  final GlobalKey<RepositoryDetailInfoPageState> infoListKey =
      new GlobalKey<RepositoryDetailInfoPageState>();

  RepositoryDetailPageState(this.userName, this.reposName);

  String currentBranch = "master";

  List<String> branchList = new List();

  _getBranchList() async {
    var result = await ReposDao.getBranchesDao(userName, reposName);
    if (result != null && result.result) {
      setState(() {
        branchList = result.data;
      });
    }
  }

  _getReposDetail() async {
    var result = await ReposDao.getRepositoryDetailDao(
        userName, reposName, branchControl.currentBranch);
    if (result != null && result.result) {
      setState(() {
        reposDetailInfoPageControl.reposHeaderViewModel = result.data;
      });
    }
  }

  _getReposStatus() async {
    var result = await ReposDao.getRepositoryStatusDao(userName, reposName);
    if (Config.DEBUG) {
      print(result.data["star"]);
      print(result.data["watch"]);
    }
    String watchText = result.data["watch"] ? "UnWatch" : "Watch";
    String starText = result.data["star"] ? "UnStar" : "Star";
    IconData watchIcon = result.data["watch"]
        ? WhgICons.REPOS_ITEM_WATCHED
        : WhgICons.REPOS_ITEM_WATCH;
    IconData starIcon = result.data["star"]
        ? WhgICons.REPOS_ITEM_STARED
        : WhgICons.REPOS_ITEM_STAR;
    BottomStatusModel model = new BottomStatusModel(watchText, starText,
        watchIcon, starIcon, result.data["watch"], result.data["star"]);
    setState(() {
      bottomStatusModel = model;
      tarBarControl.footerButton = _getBottomWidget();
    });
  }

  _getBottomWidget() {
    List<Widget> bottomWidget = (bottomStatusModel == null)
        ? []
        : <Widget>[
            new FlatButton(
                onPressed: () {
                  CommonUtils.showLoadingDialog(context);
                  return ReposDao.doRepositoryStarDao(
                          userName, reposName, bottomStatusModel.star)
                      .then((result) {
                    _refresh();
                    Navigator.pop(context);
                  });
                },
                child: new WhgIconText(
                  bottomStatusModel.starIcon,
                  bottomStatusModel.starText,
                  WhgConstant.smallText,
                  Color(WhgColors.primaryValue),
                  15.0,
                  padding: 2.0,
                  mainAxisAlignment: MainAxisAlignment.center,
                )),
            new FlatButton(
                onPressed: () {
                  CommonUtils.showLoadingDialog(context);
                  return ReposDao.doRepositoryWatchDao(
                          userName, reposName, bottomStatusModel.watch)
                      .then((result) {
                    _refresh();
                    Navigator.pop(context);
                  });
                },
                child: new WhgIconText(
                  bottomStatusModel.watchIcon,
                  bottomStatusModel.watchText,
                  WhgConstant.smallText,
                  Color(WhgColors.primaryValue),
                  15.0,
                  padding: 2.0,
                  mainAxisAlignment: MainAxisAlignment.center,
                )),
            new FlatButton(
                onPressed: () {
                  CommonUtils.showLoadingDialog(context);
                  return ReposDao.createForkDao(userName, reposName)
                      .then((result) {
                    _refresh();
                    Navigator.pop(context);
                  });
                },
                child: new WhgIconText(
                  WhgICons.REPOS_ITEM_FORK,
                  "fork",
                  WhgConstant.smallText,
                  Color(WhgColors.primaryValue),
                  15.0,
                  padding: 2.0,
                  mainAxisAlignment: MainAxisAlignment.center,
                )),
            _renderBranchPopItem(currentBranch, branchList, (value) {
              setState(() {
                branchControl.currentBranch = value;
              });
              _getReposDetail();
              infoListKey.currentState.showRefreshLoading();
            })
          ];
    return bottomWidget;
  }

  _renderBranchPopItem(String data, List<String> list, selected) {
    if (list == null && list.length == 0) {
      return Container();
    }

    return Container(
      height: 30.0,
      child: PopupMenuButton<String>(
        onSelected: selected,
        child: FlatButton(
            onPressed: null,
            color: Color(WhgColors.primaryValue),
            disabledColor: Color(WhgColors.primaryValue),
            child: WhgIconText(
              Icons.arrow_drop_up,
              data,
              WhgConstant.smallTextWhite,
              Color(WhgColors.white),
              30.0,
              padding: 3.0,
              mainAxisAlignment: MainAxisAlignment.center,
            )),
        itemBuilder: (BuildContext context) {
          return _renderHeaderPopItemChild(list);
        },
      ),
    );
  }

  _renderHeaderPopItemChild(List<String> data) {
    List<PopupMenuEntry<String>> list = new List();
    for (String item in data) {
      list.add(PopupMenuItem<String>(
        value: item,
        child: new Text(item),
      ));
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    _refresh();
    _getBranchList();
  }

  _refresh() {
    this._getReposDetail();
    this._getReposStatus();
  }

  @override
  Widget build(BuildContext context) {
    return new WhgTabBarWidget(
        type: WhgTabBarWidget.TOP_TAB,
        tarWidgetControl: tarBarControl,
        tabItems: [
          new Tab(text: WhgStrings.repos_tab_info),
          new Tab(text: WhgStrings.repos_tab_issue),
          new Tab(text: WhgStrings.repos_tab_file),
          new Tab(text: WhgStrings.repos_tab_readme),
        ],
        tabViews: [
          RepositoryDetailInfoListPage(
              reposDetailInfoPageControl, userName, reposName, branchControl,
              key: infoListKey),
          RepositoryDetailIssueListPage(userName, reposName),
          RepositoryDetailFileListPage(userName, reposName, branchControl,
              key: fileListKey),
          RepostroyDetailReadmePage(),
        ],
        backgroundColor: WhgColors.primarySwatch,
        indicatorColor: Colors.white,
        title: reposName);
  }
}

class BranchControl {
  String currentBranch;

  BranchControl(this.currentBranch);
}
