import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:whg_github/common/redux/whg_state.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/22
 *
 * @Description
 *
 * PS: Stay hungry,Stay foolish.
 */

class TrendPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<WhgState, String>(
      converter: (store) => store.state.userInfo.name,
      builder: (context, name) {
        return new Text(
          name,
          style: Theme.of(context).textTheme.display1,
        );
      },
    );
  }
}
