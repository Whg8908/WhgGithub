import 'package:github/common/bean/User.dart';
import 'package:redux/redux.dart';

final UserReducer = combineReducers<User>([
  TypedReducer<User, UpdataUserAction>(_updataLoaded),
]);

User _updataLoaded(User user, action) {
  user = action.userInfo;
  return user;
}

class UpdataUserAction {
  final User userInfo;

  UpdataUserAction(this.userInfo);
}
