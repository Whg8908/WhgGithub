import 'package:github/common/bean/Issue.dart';
import 'package:github/common/utils/commonutils.dart';

class IssueHeaderViewModel {
  String actionTime = "---";
  String actionUser = "---";
  String actionUserPic = "---";

//  String closed_by = "---";
  bool locked = false;
  String issueComment = "---";
  String issueDesHtml = "---";
  String commentCount = "---";
  String state = "---";
  String issueDes = "---";
  String issueTag = "---";
  String closedBy = "";

  IssueHeaderViewModel();

  IssueHeaderViewModel.fromMap(Issue issueMap) {
    actionTime = CommonUtils.getNewsTimeStr(issueMap.createdAt);
    actionUser = issueMap.user.login;
    actionUserPic = issueMap.user.avatar_url;
    closedBy = issueMap.closeBy != null ? issueMap.closeBy.login : "";
    locked = issueMap.locked;
    issueComment = issueMap.title;
    issueDesHtml = issueMap.bodyHtml != null
        ? issueMap.bodyHtml
        : (issueMap.body != null) ? issueMap.body : "";
    commentCount = issueMap.commentNum.toString() + "";
    state = issueMap.state;
    issueDes = issueMap.body != null ? ": \n" + issueMap.body : '';
    issueTag = "#" + issueMap.number.toString();
  }
}
