import 'package:flutter/material.dart';
import 'package:whg_github/common/bean/event_view_model.dart';
import 'package:whg_github/common/style/whg_style.dart';

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

  EventItem(this.eventViewModel) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        color: Color(WhgColors.cardWhite),
        margin: const EdgeInsets.all(10.0),
        child: FlatButton(
          onPressed: () => {},
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                fitrtColumn(),
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
  Widget fitrtColumn() => Row(
        children: <Widget>[
          new ClipOval(
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
          SizedBox(
            width: 10.0,
          ),
          Expanded(child: new Text(eventViewModel.actionUser)),
          Text("ffffffffffffff"),
        ],
      );

  //第二行
  secondColumn() => Container(
      child: new Text(eventViewModel.actionTarget,
          style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              height: 1.3,
              color: Colors.lightBlue)),
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
              style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  height: 1.3,
                  color: Colors.black)),
          margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
          alignment: Alignment.topLeft);
    }
  }
}
