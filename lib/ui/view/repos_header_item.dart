import 'package:flutter/material.dart';
import 'package:whg_github/common/bean/repos_header_view_model.dart';
import 'package:whg_github/common/style/whg_style.dart';
import 'package:whg_github/ui/view/card_item.dart';
import 'package:whg_github/ui/view/whg_icon_text.dart';

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
  final ReposHeaderViewModel reposHeaderViewModel;

  ReposHeaderItem(this.reposHeaderViewModel) : super();

  @override
  Widget build(BuildContext context) {
    String createStr = reposHeaderViewModel.repositoryIsFork
        ? "Frok at " + " " + reposHeaderViewModel.repositoryParentName + '\n'
        : "Create at " + " " + reposHeaderViewModel.created_at + "\n";

    String updateStr = "Last commit at " + reposHeaderViewModel.push_at;

    String infoText =
        createStr + ((reposHeaderViewModel.push_at != null) ? updateStr : '');

    return Container(
      child: WhgCardItem(
        color: Color(WhgColors.primaryValue),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              firstColumn(),
              SizedBox(
                height: 5.0,
              ),
              secondColumn(),
              SizedBox(
                height: 5.0,
              ),
              timeColumn(),
              pullinfoColumn(infoText),
              new Divider(
                color: Color(WhgColors.subTextColor),
              ),
              icontitleColumn(),
            ],
          ),
        ),
      ),
    );
  }

  //第一行
  Widget firstColumn() => Row(
        children: <Widget>[
          RawMaterialButton(
            constraints: BoxConstraints(minHeight: 0.0, minWidth: 0.0),
            padding: const EdgeInsets.all(0.0),
            onPressed: () {},
            child: Text(
              reposHeaderViewModel.ownerName,
              style: WhgConstant.normalTextMitWhite,
            ),
          ),
          Text(
            " / ",
            style: WhgConstant.normalTextMitWhite,
          ),
          Text(
            reposHeaderViewModel.repositoryName,
            style: WhgConstant.normalTextMitWhite,
          )
        ],
      );

  //第二行
  Widget secondColumn() => Row(
        children: <Widget>[
          Text(
            reposHeaderViewModel.repositoryType,
            style: WhgConstant.subLightSmallText,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            child: Text(
              reposHeaderViewModel.repositorySize,
              style: WhgConstant.subLightSmallText,
            ),
          ),
          Text(
            reposHeaderViewModel.license,
            style: WhgConstant.subLightSmallText,
          )
        ],
      );

  //第三行
  Widget timeColumn() => new Container(
      child: new Text(reposHeaderViewModel.repositoryDes,
          style: WhgConstant.subLightSmallText),
      margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
      alignment: Alignment.topLeft);

  //第四行
  Widget pullinfoColumn(String infoText) => new Container(
      child: new Text(infoText, style: WhgConstant.smallTextWhite),
      margin: new EdgeInsets.only(top: 6.0, bottom: 2.0, right: 5.0),
      alignment: Alignment.topRight);

  Widget icontitleColumn() => new Padding(
      padding: new EdgeInsets.all(5.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Expanded(
            child: new Center(
              child: new WhgIconText(
                WhgICons.REPOS_ITEM_STAR,
                reposHeaderViewModel.repositoryStar,
                WhgConstant.middleSubText,
                Color(WhgColors.subTextColor),
                15.0,
                padding: 3.0,
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
          ),
          new Container(
              width: 0.3,
              height: 30.0,
              color: Color(WhgColors.subLightTextColor)),
          new Expanded(
            child: new Center(
              child: new WhgIconText(
                WhgICons.REPOS_ITEM_FORK,
                reposHeaderViewModel.repositoryFork,
                WhgConstant.middleSubText,
                Color(WhgColors.subTextColor),
                15.0,
                padding: 3.0,
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
          ),
          new Container(
              width: 0.3,
              height: 30.0,
              color: Color(WhgColors.subLightTextColor)),
          new Expanded(
            child: new Center(
              child: new WhgIconText(
                WhgICons.REPOS_ITEM_ISSUE,
                reposHeaderViewModel.repositoryWatch,
                WhgConstant.middleSubText,
                Color(WhgColors.subTextColor),
                15.0,
                padding: 3.0,
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
          ),
          new Container(
              width: 0.3,
              height: 30.0,
              color: Color(WhgColors.subLightTextColor)),
          new Expanded(
            child: new Center(
              child: new WhgIconText(
                WhgICons.REPOS_ITEM_ISSUE,
                reposHeaderViewModel.repositoryIssue,
                WhgConstant.middleSubText,
                Color(WhgColors.subTextColor),
                15.0,
                padding: 3.0,
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
          ),
        ],
      ));
}
