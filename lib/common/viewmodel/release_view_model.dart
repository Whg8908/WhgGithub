import 'package:github/common/utils/commonutils.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/9/21
 *
 * @Description
 *
 * PS: Stay hungry,Stay foolish.
 */
class ReleaseItemViewModel {
  String actionTime;
  String actionTitle;
  String actionMode;
  String actionTarget;
  String actionTargetHtml;

  ReleaseItemViewModel();

  ReleaseItemViewModel.fromMap(map) {
    if (map["published_at"] != null) {
      actionTime =
          CommonUtils.getNewsTimeStr(DateTime.parse(map["published_at"]));
    }
    actionTitle = map["name"] ?? map["tag_name"];
    actionTarget = map["target_commitish"];
    actionTargetHtml = map["body_html"];
  }
}
