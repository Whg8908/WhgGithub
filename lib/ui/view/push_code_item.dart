import 'package:flutter/material.dart';
import 'package:github/common/bean/push_code_item_view_model.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/ui/view/card_item.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/9/13
 *
 * @Description   PushCodeItem
 *
 * PS: Stay hungry,Stay foolish.
 */
class PushCodeItem extends StatelessWidget {
  final PushCodeItemViewModel pushCodeItemViewModel;
  final VoidCallback onPressed;

  PushCodeItem(this.pushCodeItemViewModel, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
              left: 10.0, top: 5.0, right: 10.0, bottom: 0.0),
          child: Text(
            pushCodeItemViewModel.path,
            style: WhgConstant.subLightSmallText,
          ),
        ),
        WhgCardItem(
          margin: const EdgeInsets.only(
              left: 10.0, top: 5.0, right: 10.0, bottom: 5.0),
          child: new ListTile(
            title: new Text(pushCodeItemViewModel.name,
                style: WhgConstant.subSmallText),
            leading: new Icon(
              WhgICons.REPOS_ITEM_FILE,
              size: 15.0,
            ),
            onTap: () {
              onPressed();
            },
          ),
        ),
      ],
    );
  }
}
