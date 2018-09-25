import 'package:github/common/bean/Event.dart';
import 'package:github/common/bean/Notification.dart' as Model;
import 'package:github/common/bean/RepoCommit.dart';
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

  EventViewModel.fromEventMap(Event event) {
    actionTime = CommonUtils.getNewsTimeStr(event.createdAt);
    actionUser = event.actor.login;
    actionUserPic = event.actor.avatar_url;
    var other = EventUtils.getActionAndDes(event);
    actionDes = other["des"];
    actionTarget = other["actionStr"];
  }

  EventViewModel.fromCommitMap(RepoCommit eventMap) {
    actionTime = CommonUtils.getNewsTimeStr(eventMap.commit.committer.date);
    actionUser = eventMap.commit.committer.name;
    actionDes = "sha:" + eventMap.sha;
    actionTarget = eventMap.commit.message;
  }

  EventViewModel.fromNotify(Model.Notification eventMap) {
    actionTime = CommonUtils.getNewsTimeStr(eventMap.updateAt);
    actionUser = eventMap.repository.fullName;
    String type = eventMap.subject.type;
    String status =
        eventMap.unread ? WhgStrings.notify_unread : WhgStrings.notify_readed;
    actionDes = eventMap.reason +
        "${WhgStrings.notify_type}：$type，${WhgStrings.notify_status}：$status";
    actionTarget = eventMap.subject.title;
  }
}
