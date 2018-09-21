import 'package:flutter/material.dart';
import 'package:github/common/bean/bottom_status_view_model.dart';
import 'package:github/common/bean/whg_option_model.dart';
import 'package:github/common/config/config.dart';
import 'package:github/common/dao/repos_dao.dart';
import 'package:github/common/net/address.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/common/utils/commonutils.dart';
import 'package:github/common/utils/navigatorutils.dart';
import 'package:github/ui/page/repository_detail_file_list_page.dart';
import 'package:github/ui/page/repository_detail_info_list_page.dart';
import 'package:github/ui/page/repository_detail_issue_list_page.dart';
import 'package:github/ui/page/repository_detail_readme_page.dart';
import 'package:github/ui/view/whg_common_option_widget.dart';
import 'package:github/ui/view/whg_icon_text.dart';
import 'package:github/ui/view/whg_tabbar_widget.dart';
import 'package:github/ui/view/whg_title_bar.dart';

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

  GlobalKey<RepostroyDetailReadmePageState> readmeKey =
      new GlobalKey<RepostroyDetailReadmePageState>();

  final PageController topPageControl = new PageController();

  RepositoryDetailPageState(this.userName, this.reposName);

  String currentBranch = "master";

  List<String> branchList = new List();

  int initialIndex = 0;

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

  _renderBottomItem(var text, var icon, var onPressed) {
    return new FlatButton(
        onPressed: onPressed,
        child: new WhgIconText(
          icon,
          text,
          WhgConstant.smallText,
          Color(WhgColors.primaryValue),
          15.0,
          padding: 5.0,
          mainAxisAlignment: MainAxisAlignment.center,
        ));
  }

  _getBottomWidget() {
    List<Widget> bottomWidget = (bottomStatusModel == null)
        ? []
        : <Widget>[
            _renderBottomItem(
                bottomStatusModel.starText, bottomStatusModel.starIcon, () {
              CommonUtils.showLoadingDialog(context);
              return ReposDao.doRepositoryStarDao(
                      userName, reposName, bottomStatusModel.star)
                  .then((result) {
                _refresh();
                Navigator.pop(context);
              });
            }),
            _renderBottomItem(
                bottomStatusModel.watchText, bottomStatusModel.watchIcon, () {
              CommonUtils.showLoadingDialog(context);
              return ReposDao.doRepositoryWatchDao(
                      userName, reposName, bottomStatusModel.watch)
                  .then((result) {
                _refresh();
                Navigator.pop(context);
              });
            }),
            _renderBottomItem("fork", WhgICons.REPOS_ITEM_FORK, () {
              CommonUtils.showLoadingDialog(context);
              return ReposDao.createForkDao(userName, reposName).then((result) {
                _refresh();
                Navigator.pop(context);
              });
            }),
            _renderBranchPopItem(currentBranch, branchList, (value) {
              setState(() {
                branchControl.currentBranch = value;
                tarBarControl.footerButton = _getBottomWidget();
              });
              _getReposDetail();
              if (infoListKey.currentState != null &&
                  infoListKey.currentState.mounted) {
                infoListKey.currentState.showRefreshLoading();
              }
              if (fileListKey.currentState != null &&
                  fileListKey.currentState.mounted) {
                fileListKey.currentState.showRefreshLoading();
              }
              if (readmeKey.currentState != null &&
                  readmeKey.currentState.mounted) {
                readmeKey.currentState.refreshReadme();
              }
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
    _getBranchList();
    _refresh();
  }

  _refresh() {
    this._getReposStatus();
    this._getReposDetail();
  }

  ///无奈之举，只能pageView配合tabbar，通过control同步
  ///TabView 配合tabbar 在四个页面上问题太多
  _renderTabItem() {
    var itemList = [
      WhgStrings.repos_tab_info,
      WhgStrings.repos_tab_readme,
      WhgStrings.repos_tab_issue,
      WhgStrings.repos_tab_file,
    ];
    renderItem(String item, int i) {
      return new FlatButton(
          padding: EdgeInsets.all(0.0),
          onPressed: () {
            topPageControl.jumpTo(MediaQuery.of(context).size.width * i);
          },
          child: new Text(
            item,
            style: WhgConstant.smallTextWhite,
            maxLines: 1,
          ));
    }

    List<Widget> list = new List();
    for (int i = 0; i < itemList.length; i++) {
      list.add(renderItem(itemList[i], i));
    }
    return list;
  }

  _getMoreOtherItem() {
    return [
      new WhgOptionModel(
          WhgStrings.repos_option_release, WhgStrings.repos_option_release,
          (model) {
        NavigatorUtils.goReleasePage(context, userName, reposName);
      }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    String url = Address.hostWeb + userName + "/" + reposName;
    Widget widget =
        new WhgCommonOptionWidget(url, otherList: _getMoreOtherItem());
    return new WhgTabBarWidget(
        type: WhgTabBarWidget.TOP_TAB,
        tarWidgetControl: tarBarControl,
        tabItems: _renderTabItem(),
        tabViews: [
          RepositoryDetailInfoListPage(
              reposDetailInfoPageControl, userName, reposName, branchControl,
              key: infoListKey),
          RepostroyDetailReadmePage(userName, reposName, branchControl,
              key: readmeKey),
          RepositoryDetailIssueListPage(userName, reposName),
          RepositoryDetailFileListPage(userName, reposName, branchControl,
              key: fileListKey),
        ],
        topPageControl: topPageControl,
        backgroundColor: WhgColors.primarySwatch,
        indicatorColor: Colors.white,
        title: WhgTitleBar(
          reposName,
          rightWidget: widget,
        ));
  }
}

class BranchControl {
  String currentBranch;

  BranchControl(this.currentBranch);
}
