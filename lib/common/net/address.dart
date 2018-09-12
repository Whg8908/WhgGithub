import 'package:whg_github/common/config/config.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/21
 *
 * @Description  接口地址统一封装
 *
 * PS: Stay hungry,Stay foolish.
 */

class Address {
  static const String host = "https://api.github.com/";
  static const String hostWeb = "https://github.com/";
  static const String downloadUrl = 'https://www.pgyer.com/GSYGithubApp';
  static const String graphicHost = 'https://ghchart.rshah.org/';

  ///获取授权  post
  static getAuthorization() {
    return "${host}authorizations";
  }

  ///我的用户信息 GET
  static getMyUserInfo() {
    return "${host}user";
  }

  ///用户信息 get
  static getUserInfo(userName) {
    return "${host}users/$userName";
  }

  ///处理分页参数
  static getPageParams(tab, page, [pageSize = Config.PAGE_SIZE]) {
    if (page != null) {
      if (pageSize != null) {
        return "${tab}page=$page&per_page=$pageSize";
      } else {
        return "${tab}page=$page";
      }
    } else {
      return "";
    }
  }

  ///用户收到的事件信息 get
  static getEventReceived(userName) {
    return "${host}users/$userName/received_events";
  }

  ///趋势 get
  static trending(since, languageType) {
    if (languageType != null) {
      return "${hostWeb}trending/$languageType?since=$since";
    }
    return "${hostWeb}trending?since=$since";
  }

  ///用户相关的事件信息 get
  static getEvent(userName) {
    return "${host}users/$userName/events";
  }

  ///仓库详情 get
  static getReposDetail(reposOwner, reposName) {
    return "${host}repos/$reposOwner/$reposName";
  }

  ///仓库活动 get
  static getReposEvent(reposOwner, reposName) {
    return "${host}networks/$reposOwner/$reposName/events";
  }

  ///关注仓库 put
  static resolveStarRepos(reposOwner, repos) {
    return "${host}user/starred/$reposOwner/$repos";
  }

  ///订阅仓库 put
  static resolveWatcherRepos(reposOwner, repos) {
    return "${host}user/subscriptions/$reposOwner/$repos";
  }

  ///仓库Issue get
  static getReposIssue(reposOwner, reposName, state, sort, direction) {
    state ??= 'all';
    sort ??= 'created';
    direction ??= 'desc';
    return "${host}repos/$reposOwner/$reposName/issues?state=$state&sort=$sort&direction=$direction";
  }

  ///搜索issue
  static repositoryIssueSearch(q) {
    return "${host}search/issues?q=$q";
  }

  ///仓库提交 get
  static getReposCommits(reposOwner, reposName) {
    return "${host}repos/$reposOwner/$reposName/commits";
  }

  ///仓库提交详情 get
  static getReposCommitsInfo(reposOwner, reposName, sha) {
    return "${host}repos/$reposOwner/$reposName/commits/$sha";
  }

  ///仓库路径下的内容 get
  static reposDataDir(reposOwner, repos, path, [branch = 'master']) {
    return "${host}repos/$reposOwner/$repos/contents/$path" +
        ((branch == null) ? "" : ("?ref=" + branch));
  }

  ///create fork post
  static createFork(reposOwner, reposName) {
    return "${host}repos/$reposOwner/$reposName/forks";
  }

  ///仓库Issue评论 get
  static getIssueComment(reposOwner, reposName, issueNumber) {
    return "${host}repos/$reposOwner/$reposName/issues/$issueNumber/comments";
  }

  ///仓库Issue get
  static getIssueInfo(reposOwner, reposName, issueNumber) {
    return "${host}repos/$reposOwner/$reposName/issues/$issueNumber";
  }

  ///增加issue评论 post

  static addIssueComment(reposOwner, reposName, issueNumber) {
    return "${host}repos/$reposOwner/$reposName/issues/$issueNumber/comments";
  }

  ///编辑issue put
  static editIssue(reposOwner, reposName, issueNumber) {
    return "${host}repos/$reposOwner/$reposName/issues/$issueNumber";
  }

  ///锁定issue put
  static lockIssue(reposOwner, reposName, issueNumber) {
    return "${host}repos/$reposOwner/$reposName/issues/$issueNumber/lock";
  }

  ///创建issue post
  static createIssue(reposOwner, reposName) {
    return "${host}repos/$reposOwner/$reposName/issues";
  }

  ///编辑评论 patch, delete
  static editComment(reposOwner, reposName, commentId) {
    return "${host}repos/$reposOwner/$reposName/issues/comments/$commentId";
  }

  ///用户的仓库 get
  static userRepos(userName, sort) {
    sort ??= 'pushed';
    return "${host}users/$userName/repos?sort=$sort";
  }

  ///仓库Fork get
  static getReposForks(reposOwner, reposName) {
    return "${host}repos/$reposOwner/$reposName/forks";
  }

  ///用户的star get
  static userStar(userName, sort) {
    sort ??= 'updated';

    return "${host}users/$userName/starred?sort=$sort";
  }

  ///仓库Watch get
  static getReposWatcher(reposOwner, reposName) {
    return "${host}repos/$reposOwner/$reposName/subscribers";
  }

  ///仓库Star get
  static getReposStar(reposOwner, reposName) {
    return "${host}repos/$reposOwner/$reposName/stargazers";
  }

  ///用户的关注者 get
  static getUserFollower(userName) {
    return "${host}users/$userName/followers";
  }

  ///用户关注 get
  static getUserFollow(userName) {
    return "${host}users/$userName/following";
  }

  ///branch get
  static getbranches(reposOwner, reposName) {
    return "${host}repos/$reposOwner/$reposName/branches";
  }

  ///README 文件地址 get
  static readmeFile(reposNameFullName, curBranch) {
    return host +
        "repos/" +
        reposNameFullName +
        "/" +
        "readme" +
        ((curBranch == null) ? "" : ("?ref=" + curBranch));
  }

  ///通知 get
  static getNotifation(all, participating) {
    if (all == null && participating == null) {
      return "${host}notifications";
    }
    all ??= false;
    participating ??= false;
    return "${host}notifications?all=$all&participating=$participating";
  }

  ///patch
  static setNotificationAsRead(threadId) {
    return "${host}notifications/threads/$threadId";
  }

  ///搜索 get
  static search(q, sort, order, type, page, [pageSize = Config.PAGE_SIZE]) {
    if (type == 'user') {
      return "${host}search/users?q=$q&page=$page&per_page=$pageSize";
    }
    sort ??= "best%20match";
    order ??= "desc";
    page ??= 1;
    pageSize ??= Config.PAGE_SIZE;
    return "${host}search/repositories?q=$q&sort=$sort&order=$order&page=$page&per_page=$pageSize";
  }

  /// get 是否关注
  static doFollow(name) {
    return "${host}user/following/$name";
  }

  ///组织成员
  static getMember(orgs) {
    return "${host}orgs/$orgs/members";
  }

  ///put
  static setAllNotificationAsRead() {
    return "${host}notifications";
  }
}
