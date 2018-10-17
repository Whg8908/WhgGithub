/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/10/16
 *
 * @Description   eventBus  httperrorevent
 *
 * PS: Stay hungry,Stay foolish.
 */

class HttpErrorEvent {
  final int code;

  final String message;

  HttpErrorEvent(this.code, this.message);
}
