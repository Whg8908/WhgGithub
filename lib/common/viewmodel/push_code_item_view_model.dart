/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/9/13
 *
 * @Description
 *
 * PS: Stay hungry,Stay foolish.
 */
class PushCodeItemViewModel {
  String path;
  String name;
  String patch;

  String blob_url;

  PushCodeItemViewModel();

  PushCodeItemViewModel.fromMap(map) {
    String filename = map["filename"];
    List<String> nameSplit = filename.split("/");
    name = nameSplit[nameSplit.length - 1];
    path = filename;
    patch = map["patch"];
    blob_url = map["blob_url"];
  }
}
