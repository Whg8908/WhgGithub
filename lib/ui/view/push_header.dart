import 'package:flutter/material.dart';
import 'package:whg_github/common/bean/push_header_view_model.dart';
import 'package:whg_github/common/style/whg_style.dart';
import 'package:whg_github/common/utils/navigatorutils.dart';
import 'package:whg_github/ui/view/card_item.dart';
import 'package:whg_github/ui/view/whg_icon_text.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/9/13
 *
 * @Description
 *
 * PS: Stay hungry,Stay foolish.
 */
class PushHeader extends StatelessWidget {
  final PushHeaderViewModel pushHeaderViewModel;

  PushHeader(this.pushHeaderViewModel);

  @override
  Widget build(BuildContext context) {
    return WhgCardItem(
      color: Color(WhgColors.primaryValue),
      child: FlatButton(
        onPressed: () {},
        child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new IconButton(
                        icon: new ClipOval(
                          child: new FadeInImage.assetNetwork(
                            placeholder: "static/images/logo.png",
                            //预览图
                            fit: BoxFit.fitWidth,
                            image: pushHeaderViewModel.actionUserPic,
                            width: 90.0,
                            height: 90.0,
                          ),
                        ),
                        onPressed: () {
                          NavigatorUtils.goPerson(
                              context, pushHeaderViewModel.actionUser);
                        }),
                    new Expanded(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Row(
                          children: <Widget>[
                            _getIconItem(WhgICons.PUSH_ITEM_EDIT,
                                pushHeaderViewModel.editCount),
                            new Container(width: 8.0),
                            _getIconItem(WhgICons.PUSH_ITEM_ADD,
                                pushHeaderViewModel.addCount),
                            new Container(width: 8.0),
                            _getIconItem(WhgICons.PUSH_ITEM_MIN,
                                pushHeaderViewModel.deleteCount),
                            new Container(width: 8.0),
                          ],
                        ),
                        SizedBox(
                          height: 2.0,
                        ),
                        new Container(
                            child: new Text(
                              pushHeaderViewModel.pushTime,
                              style: WhgConstant.smallTextWhite,
                              maxLines: 2,
                            ),
                            margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
                            alignment: Alignment.topLeft),
                        new Container(
                            child: new Text(
                              pushHeaderViewModel.pushDes,
                              style: WhgConstant.smallTextWhite,
                              maxLines: 2,
                            ),
                            margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
                            alignment: Alignment.topLeft),
                        SizedBox(
                          height: 2.0,
                        ),
                      ],
                    ))
                  ],
                ),
              ],
            )),
      ),
    );
  }

  _getIconItem(IconData icon, String text) {
    return new WhgIconText(
      icon,
      text,
      WhgConstant.subSmallText,
      Color(WhgColors.subTextColor),
      15.0,
      padding: 0.0,
    );
  }
}
