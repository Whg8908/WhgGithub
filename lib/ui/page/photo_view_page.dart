import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/ui/view/whg_common_option_widget.dart';
import 'package:github/ui/view/whg_title_bar.dart';
import 'package:photo_view/photo_view.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/10/13
 *
 * @Description PhotoView
 *
 * PS: Stay hungry,Stay foolish.
 */
class PhotoViewPage extends StatelessWidget {
  final String url;

  PhotoViewPage(this.url);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: WhgTitleBar("", rightWidget: new WhgCommonOptionWidget(url)),
        ),
        body: new Container(
          color: Colors.black,
          child: new PhotoView(
            imageProvider: new NetworkImage(url ?? WhgICons.DEFAULT_IMAGE),
            loadingChild: Container(
              child: new Stack(
                children: <Widget>[
                  new Center(
                      child: new Image.asset(WhgICons.DEFAULT_IMAGE,
                          height: 150.0, width: 150.0)),
                  new Center(
                      child: new SpinKitFoldingCube(
                          color: Colors.white30, size: 60.0)),
                ],
              ),
            ),
          ),
        ));
  }
}
