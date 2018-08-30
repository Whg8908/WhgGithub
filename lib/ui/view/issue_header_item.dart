import 'package:flutter/material.dart';
import 'package:whg_github/common/style/whg_style.dart';
import 'package:whg_github/common/utils/navigatorutils.dart';
import 'package:whg_github/ui/page/issue_header_view_model.dart';
import 'package:whg_github/ui/view/card_item.dart';
import 'package:whg_github/ui/view/whg_icon_text.dart';

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

  @override
  Widget build(BuildContext context) {
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
    return new WhgCardItem(
      color: Color(WhgColors.primaryValue),
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
                  new IconButton(
                      icon: new ClipOval(
                        child: new FadeInImage.assetNetwork(
                          placeholder: "static/images/logo.png",
                          //预览图
                          fit: BoxFit.fitWidth,
                          image: issueHeaderViewModel.actionUserPic,
                          width: 80.0,
                          height: 80.0,
                        ),
                      ),
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
                                    style: WhgConstant.normalTextWhite)),
                            new Text(
                              issueHeaderViewModel.actionTime,
                              style: WhgConstant.subSmallText,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        new Padding(padding: new EdgeInsets.all(2.0)),
                        bottomContainer,
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
              new Container(
                  child: new Text(
                    issueHeaderViewModel.issueDesHtml,
                    style: WhgConstant.smallTextWhite,
                    maxLines: 2,
                  ),
                  margin: new EdgeInsets.all(10.0),
                  alignment: Alignment.topLeft)
            ],
          ),
        ),
      ),
    );
  }
}
