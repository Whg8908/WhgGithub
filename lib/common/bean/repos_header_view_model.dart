import 'package:whg_github/common/utils/commonutils.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/28
 *
 * @Description
 *
 * PS: Stay hungry,Stay foolish.
 */

class ReposHeaderViewModel {
  String ownerName = '---';
  String ownerPic = "---";
  String repositoryName = "---";
  String repositorySize = "---";
  String repositoryStar = "---";
  String repositoryFork = "---";
  String repositoryWatch = "---";
  String repositoryIssue = "---";
  String repositoryIssueClose = "";
  String repositoryIssueAll = "";
  String repositoryType = "---";
  String repositoryDes = "---";
  String repositoryLastActivity = "";
  String repositoryParentName = "";
  String created_at = "";
  String push_at = "";
  String license = "";
  bool repositoryStared = false;
  bool repositoryForked = false;
  bool repositoryWatched = false;
  bool repositoryIsFork = false;

  ReposHeaderViewModel();

  ReposHeaderViewModel.fromHttpMap(reposName, ownerName, map) {
    this.ownerName = ownerName;
    this.ownerPic = map["owner"]["avatar_url"];
    this.repositoryName = reposName;
    this.repositoryStar =
        map["watchers_count"] != null ? map["watchers_count"].toString() : "";
    this.repositoryFork =
        map["forks_count"] != null ? map["forks_count"].toString() : "";
    this.repositoryWatch = map["subscribers_count"] != null
        ? map["subscribers_count"].toString()
        : "";
    this.repositoryIssue = map["open_issues_count"] != null
        ? map["open_issues_count"].toString()
        : "";
    this.repositoryIssueClose = map["closed_issues_count"] != null
        ? map["closed_issues_count"].toString()
        : "";
    this.repositoryIssueAll = map["all_issues_count"] != null
        ? map["all_issues_count"].toString()
        : "";
    this.repositorySize =
        ((map["size"] / 1024.0)).toString().substring(0, 3) + "M";
    this.repositoryType = map["language"];
    this.repositoryDes = map["description"];
    this.repositoryIsFork = map["fork"];
    this.license = map["license"] != null ? map["license"]["name"] : "";
    this.repositoryParentName =
        map["parent"] != null ? map["parent"]["full_name"] : null;
    this.created_at =
        CommonUtils.getNewsTimeStr(DateTime.parse(map["created_at"]));
    this.push_at = CommonUtils.getNewsTimeStr(DateTime.parse(map["pushed_at"]));
  }
}
