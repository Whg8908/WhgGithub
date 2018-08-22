import 'package:whg_github/common/bean/User.dart';
import 'package:whg_github/common/redux/user_redux.dart';

class WhgState {
  User userInfo;
  WhgState({this.userInfo});
}

class UserActions {
  final User userInfo;
  UserActions(this.userInfo);
}

WhgState appReducer(WhgState state, dynamic action) {
  return WhgState(
    userInfo: UserReducer(state.userInfo, action),
  );
}
