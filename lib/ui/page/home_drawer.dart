import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:github/common/bean/User.dart';
import 'package:github/common/config/config.dart';
import 'package:github/common/dao/event_dao.dart';
import 'package:github/common/dao/issue_dao.dart';
import 'package:github/common/dao/user_dao.dart';
import 'package:github/common/db/sql_manager.dart';
import 'package:github/common/local/local_storage.dart';
import 'package:github/common/redux/themedata_redux.dart';
import 'package:github/common/redux/whg_state.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/common/utils/commonutils.dart';
import 'package:github/common/utils/navigatorutils.dart';
import 'package:github/ui/view/whg_flex_button.dart';
import 'package:redux/redux.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/23
 *
 * @Description   HomeDrawer
 *
 * PS: Stay hungry,Stay foolish.
 */

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreBuilder<WhgState>(
      builder: (context, store) {
        User user = store.state.userInfo;
        return Drawer(
          child: Container(
            color: store.state.themeData.primaryColor,
            child: new SingleChildScrollView(
              child: new Container(
                constraints: new BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height),
                child: new Material(
                  color: Color(WhgColors.white),
                  child: new Column(
                    children: <Widget>[
                      UserAccountsDrawerHeader(
                        accountName: Text(
                          user.login ?? "---",
                          style: WhgConstant.largeTextWhite,
                        ),
                        accountEmail: Text(
                          user.email ?? user.name ?? "---",
                          style: WhgConstant.normalTextLight,
                        ),
                        currentAccountPicture: GestureDetector(
                          onTap: () {},
                          child: CircleAvatar(
                            backgroundImage:
                                new NetworkImage(user.avatar_url ?? "---"),
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: store.state.themeData.primaryColor),
                      ),
                      new ListTile(
                          //第一个功能项
                          title: new Text(
                            CommonUtils.getLocale(context).home_reply,
                            style: WhgConstant.normalText,
                          ),
                          onTap: () {
                            String content = "";
                            CommonUtils.showEditDialog(
                                context,
                                CommonUtils.getLocale(context).home_reply,
                                (title) {}, (res) {
                              content = res;
                            }, () {
                              if (content == null || content.length == 0) {
                                return;
                              }
                              CommonUtils.showLoadingDialog(context);
                              IssueDao.createIssueDao("Whg8908", "github", {
                                "title": "问题反馈",
                                "body": content
                              }).then((result) {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              });
                            },
                                titleController: new TextEditingController(),
                                valueController: new TextEditingController(),
                                needTitle: false);
                          }),
                      new ListTile(
                          title: new Text(
                            CommonUtils.getLocale(context).home_history,
                            style: WhgConstant.normalText,
                          ),
                          onTap: () {
                            NavigatorUtils.gotoCommonList(
                                context,
                                CommonUtils.getLocale(context).home_history,
                                "repository",
                                "history",
                                userName: "",
                                reposName: "");
                          }),
                      new ListTile(
                          title: new Text(
                            CommonUtils.getLocale(context).home_user_info,
                            style: WhgConstant.normalText,
                          ),
                          onTap: () {
                            NavigatorUtils.gotoUserProfileInfo(context);
                          }),
                      new ListTile(
                          title: new Text(
                            CommonUtils.getLocale(context).home_change_theme,
                            style: WhgConstant.normalText,
                          ),
                          onTap: () {
                            showThemeDialog(context, store);
                          }),
                      new ListTile(
                          title: new Text(
                            CommonUtils.getLocale(context).home_change_language,
                            style: WhgConstant.normalText,
                          ),
                          onTap: () {
                            CommonUtils.showLanguageDialog(context, store);
                          }),
                      new ListTile(
                          title: new Text(
                            CommonUtils.getLocale(context).home_about,
                            style: WhgConstant.normalText,
                          ),
                          onTap: () {
                            CommonUtils.showAboutDailog(context);

                            store.dispatch(new RefreshThemeDataAction(
                                new ThemeData(primarySwatch: Colors.blue)));
                          }),
                      new ListTile(
                          title: new WhgFlexButton(
                            text: CommonUtils.getLocale(context).Login_out,
                            color: Colors.redAccent,
                            textColor: Color(WhgColors.textWhite),
                            onPress: () {
                              UserDao.clearAll(store);
                              EventDao.clearEvent(store);
                              SqlManager.close();
                              NavigatorUtils.goLogin(context);
                            },
                          ),
                          onTap: () {}),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  showThemeDialog(BuildContext context, Store store) {
    List<String> list = [
      CommonUtils.getLocale(context).home_theme_default,
      CommonUtils.getLocale(context).home_theme_1,
      CommonUtils.getLocale(context).home_theme_2,
      CommonUtils.getLocale(context).home_theme_3,
      CommonUtils.getLocale(context).home_theme_4,
      CommonUtils.getLocale(context).home_theme_5,
      CommonUtils.getLocale(context).home_theme_6,
    ];
    CommonUtils.showCommitOptionDialog(context, list, (index) {
      CommonUtils.pushTheme(store, index);
      LocalStorage.put(Config.THEME_COLOR, index.toString());
    }, colorList: CommonUtils.getThemeListColor());
  }
}
