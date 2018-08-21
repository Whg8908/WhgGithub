import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:whg_github/common/config/config.dart';
import 'package:whg_github/common/local/local_storage.dart';
import 'package:whg_github/common/net/address.dart';
import 'package:whg_github/common/net/httpmanager.dart';
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
  static void login(String userName, String passWord, callback) async {
    String type = userName + ":" + passWord;
    var bytes = utf8.encode(type);
    var base64Str = base64.encode(bytes);
    if (Config.DEBUG) {
      print("login base64Str =  " + base64Str);
    }
    //存储本地
    await LocalStorage.put(Config.USER_NAME_KEY, userName);
    await LocalStorage.put(Config.PW_KEY, base64Str);

    //请求参数
    Map requestParams = {
      "scopes": ['user', 'repo', 'gist', 'notifications'],
      "note": "admin_script",
      "client_id": NetConfig.CLIENT_ID,
      "client_secret": NetConfig.CLIENT_SECRET
    };

    HttpManager.clearAuthorization();

    print("params = " + json.encode(requestParams));
    var res = await HttpManager.fetch(Address.getAuthorization(),
        json.encode(requestParams), null, Options(method: "post"));

    if (res != null && res.result) {
      await LocalStorage.put(Config.PW_KEY, passWord);
      print("login result " + res.result.toString());
      print(res.data.toString());
    }
    if (callback != null) {
      callback(res);
    }
  }
}
