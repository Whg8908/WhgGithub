import 'package:whg_github/common/utils/eventutils.dart';

class EventViewModel {
  String actionUser;
  String actionUserPic;
  String actionDes;
  String actionTime;
  String actionTarget;

  EventViewModel.fromEventMap(eventMap) {
    //actionTime = eventMap["created_at"];
    actionUser = eventMap["actor"]["display_login"];
    actionUserPic = eventMap["actor"]["avatar_url"];
    var other = EventUtils.getActionAndDes(eventMap);
    actionDes = other["des"];
    actionTarget = other["actionStr"];
  }
}
