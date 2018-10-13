import 'package:flutter/material.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/common/utils/navigatorutils.dart';
import 'package:github/ui/page/issue_header_view_model.dart';
import 'package:github/ui/view/card_item.dart';
import 'package:github/ui/view/whg_icon_text.dart';
import 'package:github/ui/view/whg_markdown_widget.dart';
import 'package:github/ui/view/whg_user_icon_widget.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/29
 *
 * @Description   IssueHeaderItem
 *
 * PS: Stay hungry,Stay foolish.
 */
class IssueHeaderItem extends StatelessWidget {
  final IssueHeaderViewModel issueHeaderViewModel;

  final VoidCallback onPressed;

  IssueHeaderItem(this.issueHeaderViewModel, {this.onPressed});

  _renderBottomContainer() {
    Color issueStateColor =
        issueHeaderViewModel.state == "open" ? Colors.green : Colors.red;

    Widget bottomContainer = new Row(
      children: <Widget>[
        new WhgIconText(
          WhgICons.ISSUE_ITEM_ISSUE,
          issueHeaderViewModel.state,
          TextStyle(
            color: issueStateColor,
            fontSize: WhgConstant.smallTextSize,
          ),
          issueStateColor,
          15.0,
          padding: 2.0,
        ),
        new Padding(padding: new EdgeInsets.all(2.0)),
        new Text(issueHeaderViewModel.issueTag,
            style: WhgConstant.smallTextWhite),
        new Padding(padding: new EdgeInsets.all(2.0)),
        new WhgIconText(
          WhgICons.ISSUE_ITEM_COMMENT,
          issueHeaderViewModel.commentCount,
          WhgConstant.smallTextWhite,
          Color(WhgColors.white),
          15.0,
          padding: 2.0,
        ),
      ],
    );
    return bottomContainer;
  }

  @override
  Widget build(BuildContext context) {
    return new WhgCardItem(
      color: Theme.of(context).primaryColor,
      child: new FlatButton(
        padding: new EdgeInsets.all(0.0),
        onPressed: onPressed,
        child: new Padding(
          padding: new EdgeInsets.all(10.0),
          child: new Column(
            children: <Widget>[
              new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new WhgUserIconWidget(
                      padding: const EdgeInsets.only(
                          top: 0.0, right: 10.0, left: 0.0),
                      width: 50.0,
                      height: 50.0,
                      image: issueHeaderViewModel.actionUserPic,
                      onPressed: () {
                        NavigatorUtils.goPerson(
                            context, issueHeaderViewModel.actionUser);
                      }),
                  new Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Row(
                          children: <Widget>[
                            new Expanded(
                                child: new Text(issueHeaderViewModel.actionUser,
                                    style: WhgConstant.smallSubLightText)),
                            new Text(
                              issueHeaderViewModel.actionTime,
                              style: WhgConstant.smallSubText,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        new Padding(padding: new EdgeInsets.all(2.0)),
                        _renderBottomContainer(),
                        new Container(
                            child: new Text(
                              issueHeaderViewModel.issueComment,
                              style: WhgConstant.smallTextWhite,
                              maxLines: 2,
                            ),
                            margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
                            alignment: Alignment.topLeft),
                        new Padding(
                          padding: new EdgeInsets.only(
                              left: 0.0, top: 2.0, right: 0.0, bottom: 0.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              ///评论内容
              WhgMarkdownWidget(
                  markdownData: issueHeaderViewModel.issueDesHtml,
                  style: WhgMarkdownWidget.DARK_THEME),

              ///close 用户
              _renderCloseByText()
            ],
          ),
        ),
      ),
    );
  }

  ///关闭操作人
  _renderCloseByText() {
    return (issueHeaderViewModel.closedBy == null ||
            issueHeaderViewModel.closedBy.trim().length == 0)
        ? new Container()
        : new Container(
            child: new Text(
              "Close By " + issueHeaderViewModel.closedBy,
              style: WhgConstant.smallSubLightText,
            ),
            margin: new EdgeInsets.only(right: 5.0, top: 10.0, bottom: 10.0),
            alignment: Alignment.topRight);
  }
}
