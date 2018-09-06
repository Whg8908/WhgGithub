import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:whg_github/common/bean/issue_item_view_model.dart';
import 'package:whg_github/common/dao/issue_dao.dart';
import 'package:whg_github/common/style/whg_style.dart';
import 'package:whg_github/common/utils/commonutils.dart';
import 'package:whg_github/ui/base/whg_list_state.dart';
import 'package:whg_github/ui/page/issue_header_view_model.dart';
import 'package:whg_github/ui/view/issue_header_item.dart';
import 'package:whg_github/ui/view/issue_item.dart';
import 'package:whg_github/ui/view/whg_pullload_widget.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/29
 *
 * @Description IssueDetailPage
 *
 * PS: Stay hungry,Stay foolish.
 */

class IssueDetailPage extends StatefulWidget {
  final String userName;

  final String reposName;

  final String issueNum;

  IssueDetailPage(this.userName, this.reposName, this.issueNum);

  @override
  IssueDetailPageState createState() =>
      new IssueDetailPageState(this.userName, this.reposName, this.issueNum);
}

class IssueDetailPageState extends WhgListState<IssueDetailPage> {
  final String userName;

  final String reposName;

  final String issueNum;

  bool headerStatus = false;

  IssueHeaderViewModel issueHeaderViewModel = new IssueHeaderViewModel();

  IssueDetailPageState(this.userName, this.reposName, this.issueNum);

  TextEditingController issueInfoTitleControl = new TextEditingController();

  TextEditingController issueInfoValueControl = new TextEditingController();

  TextEditingController issueInfoCommitValueControl =
      new TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  requestRefresh() async {
    return await _getDataLogic();
  }

  @override
  requestLoadMore() async {
    return await _getDataLogic();
  }

  _getDataLogic() async {
    if (page <= 1) {
      _getHeaderInfo();
    }
    return await IssueDao.getIssueCommentDao(userName, reposName, issueNum,
        page: page);
  }

  _getHeaderInfo() async {
    var res = await IssueDao.getIssueInfoDao(userName, reposName, issueNum);
    if (res != null && res.result) {
      setState(() {
        issueHeaderViewModel = res.data;
        headerStatus = true;
      });
    }
  }

  _renderEventItem(index) {
    if (index == 0) {
      return new IssueHeaderItem(issueHeaderViewModel, onPressed: () {});
    }
    IssueItemViewModel issueItemViewModel =
        pullLoadWidgetControl.dataList[index - 1];
    return new IssueItem(
      issueItemViewModel,
      hideBottom: true,
      limitComment: false,
      onPressed: () {
        CommonUtils.showConfirmDialog(
            context,
            WhgStrings.issue_edit_issue_edit_commit,
            WhgStrings.issue_edit_issue_delete_commit, () {
          Navigator.pop(context);
        }, () {
          _deleteCommit(issueItemViewModel.id);
        });
      },
    );
  }

  _deleteCommit(id) {
    Navigator.pop(context);
    CommonUtils.showLoadingDialog(context);
    //提交修改
    IssueDao.deleteCommentDao(userName, reposName, issueNum, id).then()(
        (result) {
      showRefreshLoading();
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  _editIssue() {
    String title = issueHeaderViewModel.issueComment;
    String content = issueHeaderViewModel.issueDesHtml;
    issueInfoTitleControl = new TextEditingController(text: title);
    issueInfoValueControl = new TextEditingController(text: content);
    //编译Issue Info
    CommonUtils.showEditDialog(
      context,
      WhgStrings.issue_edit_issue,
      (titleValue) {
        title = titleValue;
      },
      (contentValue) {
        content = contentValue;
      },
      () {
        if (title == null || title.trim().length == 0) {
          Fluttertoast.showToast(
              msg: WhgStrings.issue_edit_issue_title_not_be_null);
          return;
        }
        if (content == null || content.trim().length == 0) {
          Fluttertoast.showToast(
              msg: WhgStrings.issue_edit_issue_content_not_be_null);
          return;
        }
        CommonUtils.showLoadingDialog(context);
        //提交修改
        IssueDao.editIssueDao(userName, reposName, issueNum,
            {"title": title, "body": content}).then((result) {
          _getHeaderInfo();
          Navigator.pop(context);
          Navigator.pop(context);
        });
      },
      titleController: issueInfoTitleControl,
      valueController: issueInfoValueControl,
      needTitle: true,
    );
  }

  _replyIssue() {
    //回复 Info
    String content = "";
    CommonUtils.showEditDialog(context, WhgStrings.issue_reply_issue, null,
        (replyContent) {
      content = replyContent;
    }, () {
      if (content == null || content.trim().length == 0) {
        Fluttertoast.showToast(
            msg: WhgStrings.issue_edit_issue_content_not_be_null);
        return;
      }
      CommonUtils.showLoadingDialog(context);
      //提交评论
      IssueDao.addIssueCommentDao(userName, reposName, issueNum, content)
          .then((result) {
        showRefreshLoading();
        Navigator.pop(context);
        Navigator.pop(context);
      });
    }, needTitle: false);
  }

  _getBottomWidget() {
    List<Widget> bottomWidget = (!headerStatus)
        ? []
        : <Widget>[
            new FlatButton(
                //回复
                onPressed: () {
                  _replyIssue();
                },
                child: new Text(WhgStrings.issue_reply,
                    style: WhgConstant.smallText)),
            new Container(
                width: 0.3,
                height: 30.0,
                color: Color(WhgColors.subLightTextColor)),
            new FlatButton(
                //编辑
                onPressed: () {
                  _editIssue();
                },
                child: new Text(WhgStrings.issue_edit,
                    style: WhgConstant.smallText)),
            new Container(
                width: 0.3,
                height: 30.0,
                color: Color(WhgColors.subLightTextColor)),
            new FlatButton(
                //打开
                onPressed: () {
                  CommonUtils.showLoadingDialog(context);
                  IssueDao.editIssueDao(userName, reposName, issueNum, {
                    "state": (issueHeaderViewModel.state == "closed")
                        ? 'open'
                        : 'closed'
                  }).then((result) {
                    _getHeaderInfo();
                    Navigator.pop(context);
                  });
                },
                child: new Text(
                  (issueHeaderViewModel.state == 'closed')
                      ? WhgStrings.issue_open
                      : WhgStrings.issue_close,
                  style: WhgConstant.smallText,
                )),
            new Container(
                width: 0.3,
                height: 30.0,
                color: Color(WhgColors.subLightTextColor)),
            new FlatButton(
                //锁定
                onPressed: () {
                  CommonUtils.showLoadingDialog(context);
                  IssueDao.lockIssueDao(userName, reposName, issueNum,
                          issueHeaderViewModel.locked)
                      .then((result) {
                    _getHeaderInfo();
                    Navigator.pop(context);
                  });
                },
                child: new Text(
                    (issueHeaderViewModel.locked)
                        ? WhgStrings.issue_unlock
                        : WhgStrings.issue_lock,
                    style: WhgConstant.smallText)),
          ];
    return bottomWidget;
  }

  @override
  bool get isRefreshFirst => true;

  @override
  bool get needHeader => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.
    return new Scaffold(
      persistentFooterButtons: _getBottomWidget(),
      appBar: new AppBar(
          title: new Text(
        reposName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      )),
      body: WhgPullLoadWidget(
        (BuildContext context, int index) => _renderEventItem(index),
        handleRefresh,
        onLoadMore,
        pullLoadWidgetControl,
        refreshKey: refreshIndicatorKey,
      ),
    );
  }
}
