import 'package:flutter/material.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/common/utils/navigatorutils.dart';
import 'package:github/common/viewmodel/repos_view_model.dart';
import 'package:github/ui/view/card_item.dart';
import 'package:github/ui/view/whg_icon_text.dart';
import 'package:github/ui/view/whg_user_icon_widget.dart';

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
                firstColumn(context),
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
  Widget firstColumn(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new WhgUserIconWidget(
              padding: const EdgeInsets.only(top: 0.0, right: 5.0, left: 0.0),
              width: 40.0,
              height: 40.0,
              image: reposViewModel.ownerPic,
              onPressed: () {
                NavigatorUtils.goPerson(context, reposViewModel.ownerName);
              }),
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
                  WhgConstant.smallSubLightText,
                  Color(WhgColors.subLightTextColor),
                  10.0,
                  padding: 3.0,
                ),
              ],
            ),
          ),
          Text(reposViewModel.repositoryType, style: WhgConstant.smallSubText),
        ],
      );

  Widget secondColumn() => Container(
      child: new Text(
        reposViewModel.repositoryDes,
        style: WhgConstant.smallSubText,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
      alignment: Alignment.topLeft);

  Widget thridColumn() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _getBottomItem(
              WhgICons.REPOS_ITEM_STAR, reposViewModel.repositoryStar),
          _getBottomItem(
              WhgICons.REPOS_ITEM_FORK, reposViewModel.repositoryFork),
          _getBottomItem(
              WhgICons.REPOS_ITEM_ISSUE, reposViewModel.repositoryWatch,
              flex: 4),
        ],
      );

  _getBottomItem(IconData icon, String text, {int flex = 2}) {
    return Expanded(
      flex: flex,
      child: new Center(
        child: new WhgIconText(
          icon,
          text,
          WhgConstant.smallSubText,
          Color(WhgColors.subTextColor),
          15.0,
          padding: 5.0,
        ),
      ),
    );
  }
}
