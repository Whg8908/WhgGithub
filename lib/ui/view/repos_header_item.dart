import 'package:flutter/material.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/common/utils/commonutils.dart';
import 'package:github/common/utils/navigatorutils.dart';
import 'package:github/common/viewmodel/repos_header_view_model.dart';
import 'package:github/ui/view/card_item.dart';
import 'package:github/ui/view/repository_issue_list_header.dart';
import 'package:github/ui/view/whg_icon_text.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/27
 *
 * @Description ReposHeader
 *
 * PS: Stay hungry,Stay foolish.
 */
class ReposHeaderItem extends StatelessWidget {
  final SelectItemChanged selectItemChanged;
  final ReposHeaderViewModel reposHeaderViewModel;

  ReposHeaderItem(this.reposHeaderViewModel, this.selectItemChanged) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        WhgCardItem(
          color: Theme.of(context).primaryColorDark,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(reposHeaderViewModel.ownerPic),
                  fit: BoxFit.cover),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Color(WhgColors.primaryDarkValue & 0xA0FFFFFF),
              ),
              child: Padding(
                padding: new EdgeInsets.only(
                    left: 10.0, top: 0.0, right: 10.0, bottom: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    firstColumn(context),
                    SizedBox(
                      height: 5.0,
                    ),
                    secondColumn(),
                    SizedBox(
                      height: 5.0,
                    ),
                    timeColumn(),
                    pullinfoColumn(context, _getInfoText()),
                    new Divider(
                      color: Color(WhgColors.subTextColor),
                    ),
                    icontitleColumn(context),
                    _renderTopicGroup(context),
                  ],
                ),
              ),
            ),
          ),
        ),
        new WhgSelectItemWidget([
          WhgStrings.repos_tab_activity,
          WhgStrings.repos_tab_commits,
        ], selectItemChanged)
      ],
    );
  }

  ///仓库创建和提交状态信息
  _getInfoText() {
    String createStr = reposHeaderViewModel.repositoryIsFork
        ? WhgStrings.repos_fork_at +
            reposHeaderViewModel.repositoryParentName +
            '\n'
        : WhgStrings.repos_create_at + reposHeaderViewModel.created_at + "\n";

    String updateStr =
        WhgStrings.repos_last_commit + reposHeaderViewModel.push_at;

    return createStr +
        ((reposHeaderViewModel.push_at != null) ? updateStr : '');
  }

  //第一行
  Widget firstColumn(BuildContext context) => Row(
        children: <Widget>[
          RawMaterialButton(
            constraints: BoxConstraints(minHeight: 0.0, minWidth: 0.0),
            padding: const EdgeInsets.all(0.0),
            onPressed: () {
              NavigatorUtils.goPerson(context, reposHeaderViewModel.ownerName);
            },
            child: Text(
              reposHeaderViewModel.ownerName,
              style: WhgConstant.normalTextMitWhiteBold,
            ),
          ),
          Text(
            " / ",
            style: WhgConstant.normalTextMitWhiteBold,
          ),
          Text(
            " " + reposHeaderViewModel.repositoryName,
            style: WhgConstant.normalTextMitWhiteBold,
          )
        ],
      );

  //第二行
  Widget secondColumn() => Row(
        children: <Widget>[
          Text(
            reposHeaderViewModel.repositoryType != null
                ? reposHeaderViewModel.repositoryType
                : "--",
            style: WhgConstant.smallSubLightText,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            child: Text(
              reposHeaderViewModel.repositorySize ?? "--",
              style: WhgConstant.smallSubLightText,
            ),
          ),
          Text(
            reposHeaderViewModel.license ?? "--",
            style: WhgConstant.smallSubLightText,
          )
        ],
      );

  //第三行
  Widget timeColumn() => new Container(
      child: new Text(reposHeaderViewModel.repositoryDes ?? "---",
          style: WhgConstant.smallSubText),
      margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
      alignment: Alignment.topLeft);

  //第四行
  Widget pullinfoColumn(BuildContext context, String infoText) => new Container(
        margin: new EdgeInsets.only(top: 6.0, bottom: 2.0, right: 5.0),
        alignment: Alignment.topRight,
        child: new RawMaterialButton(
          onPressed: () {
            if (reposHeaderViewModel.repositoryIsFork) {
              NavigatorUtils.goReposDetail(
                  context,
                  reposHeaderViewModel.repositoryParentUser,
                  reposHeaderViewModel.repositoryName);
            }
          },
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: const EdgeInsets.all(0.0),
          constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
          child: new Text(infoText,
              style: reposHeaderViewModel.repositoryIsFork
                  ? WhgConstant.smallActionLightText
                  : WhgConstant.smallSubLightText),
        ),
      );

  Widget icontitleColumn(BuildContext context) => new Padding(
      padding: new EdgeInsets.all(0.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _getBottomItem(
              WhgICons.REPOS_ITEM_STAR, reposHeaderViewModel.repositoryStar,
              () {
            NavigatorUtils.gotoCommonList(context,
                reposHeaderViewModel.repositoryName, "user", "repo_star",
                userName: reposHeaderViewModel.ownerName,
                reposName: reposHeaderViewModel.repositoryName);
          }),
          new Container(
              width: 0.3,
              height: 25.0,
              color: Color(WhgColors.subLightTextColor)),
          _getBottomItem(
              WhgICons.REPOS_ITEM_FORK, reposHeaderViewModel.repositoryFork,
              () {
            NavigatorUtils.gotoCommonList(context,
                reposHeaderViewModel.repositoryName, "repository", "repo_fork",
                userName: reposHeaderViewModel.ownerName,
                reposName: reposHeaderViewModel.repositoryName);
          }),
          new Container(
              width: 0.3,
              height: 25.0,
              color: Color(WhgColors.subLightTextColor)),
          _getBottomItem(
              WhgICons.REPOS_ITEM_WATCH, reposHeaderViewModel.repositoryWatch,
              () {
            NavigatorUtils.gotoCommonList(context,
                reposHeaderViewModel.repositoryName, "user", "repo_watcher",
                userName: reposHeaderViewModel.ownerName,
                reposName: reposHeaderViewModel.repositoryName);
          }),
          new Container(
              width: 0.3,
              height: 25.0,
              color: Color(WhgColors.subLightTextColor)),
          _getBottomItem(
              WhgICons.REPOS_ITEM_ISSUE, reposHeaderViewModel.repositoryIssue,
              () {
            if (reposHeaderViewModel.allIssueCount == null ||
                reposHeaderViewModel.allIssueCount <= 0) {
              return;
            }
            List<String> list = [
              WhgStrings.repos_all_issue_count +
                  reposHeaderViewModel.allIssueCount.toString(),
              WhgStrings.repos_open_issue_count +
                  reposHeaderViewModel.openIssuesCount.toString(),
              WhgStrings.repos_close_issue_count +
                  (reposHeaderViewModel.allIssueCount -
                          reposHeaderViewModel.openIssuesCount)
                      .toString(),
            ];
            CommonUtils.showCommitOptionDialog(context, list, (index) {},
                height: 150.0);
          }),
        ],
      ));

  _getBottomItem(IconData icon, String text, onPressed) {
    return new Expanded(
      child: new FlatButton(
        onPressed: onPressed,
        padding: new EdgeInsets.all(0.0),
        child: new WhgIconText(
          icon,
          text,
          WhgConstant.smallSubLightText,
          Color(WhgColors.subLightTextColor),
          15.0,
          padding: 3.0,
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }

  _renderTopicItem(BuildContext context, String item) {
    return new RawMaterialButton(
        onPressed: () {
          NavigatorUtils.gotoCommonList(context, item, "repository", "topics",
              userName: item, reposName: "");
        },
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.all(0.0),
        constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
        child: new Container(
          padding:
              EdgeInsets.only(left: 5.0, right: 5.0, top: 2.5, bottom: 2.5),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            color: Colors.white30,
            border: new Border.all(color: Colors.white30, width: 0.0),
          ),
          child: new Text(
            item,
            style: WhgConstant.smallSubLightText,
          ),
        ));
  }

  ///话题组控件
  _renderTopicGroup(BuildContext context) {
    if (reposHeaderViewModel.topics == null ||
        reposHeaderViewModel.topics.length == 0) {
      return Container();
    }
    List<Widget> list = new List();
    for (String item in reposHeaderViewModel.topics) {
      list.add(_renderTopicItem(context, item));
    }
    return new Container(
      alignment: Alignment.topLeft,
      child: Wrap(
        spacing: 10.0,
        runSpacing: 5.0,
        children: list,
      ),
    );
  }
}
