import 'package:fluttertoast/fluttertoast.dart';
import 'package:whg_github/common/style/whg_style.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/21
 *
 * @Description  错误编码
 *
 * PS: Stay hungry,Stay foolish.
 */

class Code {
  //网络错误
  static const int NETWORK_ERROR = 1;

  //网络超时
  static const NETWORK_TIMEOUT = 2;

  //网络返回数据格式化一次
  static const NETWORK_JSON_EXCEPTION = 3;

  static const SUCCESS = 200;

  static errorHandleFunction(code, message) {
    switch (code) {
      case NETWORK_ERROR:
        Fluttertoast.showToast(msg: WhgStrings.network_error);
        return WhgStrings.network_error;
      case 401:
        Fluttertoast.showToast(msg: WhgStrings.network_error_401);
        return WhgStrings.network_error_401; //401 Unauthorized
      case 403:
        Fluttertoast.showToast(msg: WhgStrings.network_error_403);
        return WhgStrings.network_error_403;
      case 404:
        Fluttertoast.showToast(msg: WhgStrings.network_error_404);
        return WhgStrings.network_error_404;
      case NETWORK_TIMEOUT:
        //超时
        Fluttertoast.showToast(msg: WhgStrings.network_error_timeout);
        return WhgStrings.network_error_timeout;
      default:
        Fluttertoast.showToast(
            msg: WhgStrings.network_error_unknown + " " + message);
        return WhgStrings.network_error_unknown;
    }
  }
}
