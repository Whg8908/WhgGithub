import 'package:flutter/material.dart';
import 'package:whg_github/common/style/whg_style.dart';
import 'package:whg_github/ui/page/welcome_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: WhgColors.primarySwatch,
      ),
      home: WelComePage(),
    );
  }
}
