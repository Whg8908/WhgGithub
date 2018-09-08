import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:whg_github/common/bean/User.dart';
import 'package:whg_github/common/bean/user_item_view_model.dart';
import 'package:whg_github/common/config/config.dart';
import 'package:whg_github/common/local/local_storage.dart';
import 'package:whg_github/common/net/address.dart';
import 'package:whg_github/common/net/data_result.dart';
import 'package:whg_github/common/net/httpmanager.dart';
import 'package:whg_github/common/redux/user_redux.dart';
import 'package:whg_github/net_config.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/21
 *
 * @Description  UserDao
 *
 * PS: Stay hungry,Stay foolish.
 */

class UserDao {
  /**
   * 登录
   */
  static void login(userName, passWord, callback) async {
    String type = userName + ":" + passWord;
    var bytes = utf8.encode(type);
    var base64Str = base64.encode(bytes);
    if (Config.DEBUG) {
      print("login base64Str =  " + base64Str);
    }
    //存储本地
    await LocalStorage.put(Config.USER_NAME_KEY, userName);
    await LocalStorage.put(Config.USER_BASIC_CODE, base64Str);

    //请求参数
    Map requestParams = {
      "scopes": ['user', 'repo', 'gist', 'notifications'],
      "note": "admin_script",
      "client_id": NetConfig.CLIENT_ID,
      "client_secret": NetConfig.CLIENT_SECRET
    };

    HttpManager.clearAuthorization();

    print("params = " + json.encode(requestParams));
    //主要获取token授权
    var res = await HttpManager.fetch(Address.getAuthorization(),
        json.encode(requestParams), null, new Options(method: "post"));

    if (res != null && res.result) {
      await LocalStorage.put(Config.PW_KEY, passWord); //存储密码
      //获取user信息
      var resultData = await getUserInfo(null);
      if (Config.DEBUG) {
        print("user result " + resultData.result.toString());
        print(resultData.data);
        print(res.data.toString());
      }
    }
    if (callback != null) {
      callback(res);
    }
  }

  ///初始化用户信息
  static initUserInfo(store) async {
    var token = await LocalStorage.get(Config.TOKEN_KEY);
    var res = await getUserInfoLocal();
    if (res != null && res.result && token != null) {
      store.dispatch(UpdataUserAction(res.data));
    }
    return new DataResult(res.data, (res.result && (token != null)));
  }

  ///获取本地登录用户信息
  static getUserInfoLocal() async {
    var userText = await LocalStorage.get(Config.USER_INFO);
    if (userText != null) {
      var userMap = json.decode(userText);
      User user = User.fromJson(userMap);
      return new DataResult(user, true);
    } else {
      return new DataResult(null, false);
    }
  }

  ///获取用户详细信息
  static getUserInfo(userName) async {
    var res;
    if (userName == null) {
      res = await HttpManager.fetch(Address.getMyUserInfo(), null, null, null);
    } else {
      res = await HttpManager.fetch(
          Address.getUserInfo(userName), null, null, null);
    }
    if (res != null && res.result) {
      var countRes = await getUserStaredCountNet(res.data["login"]);
      String starred = "---";
      if (countRes.result) {
        starred = countRes.data;
      }
      User user = User.fromJson(res.data);
      user.starred = starred;
      if (userName == null) {
        LocalStorage.put(Config.USER_INFO, json.encode(user.toJson()));
      }
      return new DataResult(user, true);
    } else {
      return new DataResult(res.data, false);
    }
  }

  /**
   * 在header中提起stared count
   */
  static getUserStaredCountNet(userName) async {
    String url = Address.userStar(userName, null) + "&per_page=1";
    var res = await HttpManager.fetch(url, null, null, null);
    if (res != null && res.result && res.headers != null) {
      try {
        List<String> link = res.headers['link'];
        if (link != null) {
          int indexStart = link[0].lastIndexOf("page=") + 5;
          int indexEnd = link[0].lastIndexOf(">");
          if (indexStart >= 0 && indexEnd >= 0) {
            String count = link[0].substring(indexStart, indexEnd);
            return new DataResult(count, true);
          }
        }
      } catch (e) {
        print(e);
      }
    }
    return new DataResult(null, false);
  }

  /**
   * 获取用户粉丝列表
   */
  static getFollowerListDao(userName, page) async {
    String url =
        Address.getUserFollower(userName) + Address.getPageParams("?", page);
    var res = await HttpManager.fetch(url, null, null, null);
    if (res != null && res.result) {
      List<UserItemViewModel> list = new List();
      var data = res.data;
      if (data == null || data.length == 0) {
        return new DataResult(null, false);
      }
      for (int i = 0; i < data.length; i++) {
        list.add(
            new UserItemViewModel(data[i]['login'], data[i]["avatar_url"]));
      }
      return new DataResult(list, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /**
   * 获取用户关注列表
   */
  static getFollowedListDao(userName, page) async {
    String url =
        Address.getUserFollow(userName) + Address.getPageParams("?", page);
    var res = await HttpManager.fetch(url, null, null, null);
    if (res != null && res.result) {
      List<UserItemViewModel> list = new List();
      var data = res.data;
      if (data == null || data.length == 0) {
        return new DataResult(null, false);
      }
      for (int i = 0; i < data.length; i++) {
        list.add(
            new UserItemViewModel(data[i]['login'], data[i]["avatar_url"]));
      }
      return new DataResult(list, true);
    } else {
      return new DataResult(null, false);
    }
  }

  //清除token和用户信息
  static clearAll() async {
    HttpManager.clearAuthorization();
    LocalStorage.remove(Config.USER_INFO);
  }
}
