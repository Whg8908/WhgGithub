import 'package:github/common/style/whg_style.dart';
import 'package:github/common/utils/commonutils.dart';
import 'package:github/common/utils/eventutils.dart';

class EventViewModel {
  String actionUser;
  String actionUserPic;
  String actionDes;
  String actionTime;
  String actionTarget;
  var eventMap;

  EventViewModel.fromEventMap(eventMap) {
    actionTime =
        CommonUtils.getNewsTimeStr(DateTime.parse(eventMap["created_at"]));
    actionUser = eventMap["actor"]["display_login"];
    actionUserPic = eventMap["actor"]["avatar_url"];
    var other = EventUtils.getActionAndDes(eventMap);
    actionDes = other["des"];
    actionTarget = other["actionStr"];
    this.eventMap = eventMap;
  }

  EventViewModel.fromCommitMap(eventMap) {
    actionTime = CommonUtils.getNewsTimeStr(
        DateTime.parse(eventMap["commit"]["committer"]["date"]));
    actionUser = eventMap["commit"]["committer"]["name"];
    actionDes = "sha:" + eventMap["sha"];
    actionTarget = eventMap["commit"]["message"];
    this.eventMap = eventMap;
  }

  EventViewModel.fromNotify(eventMap) {
    actionTime =
        CommonUtils.getNewsTimeStr(DateTime.parse(eventMap["updated_at"]));
    actionUser = eventMap["repository"]["full_name"];
    String type = eventMap["subject"]["type"];
    String status = eventMap["unread"]
        ? WhgStrings.notify_unread
        : WhgStrings.notify_readed;
    actionDes = eventMap["reason"] +
        "${WhgStrings.notify_type}：$type，${WhgStrings.notify_status}：$status";
    actionTarget = eventMap["subject"]["title"];
    this.eventMap = eventMap;
  }
}
