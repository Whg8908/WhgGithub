import 'package:github/common/bean/CommitFile.dart';

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

  PushCodeItemViewModel.fromMap(CommitFile map) {
    String filename = map.fileName;
    List<String> nameSplit = filename.split("/");
    name = nameSplit[nameSplit.length - 1];
    path = filename;
    patch = map.patch;
    blob_url = map.blobUrl;
  }
}
