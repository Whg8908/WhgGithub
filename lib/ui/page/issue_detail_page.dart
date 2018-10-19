import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:github/common/bean/Issue.dart';
import 'package:github/common/dao/issue_dao.dart';
import 'package:github/common/style/whg_style.dart';
import 'package:github/common/utils/commonutils.dart';
import 'package:github/common/utils/navigatorutils.dart';
import 'package:github/common/viewmodel/issue_item_view_model.dart';
import 'package:github/ui/base/whg_list_state.dart';
import 'package:github/ui/page/issue_header_view_model.dart';
import 'package:github/ui/view/issue_header_item.dart';
import 'package:github/ui/view/issue_item.dart';
import 'package:github/ui/view/whg_pullload_widget.dart';
import 'package:github/ui/view/whg_title_bar.dart';

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
  final bool needHomeIcon;

  IssueDetailPage(this.userName, this.reposName, this.issueNum,
      {this.needHomeIcon = false});

  @override
  IssueDetailPageState createState() => new IssueDetailPageState(
      this.userName, this.reposName, this.issueNum, this.needHomeIcon);
}

class IssueDetailPageState extends State<IssueDetailPage>
    with
        AutomaticKeepAliveClientMixin<IssueDetailPage>,
        WhgListState<IssueDetailPage> {
  final String userName;

  final String reposName;

  final String issueNum;

  bool headerStatus = false;

  bool needHomeIcon = false;

  IssueHeaderViewModel issueHeaderViewModel = new IssueHeaderViewModel();

  IssueDetailPageState(
      this.userName, this.reposName, this.issueNum, this.needHomeIcon);

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
        page: page, needDb: page <= 1);
  }

  _getHeaderInfo() async {
    IssueDao.getIssueInfoDao(userName, reposName, issueNum).then((res) {
      if (res != null && res.result) {
        _resolveHeaderInfo(res);
        return res.next;
      }
      return new Future.value(null);
    }).then((res) {
      if (res != null && res.result) {
        _resolveHeaderInfo(res);
      }
    });
  }

  _resolveHeaderInfo(res) {
    Issue issue = res.data;
    setState(() {
      issueHeaderViewModel = IssueHeaderViewModel.fromMap(issue);
      headerStatus = true;
    });
  }

  _renderEventItem(index) {
    if (index == 0) {
      return new IssueHeaderItem(issueHeaderViewModel, onPressed: () {});
    }
    Issue issue = pullLoadWidgetControl.dataList[index - 1];

    return new IssueItem(
      IssueItemViewModel.fromMap(issue, needTitle: false),
      hideBottom: true,
      limitComment: false,
      onPressed: () {
        CommonUtils.showConfirmDialog(
            context,
            CommonUtils.getLocale(context).issue_edit_issue_edit_commit,
            CommonUtils.getLocale(context).issue_edit_issue_delete_commit, () {
          _editCommit(issue.id.toString(), issue.body);
        }, () {
          _deleteCommit(issue.id.toString());
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

  _editCommit(id, content) {
    Navigator.pop(context);
    String contentData = content;
    issueInfoValueControl = new TextEditingController(text: contentData);
    //编译Issue Info
    CommonUtils.showEditDialog(
      context,
      CommonUtils.getLocale(context).issue_edit_issue,
      null,
      (contentValue) {
        contentData = contentValue;
      },
      () {
        if (contentData == null || contentData.trim().length == 0) {
          Fluttertoast.showToast(
              msg: CommonUtils.getLocale(context)
                  .issue_edit_issue_content_not_be_null);
          return;
        }
        CommonUtils.showLoadingDialog(context);
        //提交修改
        IssueDao.editCommentDao(
                userName, reposName, issueNum, id, {"body": contentData})
            .then((result) {
          showRefreshLoading();
          Navigator.pop(context);
          Navigator.pop(context);
        });
      },
      valueController: issueInfoValueControl,
      needTitle: false,
    );
  }

  _editIssue() {
    String title = issueHeaderViewModel.issueComment;
    String content = issueHeaderViewModel.issueDesHtml;
    issueInfoTitleControl = new TextEditingController(text: title);
    issueInfoValueControl = new TextEditingController(text: content);
    //编译Issue Info
    CommonUtils.showEditDialog(
      context,
      CommonUtils.getLocale(context).issue_edit_issue,
      (titleValue) {
        title = titleValue;
      },
      (contentValue) {
        content = contentValue;
      },
      () {
        if (title == null || title.trim().length == 0) {
          Fluttertoast.showToast(
              msg: CommonUtils.getLocale(context)
                  .issue_edit_issue_title_not_be_null);
          return;
        }
        if (content == null || content.trim().length == 0) {
          Fluttertoast.showToast(
              msg: CommonUtils.getLocale(context)
                  .issue_edit_issue_content_not_be_null);
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
    CommonUtils.showEditDialog(
      context,
      CommonUtils.getLocale(context).issue_reply_issue,
      null,
      (replyContent) {
        content = replyContent;
      },
      () {
        if (content == null || content.trim().length == 0) {
          Fluttertoast.showToast(
              msg: CommonUtils.getLocale(context)
                  .issue_edit_issue_content_not_be_null);
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
      },
      needTitle: false,
      titleController: issueInfoTitleControl,
      valueController: issueInfoValueControl,
    );
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
                child: new Text(CommonUtils.getLocale(context).issue_reply,
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
                child: new Text(CommonUtils.getLocale(context).issue_edit,
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
                      ? CommonUtils.getLocale(context).issue_open
                      : CommonUtils.getLocale(context).issue_close,
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
                        ? CommonUtils.getLocale(context).issue_unlock
                        : CommonUtils.getLocale(context).issue_lock,
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
        title: WhgTitleBar(
          reposName,
          needRightLocalIcon: needHomeIcon,
          iconData: WhgICons.HOME,
          onPressed: () {
            NavigatorUtils.goReposDetail(context, userName, reposName);
          },
        ),
      ),
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
