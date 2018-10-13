import 'package:github/common/bean/User.dart';
import 'package:github/common/bean/UserOrg.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/9/8
 *
 * @Description
 *
 * PS: Stay hungry,Stay foolish.
 */

class UserItemViewModel {
  String userPic;
  String userName;

  UserItemViewModel(this.userName, this.userPic);

  UserItemViewModel.fromMap(User user) {
    userName = user.login;
    userPic = user.avatar_url;
  }

  UserItemViewModel.fromOrgMap(UserOrg org) {
    userName = org.login;
    userPic = org.avatarUrl;
  }
}
