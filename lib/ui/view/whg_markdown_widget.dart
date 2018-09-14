import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/9/8
 *
 * @Description 自定义markdownwidget
 *
 * PS: Stay hungry,Stay foolish.
 */

class WhgMarkdownWidget extends StatelessWidget {
  final String markdownData;

  WhgMarkdownWidget({this.markdownData = ""});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5.0),
        child: SingleChildScrollView(
          child: MarkdownBody(data: markdownData),
        ));
  }
}
