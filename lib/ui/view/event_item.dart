import 'package:flutter/material.dart';
import 'package:github/common/bean/event_view_model.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/common/utils/navigatorutils.dart';
import 'package:github/ui/view/card_item.dart';
import 'package:github/ui/view/whg_user_icon_widget.dart';

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
  final bool needImage;

  EventItem(this.eventViewModel, {this.onPressed, this.needImage = true})
      : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: WhgCardItem(
        child: FlatButton(
          onPressed: onPressed,
          child: Padding(
            padding: new EdgeInsets.only(
                left: 0.0, top: 10.0, right: 0.0, bottom: 10.0),
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
          imageRow(context),
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
          child: new Text(
            eventViewModel.actionDes,
            style: WhgConstant.subSmallText,
            maxLines: 3,
          ),
          margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
          alignment: Alignment.topLeft);
    }
  }

  imageRow(BuildContext context) {
    if (needImage) {
      return new WhgUserIconWidget(
          padding: const EdgeInsets.only(top: 0.0, right: 5.0, left: 0.0),
          width: 30.0,
          height: 30.0,
          image: eventViewModel.actionUserPic,
          onPressed: () {
            NavigatorUtils.goPerson(context, eventViewModel.actionUser);
          });
    } else {
      return Container();
    }
  }
}
