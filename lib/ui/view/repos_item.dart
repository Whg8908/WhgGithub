import 'package:flutter/material.dart';
import 'package:whg_github/common/bean/repos_view_model.dart';
import 'package:whg_github/common/style/whg_style.dart';
import 'package:whg_github/ui/view/card_item.dart';
import 'package:whg_github/ui/view/whg_icon_text.dart';

class ReposItem extends StatelessWidget {
  final ReposViewModel reposViewModel;
  final VoidCallback onPressed;

  ReposItem(this.reposViewModel, {this.onPressed}) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: WhgCardItem(
        child: FlatButton(
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                firstColumn(),
                secondColumn(),
                SizedBox(
                  height: 10.0,
                ),
                thridColumn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //第一行
  Widget firstColumn() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipOval(
            child: new FadeInImage.assetNetwork(
              placeholder: "static/images/logo.png",
              //预览图
              fit: BoxFit.fitWidth,
              image: reposViewModel.ownerPic,
              width: 40.0,
              height: 40.0,
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(reposViewModel.repositoryName,
                    style: WhgConstant.normalTextBold),
                WhgIconText(
                  WhgICons.REPOS_ITEM_USER,
                  reposViewModel.ownerName,
                  WhgConstant.subLightSmallText,
                  Color(WhgColors.subLightTextColor),
                  10.0,
                  padding: 3.0,
                ),
              ],
            ),
          ),
          Text(reposViewModel.repositoryType, style: WhgConstant.subSmallText),
        ],
      );

  Widget secondColumn() => Container(
      child: new Text(
        reposViewModel.repositoryDes,
        style: WhgConstant.subSmallText,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
      alignment: Alignment.topLeft);

  Widget thridColumn() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: new Center(
              child: new WhgIconText(
                WhgICons.REPOS_ITEM_STAR,
                reposViewModel.repositoryStar,
                WhgConstant.subSmallText,
                Color(WhgColors.subTextColor),
                15.0,
                padding: 5.0,
              ),
            ),
          ),
          Expanded(
            child: new Center(
              child: new WhgIconText(
                WhgICons.REPOS_ITEM_FORK,
                reposViewModel.repositoryFork,
                WhgConstant.subSmallText,
                Color(WhgColors.subTextColor),
                15.0,
                padding: 5.0,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: new Center(
              child: new WhgIconText(
                WhgICons.REPOS_ITEM_ISSUE,
                reposViewModel.repositoryWatch,
                WhgConstant.subSmallText,
                Color(WhgColors.subTextColor),
                15.0,
                padding: 5.0,
              ),
            ),
          ),
        ],
      );
}