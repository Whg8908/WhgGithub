import 'package:flutter/material.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/common/viewmodel/release_view_model.dart';
import 'package:github/ui/view/card_item.dart';

class ReleaseItem extends StatelessWidget {
  final ReleaseItemViewModel releaseItemViewModel;

  final GestureTapCallback onPressed;
  final GestureLongPressCallback onLongPress;

  ReleaseItem(this.releaseItemViewModel, {this.onPressed, this.onLongPress})
      : super();

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new WhgCardItem(
        child: new InkWell(
          onTap: onPressed,
          onLongPress: onLongPress,
          child: new Padding(
            padding: new EdgeInsets.only(
                left: 10.0, top: 15.0, right: 10.0, bottom: 15.0),
            child: new Row(
              children: <Widget>[
                new Expanded(
                    child: new Text(releaseItemViewModel.actionTitle,
                        style: WhgConstant.smallTextBold)),
                new Container(
                    child: new Text(releaseItemViewModel.actionTime ?? "",
                        style: WhgConstant.subSmallText)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
