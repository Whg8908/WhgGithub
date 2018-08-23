import 'package:whg_github/common/config/config.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/21
 *
 * @Description  接口地址统一封装
 *
 * PS: Stay hungry,Stay foolish.
 */

class Address {
  static const String host = "https://api.github.com/";
  static const String hostWeb = "https://github.com/";
  static const String downloadUrl = 'https://www.pgyer.com/GSYGithubApp';
  static const String graphicHost = 'https://ghchart.rshah.org/';

  ///获取授权  post
  static getAuthorization() {
    return "${host}authorizations";
  }

  ///我的用户信息 GET
  static getMyUserInfo() {
    return "${host}user";
  }

  ///用户信息 get
  static getUserInfo(userName) {
    return "${host}users/$userName";
  }

  ///处理分页参数
  static getPageParams(tab, page, [pageSize = Config.PAGE_SIZE]) {
    if (page != null) {
      if (pageSize != null) {
        return "${tab}page=$page&per_page=$pageSize";
      } else {
        return "${tab}page=$page";
      }
    } else {
      return "";
    }
  }

  ///用户收到的事件信息 get
  static getEventReceived(userName) {
    return "${host}users/$userName/received_events";
  }

  ///趋势 get
  static trending(since, languageType) {
    if (languageType == null) {
      return "${hostWeb}trending/$languageType?since=$since";
    }
    return "${hostWeb}trending?since=$since";
  }
}
