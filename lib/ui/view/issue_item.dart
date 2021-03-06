import 'package:flutter/material.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/common/utils/navigatorutils.dart';
import 'package:github/common/viewmodel/issue_item_view_model.dart';
import 'package:github/ui/view/card_item.dart';
import 'package:github/ui/view/whg_icon_text.dart';
import 'package:github/ui/view/whg_markdown_widget.dart';
import 'package:github/ui/view/whg_user_icon_widget.dart';
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

  final bool hideBottom;

  final bool limitComment;

  IssueItem(this.issueItemViewModel,
      {this.onPressed, this.hideBottom = false, this.limitComment = true});

  @override
  Widget build(BuildContext context) {
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
                new WhgUserIconWidget(
                    width: 30.0,
                    height: 30.0,
                    image: issueItemViewModel.actionUserPic,
                    onPressed: () {
                      NavigatorUtils.goPerson(
                          context, issueItemViewModel.actionUser);
                    }),
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
                            style: WhgConstant.smallSubText,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      new Padding(
                        padding: new EdgeInsets.only(
                            left: 0.0, top: 2.0, right: 0.0, bottom: 0.0),
                      ),
                      _renderCommentText(),
                      new Padding(
                        padding: new EdgeInsets.only(
                            left: 0.0, top: 2.0, right: 0.0, bottom: 0.0),
                      ),
                      buttomContainer(),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  ///评论内容
  _renderCommentText() {
    return (limitComment)
        ? new Container(
            child: new Text(
              issueItemViewModel.issueComment,
              style: WhgConstant.smallSubText,
              maxLines: limitComment ? 2 : 1000,
            ),
            margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
            alignment: Alignment.topLeft,
          )
        : WhgMarkdownWidget(markdownData: issueItemViewModel.issueComment);
  }

  buttomContainer() {
    Color issueStateColor =
        issueItemViewModel.state == "open" ? Colors.green : Colors.red;

    if (hideBottom) {
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
                style: WhgConstant.smallSubText),
          ),
          new WhgIconText(
            WhgICons.ISSUE_ITEM_COMMENT,
            issueItemViewModel.commentCount,
            WhgConstant.smallSubText,
            Color(WhgColors.subTextColor),
            15.0,
            padding: 2.0,
          ),
        ],
      );
    }
  }
}
