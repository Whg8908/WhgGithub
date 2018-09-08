import 'package:flutter/material.dart';
import 'package:whg_github/common/bean/User.dart';
import 'package:whg_github/common/style/whg_style.dart';
import 'package:whg_github/common/utils/navigatorutils.dart';
import 'package:whg_github/ui/view/card_item.dart';
import 'package:whg_github/ui/view/whg_icon_text.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/23
 *
 * @Description  我的页面item
 *
 * PS: Stay hungry,Stay foolish.
 */
class UserHeaderItem extends StatelessWidget {
  final User userInfo;
  final String beSharedCount;

  UserHeaderItem(this.userInfo, this.beSharedCount);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        WhgCardItem(
          color: Color(WhgColors.primaryValue),
          margin: EdgeInsets.all(0.0),
          shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0))),
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
                Divider(
                  color: Color(WhgColors.subLightTextColor),
                ),
                thirdColumn(context),
                userDynamicTitle(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget firstColumn() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipOval(
            child: FadeInImage.assetNetwork(
              placeholder: "static/images/logo.png",
              image: userInfo.avatar_url == null ? "" : userInfo.avatar_url,
              fit: BoxFit.fitWidth,
              width: 80.0,
              height: 80.0,
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(userInfo.login == null ? "" : userInfo.login,
                    style: WhgConstant.largeTextWhiteBold),
                userInfo.name != null
                    ? new Text(userInfo.name == null ? "" : userInfo.name,
                        style: WhgConstant.subLightSmallText)
                    : Container(),
                new WhgIconText(
                  WhgICons.USER_ITEM_COMPANY,
                  userInfo.company == null
                      ? WhgStrings.nothing_now
                      : userInfo.company,
                  WhgConstant.subLightSmallText,
                  Color(WhgColors.subLightTextColor),
                  10.0,
                  padding: 3.0,
                ),
                new WhgIconText(
                  WhgICons.USER_ITEM_LOCATION,
                  userInfo.location == null
                      ? WhgStrings.nothing_now
                      : userInfo.location,
                  WhgConstant.subLightSmallText,
                  Color(WhgColors.subLightTextColor),
                  10.0,
                  padding: 3.0,
                ),
              ],
            ),
          ),
        ],
      );

  Widget secondColumn() => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Container(
              child: new WhgIconText(
                WhgICons.USER_ITEM_LINK,
                userInfo.blog == null ? WhgStrings.nothing_now : userInfo.blog,
                WhgConstant.subLightSmallText,
                Color(WhgColors.subLightTextColor),
                10.0,
                padding: 3.0,
              ),
              margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
              alignment: Alignment.topLeft),
          new Container(
              child: new Text(
                userInfo.bio == null ? WhgStrings.nothing_now : userInfo.bio,
                style: WhgConstant.subLightSmallText,
                maxLines: 3,
              ),
              margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
              alignment: Alignment.topLeft),
        ],
      );

  Widget thirdColumn(BuildContext context) => new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _getBottomItem(WhgStrings.user_tab_repos, userInfo.public_repos, () {
            NavigatorUtils.gotoCommonList(
                context, userInfo.login, "repository", "user_repos",
                userName: userInfo.login);
          }),
          new Container(
              width: 0.3,
              height: 40.0,
              color: Color(WhgColors.subLightTextColor)),
          _getBottomItem(WhgStrings.user_tab_fans, userInfo.followers, () {
            NavigatorUtils.gotoCommonList(
                context, userInfo.login, "user", "follower",
                userName: userInfo.login);
          }),
          new Container(
              width: 0.3,
              height: 40.0,
              color: Color(WhgColors.subLightTextColor)),
          _getBottomItem(WhgStrings.user_tab_focus, userInfo.following, () {
            NavigatorUtils.gotoCommonList(
                context, userInfo.login, "user", "followed",
                userName: userInfo.login);
          }),
          new Container(
              width: 0.3,
              height: 40.0,
              color: Color(WhgColors.subLightTextColor)),
          _getBottomItem(WhgStrings.user_tab_star, userInfo.starred, () {
            NavigatorUtils.gotoCommonList(
                context, userInfo.login, "repository", "user_star",
                userName: userInfo.login);
          }),
          new Container(
              width: 0.3,
              height: 40.0,
              color: Color(WhgColors.subLightTextColor)),
          _getBottomItem(WhgStrings.user_tab_honor, beSharedCount, () {}),
        ],
      );

  Widget userDynamicTitle() => Container(
      child: new Text(
        WhgStrings.user_dynamic_title,
        style: WhgConstant.normalTextBold,
        overflow: TextOverflow.ellipsis,
      ),
      margin: new EdgeInsets.only(top: 15.0, bottom: 15.0, left: 12.0),
      alignment: Alignment.topLeft);

  Widget _getBottomItem(String title, var value, onPressed) {
    return new Expanded(
      child: new Center(
        child: new FlatButton(
          onPressed: onPressed,
          child: new Text(
              title + "\n" + (value == null ? "" : value.toString()),
              textAlign: TextAlign.center,
              style: WhgConstant.subSmallText),
        ),
      ),
    );
  }
}
