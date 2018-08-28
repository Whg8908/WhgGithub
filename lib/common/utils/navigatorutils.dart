import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whg_github/ui/page/home_page.dart';
import 'package:whg_github/ui/page/login_page.dart';
import 'package:whg_github/ui/page/person_page.dart';
import 'package:whg_github/ui/page/repository_detail_page.dart';

class NavigatorUtils {
  static pushReplacementNamed(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  static pushNamed(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  static goHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, HomePage.sName);
  }

  static goLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, LoginPage.sName);
  }

  static goPerson(BuildContext context, String userName) {
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new PersonPage(userName)));
  }

  ///仓库详情
  static goReposDetail(
      BuildContext context, String userName, String reposName) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) =>
                new RepositoryDetailPage(userName, reposName)));
  }
}
