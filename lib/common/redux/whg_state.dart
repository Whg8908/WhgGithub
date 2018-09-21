import 'package:github/common/bean/Event.dart';
import 'package:github/common/bean/User.dart';
import 'package:github/common/redux/event_redux.dart';
import 'package:github/common/redux/user_redux.dart';

class WhgState {
  User userInfo;
  List<Event> eventList = new List();
  WhgState({this.userInfo, this.eventList});
}

class UserActions {
  final User userInfo;
  UserActions(this.userInfo);
}

WhgState appReducer(WhgState state, dynamic action) {
  return WhgState(
    userInfo: UserReducer(state.userInfo, action),
    eventList: EventReducer(state.eventList, action),
  );
}
