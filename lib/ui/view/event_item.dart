import 'package:flutter/material.dart';
import 'package:whg_github/common/bean/event_view_model.dart';
import 'package:whg_github/common/style/whg_style.dart';
import 'package:whg_github/common/utils/navigatorutils.dart';
import 'package:whg_github/ui/view/card_item.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/22
 *
 * @Description  动态页面的itemview
 *
 * PS: Stay hungry,Stay foolish.
 */
class EventItem extends StatelessWidget {
  final EventViewModel eventViewModel;
  final VoidCallback onPressed;

  EventItem(this.eventViewModel, {this.onPressed}) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: WhgCardItem(
        child: FlatButton(
          onPressed: onPressed,
          child: Padding(
            padding: new EdgeInsets.only(
                left: 0.0, top: 5.0, right: 0.0, bottom: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                fitrtColumn(context),
                secondColumn(),
                thirdColumn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //第一行
  Widget fitrtColumn(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: new ClipOval(
              //有placeholder
              child: new FadeInImage.assetNetwork(
                placeholder: "static/images/logo.png",
                //预览图
                fit: BoxFit.fitWidth,
                image: eventViewModel.actionUserPic,
                width: 30.0,
                height: 30.0,
              ),
            ),
            onPressed: () {
              NavigatorUtils.goPerson(context, eventViewModel.actionUser);
            },
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
              child: new Text(
            eventViewModel.actionUser,
            style: WhgConstant.smallTextBold,
          )),
          new Text(eventViewModel.actionTime, style: WhgConstant.subSmallText),
        ],
      );

  //第二行
  Widget secondColumn() => Container(
      child: new Text(eventViewModel.actionTarget,
          style: WhgConstant.smallTextBold),
      margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
      alignment: Alignment.topLeft);

  //第三行
  Widget thirdColumn() {
    if (eventViewModel.actionDes == null ||
        eventViewModel.actionDes.length == 0) {
      return new Container();
    } else {
      return Container(
          child: new Text(eventViewModel.actionDes,
              style: WhgConstant.subSmallText),
          margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
          alignment: Alignment.topLeft);
    }
  }
}
