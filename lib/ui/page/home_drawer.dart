import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:github/common/bean/User.dart';
import 'package:github/common/dao/event_dao.dart';
import 'package:github/common/dao/issue_dao.dart';
import 'package:github/common/dao/user_dao.dart';
import 'package:github/common/redux/whg_state.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/common/utils/commonutils.dart';
import 'package:github/common/utils/navigatorutils.dart';
import 'package:github/ui/view/whg_flex_button.dart';

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
                  user.login != null ? user.login : "---",
                  style: WhgConstant.largeTextWhite,
                ),
                accountEmail: Text(
                  user.email != null
                      ? user.email
                      : user.name != null ? user.name : "---",
                  style: WhgConstant.subNormalText,
                ),
                currentAccountPicture: GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    backgroundImage: new NetworkImage(
                        user.avatar_url != null ? user.avatar_url : "---"),
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
                      IssueDao.createIssueDao("Whg8908", "github",
                          {"title": "问题反馈", "body": content}).then((result) {
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
                    WhgStrings.home_about,
                    style: WhgConstant.normalText,
                  ),
                  onTap: () {
                    CommonUtils.showAboutDailog(context);
                  }),
              new ListTile(
                  title: new WhgFlexButton(
                    text: WhgStrings.Login_out,
                    color: Colors.redAccent,
                    textColor: Color(WhgColors.textWhite),
                    onPress: () {
                      UserDao.clearAll(store);
                      EventDao.clearEvent(store);
                      NavigatorUtils.goLogin(context);
                    },
                  ),
                  onTap: () {}),
            ],
          ),
        );
      },
    );
  }
}
