import 'package:flutter/material.dart';
import 'package:whg_github/common/bean/bottom_status_view_model.dart';
import 'package:whg_github/common/dao/repos_dao.dart';
import 'package:whg_github/common/style/whg_style.dart';
import 'package:whg_github/ui/page/repository_detail_info_page.dart';
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

  RepositoryDetailPageState(this.userName, this.reposName);

  _getReposDetail() async {
    var result = await ReposDao.getRepositoryDetailDao(userName, reposName);
    if (result != null && result.result) {
      setState(() {
        reposDetailInfoPageControl.reposHeaderViewModel = result.data;
      });
    }
  }

  _getReposStatus() async {
    var result = await ReposDao.getRepositoryStatusDao(userName, reposName);
    print(result.data["star"]);
    print(result.data["watch"]);
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
    bottomStatusModel = model;
    setState(() {
      tarBarControl.footerButton = _getBottomWidget();
    });
  }

  _getBottomWidget() {
    List<Widget> bottomWidget = (bottomStatusModel == null)
        ? []
        : <Widget>[
            new FlatButton(
                onPressed: () => {},
                child: new WhgIconText(
                  bottomStatusModel.starIcon,
                  bottomStatusModel.starText,
                  WhgConstant.smallText,
                  Color(WhgColors.primaryValue),
                  15.0,
                  padding: 5.0,
                  mainAxisAlignment: MainAxisAlignment.center,
                )),
            new FlatButton(
                onPressed: () {},
                child: new WhgIconText(
                  bottomStatusModel.watchIcon,
                  bottomStatusModel.watchText,
                  WhgConstant.smallText,
                  Color(WhgColors.primaryValue),
                  15.0,
                  padding: 5.0,
                  mainAxisAlignment: MainAxisAlignment.center,
                )),
            new FlatButton(
                onPressed: () {},
                child: new WhgIconText(
                  WhgICons.REPOS_ITEM_FORK,
                  "fork",
                  WhgConstant.smallText,
                  Color(WhgColors.primaryValue),
                  15.0,
                  padding: 5.0,
                  mainAxisAlignment: MainAxisAlignment.center,
                )),
            new FlatButton(
                onPressed: () {},
                color: Color(WhgColors.primaryValue),
                child: new WhgIconText(
                  Icons.arrow_drop_up,
                  "master",
                  WhgConstant.smallTextWhite,
                  Color(WhgColors.white),
                  30.0,
                  padding: 3.0,
                  mainAxisAlignment: MainAxisAlignment.center,
                ))
          ];
    return bottomWidget;
  }

  @override
  void initState() {
    super.initState();
    this._getReposDetail();
    this._getReposStatus();
  }

  @override
  Widget build(BuildContext context) {
    return new WhgTabBarWidget(
        type: WhgTabBarWidget.TOP_TAB,
        tarWidgetControl: tarBarControl,
        tabItems: [
          new Tab(text: WhgStrings.repos_tab_readme),
          new Tab(text: WhgStrings.repos_tab_info),
          new Tab(text: WhgStrings.repos_tab_file),
          new Tab(text: WhgStrings.repos_tab_issue),
        ],
        tabViews: [
          RepostroyDetailReadmePage(),
          RepositoryDetailInfoPage(
              reposDetailInfoPageControl, userName, reposName),
          new Icon(WhgICons.MAIN_DT),
          new Icon(WhgICons.MAIN_DT),
          new Icon(WhgICons.MAIN_DT),
        ],
        backgroundColor: WhgColors.primarySwatch,
        indicatorColor: Colors.white,
        title: reposName);
  }
}
