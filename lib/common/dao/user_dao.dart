import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:github/common/bean/Notification.dart';
import 'package:github/common/bean/User.dart';
import 'package:github/common/config/config.dart';
import 'package:github/common/db/provider/user/UserFollowedDbProvider.dart';
import 'package:github/common/db/provider/user/UserFollowerDbProvider.dart';
import 'package:github/common/db/provider/user/UserInfoDbProvider.dart';
import 'package:github/common/local/local_storage.dart';
import 'package:github/common/net/address.dart';
import 'package:github/common/net/data_result.dart';
import 'package:github/common/net/httpmanager.dart';
import 'package:github/common/redux/user_redux.dart';
import 'package:github/net_config.dart';
import 'package:redux/redux.dart';

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
  static login(userName, passWord, store) async {
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
    var resultData = null;

    if (res != null && res.result) {
      await LocalStorage.put(Config.PW_KEY, passWord); //存储密码
      //获取user信息
      var resultData = await getUserInfo(null);
      if (Config.DEBUG) {
        print("user result " + resultData.result.toString());
        print(resultData.data);
        print(res.data.toString());
      }
      store.dispatch(new UpdataUserAction(resultData.data));
    }
    return new DataResult(resultData, res.result);
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
  static getUserInfo(userName, {needDb = false}) async {
    UserInfoDbProvider provider = new UserInfoDbProvider();
    next() async {
      var res;
      if (userName == null) {
        res =
            await HttpManager.fetch(Address.getMyUserInfo(), null, null, null);
      } else {
        res = await HttpManager.fetch(
            Address.getUserInfo(userName), null, null, null);
      }
      if (res != null && res.result) {
        String starred = "---";
        if (res.data["type"] != "Organization") {
          var countRes = await getUserStaredCountNet(res.data["login"]);
          if (countRes.result) {
            starred = countRes.data;
          }
        }
        User user = User.fromJson(res.data);
        user.starred = starred;
        if (userName == null) {
          LocalStorage.put(Config.USER_INFO, json.encode(user.toJson()));
        } else {
          if (needDb) {
            provider.insert(userName, json.encode(user.toJson()));
          }
        }
        return new DataResult(user, true);
      } else {
        return new DataResult(res.data, false);
      }
    }

    if (needDb) {
      User user = await provider.getUserInfo(userName);
      if (user == null) {
        return await next();
      }
      DataResult dataResult = new DataResult(user, true, next: next());
      return dataResult;
    }
    return await next();
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
  static getFollowerListDao(userName, page, {needDb = false}) async {
    UserFollowerDbProvider provider = new UserFollowerDbProvider();

    next() async {
      String url =
          Address.getUserFollower(userName) + Address.getPageParams("?", page);
      var res = await HttpManager.fetch(url, null, null, null);
      if (res != null && res.result) {
        List<User> list = new List();
        var data = res.data;
        if (data == null || data.length == 0) {
          return new DataResult(null, false);
        }
        for (int i = 0; i < data.length; i++) {
          list.add(new User.fromJson(data[i]));
        }
        if (needDb) {
          provider.insert(userName, json.encode(data));
        }
        return new DataResult(list, true);
      } else {
        return new DataResult(null, false);
      }
    }

    if (needDb) {
      List<User> list = await provider.geData(userName);
      if (list == null) {
        return await next();
      }
      DataResult dataResult = new DataResult(list, true, next: next());
      return dataResult;
    }
    return await next();
  }

  /**
   * 获取用户关注列表
   */
  static getFollowedListDao(userName, page, {needDb = false}) async {
    UserFollowedDbProvider provider = new UserFollowedDbProvider();
    next() async {
      String url =
          Address.getUserFollow(userName) + Address.getPageParams("?", page);
      var res = await HttpManager.fetch(url, null, null, null);
      if (res != null && res.result) {
        List<User> list = new List();
        var data = res.data;
        if (data == null || data.length == 0) {
          return new DataResult(null, false);
        }
        for (int i = 0; i < data.length; i++) {
          list.add(new User.fromJson(data[i]));
        }
        if (needDb) {
          provider.insert(userName, json.encode(data));
        }
        return new DataResult(list, true);
      } else {
        return new DataResult(null, false);
      }
    }

    if (needDb) {
      List<User> list = await provider.geData(userName);
      if (list == null) {
        return await next();
      }
      DataResult dataResult = new DataResult(list, true, next: next());
      return dataResult;
    }
    return await next();
  }

  /**
   * 获取用户相关通知
   */
  static getNotifyDao(bool all, bool participating, page) async {
    String tag = (!all && !participating) ? '?' : "&";
    String url = Address.getNotifation(all, participating) +
        Address.getPageParams(tag, page);
    var res = await HttpManager.fetch(url, null, null, null);
    if (res != null && res.result) {
      List<Notification> list = new List();
      var data = res.data;
      if (data == null || data.length == 0) {
        return new DataResult([], true);
      }
      for (int i = 0; i < data.length; i++) {
        list.add(Notification.fromJson(data[i]));
      }
      return new DataResult(list, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /**
   * 设置单个通知已读
   */
  static setNotificationAsReadDao(id) async {
    String url = Address.setNotificationAsRead(id);
    var res = await HttpManager.fetch(
        url, null, null, new Options(method: "PATCH"),
        noTip: true);
    return res;
  }

  /**
   * 设置所有通知已读
   */
  static setAllNotificationAsReadDao() async {
    String url = Address.setAllNotificationAsRead();
    var res = await HttpManager.fetch(url, null, null,
        new Options(method: "PUT", contentType: ContentType.TEXT));
    return new DataResult(res.data, res.result);
  }

  /**
   * 检查用户关注状态
   */
  static checkFollowDao(name) async {
    String url = Address.doFollow(name);
    var res = await HttpManager.fetch(
        url, null, null, new Options(contentType: ContentType.TEXT),
        noTip: true);
    return new DataResult(res.data, res.result);
  }

  /**
   * 关注用户
   */
  static doFollowDao(name, bool followed) async {
    String url = Address.doFollow(name);
    print(followed);
    var res = await HttpManager.fetch(
        url, null, null, new Options(method: !followed ? "PUT" : "DELETE"),
        noTip: true);
    return new DataResult(res.data, res.result);
  }

  //清除token和用户信息
  static clearAll(Store store) async {
    HttpManager.clearAuthorization();
    LocalStorage.remove(Config.USER_INFO);
    store.dispatch(new UpdataUserAction(User.empty()));
  }

  /**
   * 组织成员
   */
  static getMemberDao(userName, page) async {
    String url = Address.getMember(userName) + Address.getPageParams("?", page);
    var res = await HttpManager.fetch(url, null, null, null);
    if (res != null && res.result) {
      List<User> list = new List();
      var data = res.data;
      if (data == null || data.length == 0) {
        return new DataResult(null, false);
      }
      for (int i = 0; i < data.length; i++) {
        list.add(new User.fromJson(data[i]));
      }
      return new DataResult(list, true);
    } else {
      return new DataResult(null, false);
    }
  }
}
