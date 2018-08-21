import 'package:shared_preferences/shared_preferences.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/21
 *
 * @Description SharePreferences 本地存储
 *
 * PS: Stay hungry,Stay foolish.
 */

class LocalStorage {
  /**
   * 存储
   */
  static put(String key, value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(key, value);
  }

  /**
   * 获取
   */
  static get(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.get(key);
  }

  /**
   * 删除
   */
  static remove(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove(key);
  }
}
