import 'package:github/common/utils/commonutils.dart';

class IssueHeaderViewModel {
  String actionTime = "---";
  String actionUser = "---";
  String actionUserPic = "---";
  String closed_by = "---";
  bool locked = false;
  String issueComment = "---";
  String issueDesHtml = "---";
  String commentCount = "---";
  String state = "---";
  String issueDes = "---";
  String issueTag = "---";

  IssueHeaderViewModel();

  IssueHeaderViewModel.fromMap(issueMap) {
    actionTime =
        CommonUtils.getNewsTimeStr(DateTime.parse(issueMap["created_at"]));
    actionUser = issueMap["user"]["login"];
    actionUserPic = issueMap["user"]["avatar_url"];
    closed_by =
        issueMap["closed_by"] != null ? issueMap["closed_by"]["login"] : "";
    locked = issueMap["locked"];
    issueComment = issueMap["title"];
    issueDesHtml = issueMap["body_html"] ?? "";
    commentCount = issueMap["comments"].toString() + "";
    state = issueMap["state"];
    issueDes = issueMap["body"] != null ? ": \n" + issueMap["body"] : '';
    issueTag = "#" + issueMap["number"].toString();
  }
}
