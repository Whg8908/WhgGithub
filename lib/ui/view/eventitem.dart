import 'package:flutter/material.dart';
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
                Row(
                  children: <Widget>[
                    Image(
                        image: new AssetImage('static/images/logo.png'),
                        width: 30.0,
                        height: 30.0),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(child: new Text("ffffffffffffff")),
                    Text("ffffffffffffff"),
                  ],
                ),
                Container(
                    child: new Text("Ffffffffff",
                        style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            height: 1.3,
                            color: Colors.lightBlue)),
                    margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
                    alignment: Alignment.topLeft),
                Container(
                    child: new Text("Fffffffffffe",
                        style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            height: 1.3,
                            color: Colors.black)),
                    margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
                    alignment: Alignment.topLeft)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
