import 'package:flutter/material.dart';
import 'package:whg_github/common/bean/issue_item_view_model.dart';
import 'package:whg_github/common/style/whg_style.dart';
import 'package:whg_github/ui/view/card_item.dart';
import 'package:whg_github/ui/view/whg_icon_text.dart';
/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/28
 *
 * @Description   IssueItem
 *
 * PS: Stay hungry,Stay foolish.
 */

class IssueItem extends StatelessWidget {
  final IssueItemViewModel issueItemViewModel;
  final VoidCallback onPressed;
  final bool needBottom;

  IssueItem(this.issueItemViewModel, {this.onPressed, this.needBottom = false});

  @override
  Widget build(BuildContext context) {
    Color issueStateColor =
        issueItemViewModel.state == "open" ? Colors.green : Colors.red;

    return WhgCardItem(
      child: FlatButton(
        padding: new EdgeInsets.all(0.0),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 5.0, top: 5.0, right: 10.0, bottom: 8.0),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new IconButton(
                    icon: new ClipOval(
                      child: new FadeInImage.assetNetwork(
                        placeholder: "static/images/logo.png",
                        //预览图
                        fit: BoxFit.fitWidth,
                        image: issueItemViewModel.actionUserPic,
                        width: 30.0,
                        height: 30.0,
                      ),
                    ),
                    onPressed: () {}),
                new Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          new Expanded(
                              child: new Text(issueItemViewModel.actionUser,
                                  style: WhgConstant.smallTextBold)),
                          new Text(
                            issueItemViewModel.actionTime,
                            style: WhgConstant.subSmallText,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      new Padding(
                        padding: new EdgeInsets.only(
                            left: 0.0, top: 2.0, right: 0.0, bottom: 0.0),
                      ),
                      new Container(
                          child: new Text(
                            issueItemViewModel.issueComment,
                            style: WhgConstant.subSmallText,
                            maxLines: 2,
                          ),
                          margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
                          alignment: Alignment.topLeft),
                      new Padding(
                        padding: new EdgeInsets.only(
                            left: 0.0, top: 2.0, right: 0.0, bottom: 0.0),
                      ),
                      buttomContainer(issueStateColor),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  buttomContainer(Color issueStateColor) {
    if (needBottom) {
      return Container();
    } else {
      return new Row(
        children: <Widget>[
          new WhgIconText(
            WhgICons.ISSUE_ITEM_ISSUE,
            issueItemViewModel.state,
            TextStyle(
              color: issueStateColor,
              fontSize: WhgConstant.smallTextSize,
            ),
            issueStateColor,
            15.0,
            padding: 2.0,
          ),
          new Padding(padding: new EdgeInsets.all(2.0)),
          new Expanded(
            child: new Text(issueItemViewModel.issueTag,
                style: WhgConstant.subSmallText),
          ),
          new WhgIconText(
            WhgICons.ISSUE_ITEM_COMMENT,
            issueItemViewModel.commentCount,
            WhgConstant.subSmallText,
            Color(WhgColors.subTextColor),
            15.0,
            padding: 2.0,
          ),
        ],
      );
    }
  }
}
