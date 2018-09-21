/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/29
 *
 * @Description
 *
 * PS: Stay hungry,Stay foolish.
 */

class FileItemViewModel {
  String type;
  String name;

  FileItemViewModel();

  FileItemViewModel.fromMap(map) {
    name = map["name"];
    type = map["type"];
  }
}