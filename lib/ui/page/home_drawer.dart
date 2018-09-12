import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:whg_github/common/bean/User.dart';
import 'package:whg_github/common/dao/issue_dao.dart';
import 'package:whg_github/common/dao/user_dao.dart';
import 'package:whg_github/common/redux/whg_state.dart';
import 'package:whg_github/common/style/whg_style.dart';
import 'package:whg_github/common/utils/commonutils.dart';
import 'package:whg_github/common/utils/navigatorutils.dart';
import 'package:whg_github/ui/view/whg_flex_button.dart';

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
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                  user.login,
                  style: WhgConstant.largeTextWhite,
                ),
                accountEmail: Text(
                  user.email != null ? user.email : user.login,
                  style: WhgConstant.subNormalText,
                ),
                currentAccountPicture: GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user.avatar_url),
                  ),
                ),
                decoration: BoxDecoration(color: Color(WhgColors.primaryValue)),
              ),
              new ListTile(
                  //第一个功能项
                  title: new Text(
                    WhgStrings.home_reply,
                    style: WhgConstant.normalText,
                  ),
                  onTap: () {
                    String content = "";
                    CommonUtils.showEditDialog(
                        context, WhgStrings.home_reply, (title) {}, (res) {
                      content = res;
                    }, () {
                      if (content == null || content.length == 0) {
                        return;
                      }
                      CommonUtils.showLoadingDialog(context);
                      IssueDao.createIssueDao("Whg8908", "whg_github",
                          {"title": "问题反馈", "body": content}).then((result) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                    }, needTitle: false);
                  }),
              new ListTile(
                  title: new Text(
                    WhgStrings.home_about,
                    style: WhgConstant.normalText,
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AboutDialog(
                              applicationName: WhgStrings.app_name,
                              applicationVersion: "1.0.0",
                              applicationIcon: new Image(
                                  image:
                                      new AssetImage('static/images/logo.png'),
                                  width: 50.0,
                                  height: 50.0),
                              applicationLegalese: null,
                            ));
                  }),
              Container(
                margin: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                child: WhgFlexButton(
                    text: WhgStrings.Login_out,
                    color: Colors.red,
                    textColor: Colors.white,
                    onPress: () {
                      NavigatorUtils.goLogin(context);
                      UserDao.clearAll();
                    }),
              ),
            ],
          ),
        );
      },
    );
  }
}
