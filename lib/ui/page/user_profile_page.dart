import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:github/common/bean/User.dart';
import 'package:github/common/dao/user_dao.dart';
import 'package:github/common/redux/whg_state.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/common/utils/commonutils.dart';
import 'package:github/ui/view/card_item.dart';
import 'package:redux/redux.dart';

class UserProfileInfo extends StatefulWidget {
  UserProfileInfo();

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfileInfo> {
  _renderItem(
      IconData leftIcon, String title, String value, VoidCallback onPressed) {
    return new WhgCardItem(
      child: new RawMaterialButton(
        onPressed: onPressed,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.all(15.0),
        constraints: const BoxConstraints(minWidth: 0.0, minHeight: 0.0),
        child: new Row(
          children: <Widget>[
            new Icon(leftIcon),
            new Container(
              width: 10.0,
            ),
            new Text(title, style: WhgConstant.subNormalText),
            new Container(
              width: 10.0,
            ),
            new Expanded(child: new Text(value, style: WhgConstant.normalText)),
            new Container(
              width: 10.0,
            ),
            new Icon(WhgICons.REPOS_ITEM_NEXT, size: 12.0),
          ],
        ),
      ),
    );
  }

  _showEditDialog(String title, String value, String key, Store store) {
    String content = value ?? "";
    CommonUtils.showEditDialog(context, title, (title) {}, (res) {
      content = res;
    }, () {
      if (content == null || content.length == 0) {
        return;
      }
      CommonUtils.showLoadingDialog(context);

      UserDao.updateUserDao({key: content}, store).then((res) {
        Navigator.of(context).pop();
        if (res != null && res.result) {
          Navigator.of(context).pop();
        }
      });
    },
        titleController: new TextEditingController(),
        valueController: new TextEditingController(text: value),
        needTitle: false);
  }

  List<Widget> _renderList(User userInfo, Store store) {
    return [
      _renderItem(
          Icons.info, WhgStrings.user_profile_name, userInfo.name ?? "---", () {
        _showEditDialog(
            WhgStrings.user_profile_name, userInfo.name, "name", store);
      }),
      _renderItem(
          Icons.email, WhgStrings.user_profile_email, userInfo.email ?? "---",
          () {
        _showEditDialog(
            WhgStrings.user_profile_email, userInfo.email, "email", store);
      }),
      _renderItem(
          Icons.link, WhgStrings.user_profile_link, userInfo.blog ?? "---", () {
        _showEditDialog(
            WhgStrings.user_profile_link, userInfo.blog, "blog", store);
      }),
      _renderItem(
          Icons.group, WhgStrings.user_profile_org, userInfo.company ?? "---",
          () {
        _showEditDialog(
            WhgStrings.user_profile_org, userInfo.company, "company", store);
      }),
      _renderItem(Icons.location_on, WhgStrings.user_profile_location,
          userInfo.location ?? "---", () {
        _showEditDialog(WhgStrings.user_profile_location, userInfo.location,
            "location", store);
      }),
      _renderItem(
          Icons.message, WhgStrings.user_profile_info, userInfo.bio ?? "---",
          () {
        _showEditDialog(
            WhgStrings.user_profile_info, userInfo.bio, "bio", store);
      }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new StoreBuilder<WhgState>(builder: (context, store) {
      return Scaffold(
        appBar: new AppBar(title: new Text(WhgStrings.home_user_info)),
        body: new Container(
          color: Colors.white,
          child: new SingleChildScrollView(
            child: new Column(
              children: _renderList(store.state.userInfo, store),
            ),
          ),
        ),
      );
    });
  }
}
