import 'package:whg_github/common/utils/commonutils.dart';

class IssueItemViewModel {
  String actionTime = "---";
  String actionUser = "---";
  String actionUserPic = "---";
  String issueComment = "---";
  String commentCount = "---";
  String state = "---";
  String issueTag = "---";

  IssueItemViewModel();

  IssueItemViewModel.fromMap(issueMap) {
    String fullName = CommonUtils.getFullName(issueMap["repository_url"]);
    actionTime =
        CommonUtils.getNewsTimeStr(DateTime.parse(issueMap["created_at"]));
    actionUser = issueMap["user"]["login"];
    actionUserPic = issueMap["user"]["avatar_url"];
    issueComment = fullName + "- " + issueMap["title"];
    commentCount = issueMap["comments"].toString();
    state = issueMap["state"];
    issueTag = "#" + issueMap["number"].toString();
  }
}
