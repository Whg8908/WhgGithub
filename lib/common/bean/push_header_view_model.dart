import 'package:whg_github/common/bean/push_code_item_view_model.dart';
import 'package:whg_github/common/utils/commonutils.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/9/13
 *
 * @Description
 *
 * PS: Stay hungry,Stay foolish.
 */
class PushHeaderViewModel {
  String actionUser = "---";
  String actionUserPic = "---";
  String pushDes = "---";
  String pushTime = "---";
  String editCount = "---";
  String addCount = "---";
  String deleteCount = "---";
  List<PushCodeItemViewModel> files = new List();
  PushHeaderViewModel();

  PushHeaderViewModel.forMap(pushMap) {
    String name = "---";
    String pic = "---";
    if (pushMap["committer"] != null) {
      name = pushMap["committer"]["login"];
    } else if (pushMap["commit"] != null &&
        pushMap["commit"]["author"] != null) {
      name = pushMap["commit"]["author"]["name"];
    }
    if (pushMap["committer"] != null &&
        pushMap["committer"]["avatar_url"] != null) {
      pic = pushMap["committer"]["avatar_url"];
    }
    actionUser = name;
    actionUserPic = pic;
    pushDes = "Push at " + pushMap["commit"]["message"];
    pushTime = CommonUtils.getNewsTimeStr(
        DateTime.parse(pushMap["commit"]["committer"]["date"]));
    ;
    editCount = pushMap["files"].length.toString() + "";
    addCount = pushMap["stats"]["additions"].toString() + "";
    deleteCount = pushMap["stats"]["deletions"].toString() + "";
  }
}
