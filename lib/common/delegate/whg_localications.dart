import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:github/common/redux/whg_state.dart';

class WhgLocalizations extends StatefulWidget {
  final Widget child;

  WhgLocalizations({Key key, this.child}) : super(key: key);

  @override
  State<WhgLocalizations> createState() {
    return new _WhgLocalizations();
  }
}

class _WhgLocalizations extends State<WhgLocalizations> {
  @override
  Widget build(BuildContext context) {
    return new StoreBuilder<WhgState>(builder: (context, store) {
      return new Localizations.override(
        context: context,
        locale: store.state.locale,
        child: widget.child,
      );
    });
  }
}
