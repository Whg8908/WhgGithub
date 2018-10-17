import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github/common/config/config.dart';
import 'package:github/common/dao/repos_dao.dart';
import 'package:github/common/net/address.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/common/utils/commonutils.dart';
import 'package:github/common/utils/navigatorutils.dart';
import 'package:github/common/viewmodel/bottom_status_view_model.dart';
import 'package:github/common/viewmodel/whg_option_model.dart';
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

  final ReposDetailParentControl reposDetailParentControl =
      new ReposDetailParentControl("master");

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
    var result = await ReposDao.getRepositoryDetailDao(
        userName, reposName, reposDetailParentControl.currentBranch);
    if (result != null && result.result) {
      setState(() {
        branchList = result.data;
      });
    }
  }

  _getReposDetail() {
    ReposDao.getRepositoryDetailDao(
            userName, reposName, reposDetailParentControl.currentBranch)
        .then((result) {
      if (result != null && result.result) {
        setState(() {
          reposDetailInfoPageControl.repository = result.data;
        });
        return result.next;
      }
      return new Future.value(null);
    }).then((result) {
      if (result != null && result.result) {
        setState(() {
          reposDetailInfoPageControl.repository = result.data;
        });
      }
    });
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
          ];
    return bottomWidget;
  }

  @override
  void initState() {
    super.initState();
    _getBranchList();
    _refresh();
  }

  _refresh() {
    this._getReposDetail();
    this._getReposStatus();
  }

  ///无奈之举，只能pageView配合tabbar，通过control同步
  ///TabView 配合tabbar 在四个页面上问题太多
  _renderTabItem() {
    var itemList = [
      CommonUtils.getLocale(context).repos_tab_info,
      CommonUtils.getLocale(context).repos_tab_readme,
      CommonUtils.getLocale(context).repos_tab_issue,
      CommonUtils.getLocale(context).repos_tab_file,
    ];
    renderItem(String item, int i) {
      return new FlatButton(
          padding: EdgeInsets.all(0.0),
          onPressed: () {
            reposDetailParentControl.currentIndex = i;
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
      new WhgOptionModel(CommonUtils.getLocale(context).repos_option_release,
          CommonUtils.getLocale(context).repos_option_release, (model) {
        NavigatorUtils.goReleasePage(context, userName, reposName);
      }),
      new WhgOptionModel(CommonUtils.getLocale(context).repos_option_branch,
          CommonUtils.getLocale(context).repos_option_branch, (model) {
        if (branchList.length == 0) {
          return;
        }
        CommonUtils.showCommitOptionDialog(context, branchList, (value) {
          setState(() {
            reposDetailParentControl.currentBranch = branchList[value];
          });
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
        });
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
        RepositoryDetailInfoListPage(reposDetailInfoPageControl, userName,
            reposName, reposDetailParentControl,
            key: infoListKey),
        RepostroyDetailReadmePage(userName, reposName, reposDetailParentControl,
            key: readmeKey),
        RepositoryDetailIssueListPage(userName, reposName),
        RepositoryDetailFileListPage(
            userName, reposName, reposDetailParentControl,
            key: fileListKey),
      ],
      topPageControl: topPageControl,
      backgroundColor: WhgColors.primarySwatch,
      indicatorColor: Colors.white,
      title: WhgTitleBar(
        reposName,
        rightWidget: widget,
      ),
      onPageChanged: (index) {
        reposDetailParentControl.currentIndex = index;
      },
    );
  }
}

class ReposDetailParentControl {
  int currentIndex = 0;

  String currentBranch;

  ReposDetailParentControl(this.currentBranch);
}
