
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:whg_github/ui/page/home_page.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/17
 *
 * PS: Stay hungry,Stay foolish.
 */

class WelComePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    //延时跳转
    Future.delayed(Duration(seconds: 2),(){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
        return HomePage();
      }));
    });

    return Container(
      child: Center(
        child: Text("Welcome"),
      ),
    );
  }
}