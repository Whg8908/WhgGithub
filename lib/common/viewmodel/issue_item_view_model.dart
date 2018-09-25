import 'package:github/common/bean/Issue.dart';
import 'package:github/common/utils/commonutils.dart';

class IssueItemViewModel {
  String actionTime = "---";
  String actionUser = "---";
  String actionUserPic = "---";
  String issueComment = "---";
  String commentCount = "---";
  String state = "---";
  String issueTag = "---";
  String number = "---";
  String id = "";

  IssueItemViewModel();

  IssueItemViewModel.fromMap(Issue issueMap, {needTitle = true}) {
    String fullName = CommonUtils.getFullName(issueMap.repoUrl);
    actionTime = CommonUtils.getNewsTimeStr(issueMap.createdAt);
    actionUser = issueMap.user.login;
    actionUserPic = issueMap.user.avatar_url;
    if (needTitle) {
      issueComment = fullName + "- " + issueMap.title;
      commentCount = issueMap.commentNum.toString();
      state = issueMap.state;
      issueTag = "#" + issueMap.number.toString();
      number = issueMap.number.toString();
    } else {
      issueComment = issueMap.body ?? "";
      id = issueMap.id.toString();
    }
  }
}
