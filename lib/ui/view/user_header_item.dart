import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:github/common/bean/User.dart';
import 'package:github/common/bean/UserOrg.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/common/utils/commonutils.dart';
import 'package:github/common/utils/navigatorutils.dart';
import 'package:github/ui/view/card_item.dart';
import 'package:github/ui/view/whg_icon_text.dart';
import 'package:github/ui/view/whg_user_icon_widget.dart';

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
  final Color notifyColor;

  final Color themeColor;

  final VoidCallback refreshCallBack;

  final List<UserOrg> orgList;

  UserHeaderItem(this.userInfo, this.beSharedCount, this.themeColor,
      {this.notifyColor, this.refreshCallBack, this.orgList});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        WhgCardItem(
          color: themeColor,
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
                firstColumn(context),
                _renderOrgs(context, orgList),
                secondColumn(context),
                SizedBox(
                  height: 5.0,
                ),
                Divider(
                  color: Color(WhgColors.subLightTextColor),
                ),
                thirdColumn(context),
                userDynamicTitle(context),
                _renderChart(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget firstColumn(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new RawMaterialButton(
              onPressed: () {
                if (userInfo.avatar_url != null) {
                  NavigatorUtils.gotoPhotoViewPage(
                      context, userInfo.avatar_url);
                }
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: const EdgeInsets.all(0.0),
              constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
              child: new ClipOval(
                child: new FadeInImage.assetNetwork(
                  placeholder: WhgICons.DEFAULT_USER_ICON,
                  //预览图
                  fit: BoxFit.fitWidth,
                  image: userInfo.avatar_url ?? WhgICons.DEFAULT_USER_ICON,
                  width: 80.0,
                  height: 80.0,
                ),
              )),
          SizedBox(
            width: 10.0,
          ),
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Text(userInfo.login == null ? "" : userInfo.login,
                        style: WhgConstant.largeTextWhiteBold),
                    _getNotifyIcon(context, notifyColor),
                  ],
                ),
                userInfo.name != null
                    ? new Text(userInfo.name == null ? "" : userInfo.name,
                        style: WhgConstant.smallSubLightText)
                    : Container(),
                new WhgIconText(
                  WhgICons.USER_ITEM_COMPANY,
                  userInfo.company ??
                      CommonUtils.getLocale(context).nothing_now,
                  WhgConstant.smallSubLightText,
                  Color(WhgColors.subLightTextColor),
                  10.0,
                  padding: 3.0,
                ),
                new WhgIconText(
                  WhgICons.USER_ITEM_LOCATION,
                  userInfo.location ??
                      CommonUtils.getLocale(context).nothing_now,
                  WhgConstant.smallSubLightText,
                  Color(WhgColors.subLightTextColor),
                  10.0,
                  padding: 3.0,
                ),
              ],
            ),
          ),
        ],
      );

  ///用户组织
  _renderOrgs(BuildContext context, List<UserOrg> orgList) {
    if (orgList == null || orgList.length == 0) {
      return new Container();
    }
    List<Widget> list = new List();

    renderOrgsItem(UserOrg orgs) {
      return WhgUserIconWidget(
          padding: const EdgeInsets.only(right: 5.0, left: 5.0),
          width: 30.0,
          height: 30.0,
          image: orgs.avatarUrl ?? WhgICons.DEFAULT_IMAGE,
          onPressed: () {
            NavigatorUtils.goPerson(context, orgs.login);
          });
    }

    int length = orgList.length > 3 ? 3 : orgList.length;

    list.add(new Text(CommonUtils.getLocale(context).user_orgs_title + ":",
        style: WhgConstant.smallSubLightText));

    for (int i = 0; i < length; i++) {
      list.add(renderOrgsItem(orgList[i]));
    }
    if (orgList.length > 3) {
      list.add(new RawMaterialButton(
          onPressed: () {
            NavigatorUtils.gotoCommonList(
                context,
                userInfo.login +
                    " " +
                    CommonUtils.getLocale(context).user_orgs_title,
                "org",
                "user_orgs",
                userName: userInfo.login);
          },
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: const EdgeInsets.only(right: 5.0, left: 5.0),
          constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
          child: Icon(
            Icons.more_horiz,
            color: Color(WhgColors.white),
            size: 18.0,
          )));
    }
    return Row(children: list);
  }

  _getNotifyIcon(BuildContext context, Color color) {
    if (notifyColor == null) {
      return Container();
    }
    return RawMaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.only(top: 0.0, right: 5.0, left: 5.0),
        constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
        child: new ClipOval(
          child: new Icon(
            WhgICons.USER_NOTIFY,
            color: color,
            size: 18.0,
          ),
        ),
        onPressed: () {
          NavigatorUtils.goNotifyPage(context).then((res) {
            refreshCallBack?.call();
          });
        });
  }

  Widget secondColumn(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Container(

              ///用户博客
              child: new RawMaterialButton(
                onPressed: () {
                  if (userInfo.blog != null) {
                    CommonUtils.launchOutURL(userInfo.blog, context);
                  }
                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: const EdgeInsets.all(0.0),
                constraints:
                    const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
                child: new WhgIconText(
                  WhgICons.USER_ITEM_LINK,
                  userInfo.blog ?? CommonUtils.getLocale(context).nothing_now,
                  (userInfo.blog == null)
                      ? WhgConstant.smallSubLightText
                      : WhgConstant.smallActionLightText,
                  Color(WhgColors.subLightTextColor),
                  10.0,
                  padding: 3.0,
                ),
              ),
              margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
              alignment: Alignment.topLeft),
          new Container(
              child: new Text(
                userInfo.bio == null
                    ? CommonUtils.getLocale(context).user_create_at +
                        CommonUtils.getDateStr(userInfo.created_at)
                    : userInfo.bio +
                        "\n" +
                        CommonUtils.getLocale(context).user_create_at +
                        CommonUtils.getDateStr(userInfo.created_at),
                style: WhgConstant.smallSubLightText,
                maxLines: 3,
              ),
              margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
              alignment: Alignment.topLeft),
        ],
      );

  Widget thirdColumn(BuildContext context) => new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _getBottomItem(CommonUtils.getLocale(context).user_tab_repos,
              userInfo.public_repos, () {
            NavigatorUtils.gotoCommonList(
                context, userInfo.login, "repository", "user_repos",
                userName: userInfo.login);
          }),
          new Container(
              width: 0.3,
              height: 40.0,
              color: Color(WhgColors.subLightTextColor)),
          _getBottomItem(
              CommonUtils.getLocale(context).user_tab_fans, userInfo.followers,
              () {
            NavigatorUtils.gotoCommonList(
                context, userInfo.login, "user", "follower",
                userName: userInfo.login);
          }),
          new Container(
              width: 0.3,
              height: 40.0,
              color: Color(WhgColors.subLightTextColor)),
          _getBottomItem(
              CommonUtils.getLocale(context).user_tab_focus, userInfo.following,
              () {
            NavigatorUtils.gotoCommonList(
                context, userInfo.login, "user", "followed",
                userName: userInfo.login);
          }),
          new Container(
              width: 0.3,
              height: 40.0,
              color: Color(WhgColors.subLightTextColor)),
          _getBottomItem(
              CommonUtils.getLocale(context).user_tab_star, userInfo.starred,
              () {
            NavigatorUtils.gotoCommonList(
                context, userInfo.login, "repository", "user_star",
                userName: userInfo.login);
          }),
          new Container(
              width: 0.3,
              height: 40.0,
              color: Color(WhgColors.subLightTextColor)),
          _getBottomItem(CommonUtils.getLocale(context).user_tab_honor,
              beSharedCount, () {}),
        ],
      );

  Widget userDynamicTitle(BuildContext context) => Container(
      child: new Text(
        (userInfo.type == "Organization")
            ? CommonUtils.getLocale(context).user_dynamic_group
            : CommonUtils.getLocale(context).user_dynamic_title,
        style: WhgConstant.normalTextBold,
        overflow: TextOverflow.ellipsis,
      ),
      margin: new EdgeInsets.only(top: 15.0, bottom: 15.0, left: 12.0),
      alignment: Alignment.topLeft);

  Widget _getBottomItem(String title, var value, onPressed) {
    String data = value == null ? "" : value.toString();
    TextStyle valueStyle = (value != null && value.toString().length > 6)
        ? WhgConstant.minText
        : WhgConstant.smallSubLightText;
    TextStyle titleStyle = (title != null && title.toString().length > 6)
        ? WhgConstant.minText
        : WhgConstant.smallSubLightText;

    return new Expanded(
      child: new Center(
          child: new RawMaterialButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.only(top: 5.0),
              constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(text: title, style: titleStyle),
                    TextSpan(text: "\n", style: valueStyle),
                    TextSpan(text: data, style: valueStyle)
                  ],
                ),
              ),
              onPressed: onPressed)),
    );
  }

  Widget _renderChart(context) {
    double height = 140.0;
    double width = 3 * MediaQuery.of(context).size.width / 2;

    if (userInfo.login != null && userInfo.type == "Organization") {
      return new Container();
    }

    return userInfo.login != null
        ? new Card(
            margin: EdgeInsets.only(
                top: 0.0, left: 10.0, right: 10.0, bottom: 10.0),
            color: Color(WhgColors.white),
            child: new SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: new Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                width: width,
                height: height,
                child: new SvgPicture.network(
                  CommonUtils.getUserChartAddress(userInfo.login),
                  width: width,
                  height: height - 10,
                  allowDrawingOutsideViewBox: true,
                  placeholderBuilder: (BuildContext context) => new Container(
                        height: height,
                        width: width,
                        child: Center(
                          child: const SpinKitRipple(
                              color: Color(WhgColors.primaryValue)),
                        ),
                      ),
                ),
              ),
            ),
          )
        : new Container(
            height: height,
            child: Center(
              child: const SpinKitRipple(color: Color(WhgColors.primaryValue)),
            ),
          );
  }
}
