import 'package:github/common/bean/Release.dart';
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
  String body;

  ReleaseItemViewModel();

  ReleaseItemViewModel.fromMap(Release map) {
    if (map.publishedAt != null) {
      actionTime = CommonUtils.getNewsTimeStr(map.publishedAt);
    }
    actionTitle = map.name ?? map.tagName;
    actionTarget = map.targetCommitish;
    actionTargetHtml = map.bodyHtml;
    body = map.body ?? "";
  }
}
