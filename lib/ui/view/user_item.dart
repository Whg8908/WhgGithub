import 'package:flutter/material.dart';
import 'package:whg_github/common/bean/user_item_view_model.dart';
import 'package:whg_github/common/style/whg_style.dart';
import 'package:whg_github/ui/view/card_item.dart';
/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/9/8
 *
 * @Description UserItem
 *
 * PS: Stay hungry,Stay foolish.
 */

class UserItem extends StatelessWidget {
  final UserItemViewModel userItemViewModel;
  final VoidCallback onPressed;
  final bool needImage;

  UserItem(this.userItemViewModel, {this.onPressed, this.needImage = true});

  @override
  Widget build(BuildContext context) {
    Widget userImage = IconButton(
        padding: EdgeInsets.only(right: 10.0),
        icon: ClipOval(
          child: new FadeInImage.assetNetwork(
            placeholder: "static/images/logo.png",
            //预览图
            fit: BoxFit.fitWidth,
            image: userItemViewModel.userPic,
            width: 30.0,
            height: 30.0,
          ),
        ),
        onPressed: null);

    return Container(
      child: WhgCardItem(
        child: FlatButton(
            onPressed: onPressed,
            child: Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: Row(
                children: <Widget>[
                  userImage,
                  new Expanded(
                      child: new Text(userItemViewModel.userName,
                          style: WhgConstant.smallTextBold)),
                ],
              ),
            )),
      ),
    );
  }
}
