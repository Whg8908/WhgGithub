import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WhgWebView extends StatelessWidget {
  final String url;
  final String title;

  WhgWebView(this.url, this.title);

  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      url: url,
      withLocalUrl: true,
      appBar: new AppBar(
        title: new Text(title),
      ),
    );
  }
}
