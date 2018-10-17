import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/common/utils/commonutils.dart';
import 'package:github/common/utils/fluttertoast.dart';
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
        floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.file_download),
          onPressed: () {
            Fluttertoast.showToast(msg: "开始保存照片");
            CommonUtils.saveImage(url).then((res) {
              if (res != null) {
                Fluttertoast.showToast(msg: res);
                if (Platform.isAndroid) {
                  const updateAlbum =
                      const MethodChannel('com.whg.github/UpdateAlbumPlugin');
                  updateAlbum.invokeMethod('updateAlbum', {
                    'path': res,
                    'name': CommonUtils.splitFileNameByPath(res)
                  });
                }
              }
            });
          },
        ),
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
                          height: 180.0, width: 180.0)),
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
