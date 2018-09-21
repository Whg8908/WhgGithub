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

  IssueItemViewModel.fromMap(issueMap, {needTitle = true}) {
    String fullName = CommonUtils.getFullName(issueMap["repository_url"]);
    actionTime =
        CommonUtils.getNewsTimeStr(DateTime.parse(issueMap["created_at"]));
    actionUser = issueMap["user"]["login"];
    actionUserPic = issueMap["user"]["avatar_url"];
    if (needTitle) {
      issueComment = fullName + "- " + issueMap["title"];
      commentCount = issueMap["comments"].toString();
      state = issueMap["state"];
      issueTag = "#" + issueMap["number"].toString();
      number = issueMap["number"].toString();
    } else {
      issueComment = issueMap["body"] ?? "";
      id = issueMap["id"].toString();
    }
  }
}
