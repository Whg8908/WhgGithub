import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:github/ui/view/whg_common_option_widget.dart';

class WhgWebView extends StatelessWidget {
  final String url;
  final String title;
  final bool scrollBar;

  WhgWebView(this.url, this.title, {this.scrollBar = true});

  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      withJavascript: true,
      url: url,
      scrollBar: scrollBar,
      withLocalUrl: true,
      appBar: new AppBar(
        title: _renderTitle(),
      ),
    );
  }

  _renderTitle() {
    if (url == null || url.length == 0) {
      return new Text(title);
    }
    return new Row(children: [
      new Expanded(child: new Container()),
      WhgCommonOptionWidget(url),
    ]);
  }
}
