import 'package:event_bus/event_bus.dart';
import 'package:github/common/net/http_error_event.dart';

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

  static final EventBus eventBus = new EventBus();

  static errorHandleFunction(code, message, noTip) {
    if (noTip) {
      return message;
    }
    eventBus.fire(new HttpErrorEvent(code, message));
    return message;
  }
}
