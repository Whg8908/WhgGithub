import 'package:whg_github/common/bean/issue_item_view_model.dart';
import 'package:whg_github/common/net/address.dart';
import 'package:whg_github/common/net/data_result.dart';
import 'package:whg_github/common/net/httpmanager.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/28
 *
 * @Description
 *
 * PS: Stay hungry,Stay foolish.
 */

class IssueDao {
  /**
   * 获取仓库issue
   * @param page
   * @param userName
   * @param repository
   * @param state issue状态
   * @param sort 排序类型 created updated等
   * @param direction 正序或者倒序
   */
  static getRepositoryIssueDao(userName, repository, state,
      {sort, direction, page = 0}) async {
    String url =
        Address.getReposIssue(userName, repository, state, sort, direction) +
            Address.getPageParams("&", page);
    var res = await HttpManager.fetch(
        url,
        null,
        {
          "Accept":
              'application/vnd.github.html,application/vnd.github.VERSION.raw'
        },
        null);
    if (res != null && res.result) {
      List<IssueItemViewModel> list = new List();
      var data = res.data;
      if (data == null || data.length == 0) {
        return new DataResult(null, false);
      }
      for (int i = 0; i < data.length; i++) {
        list.add(IssueItemViewModel.fromMap(data[i]));
      }
      return new DataResult(list, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /**
   * 搜索仓库issue
   * @param q 搜索关键字
   * @param name 用户名
   * @param reposName 仓库名
   * @param page
   * @param state 问题状态，all open closed
   */
  static searchRepositoryIssue(q, name, reposName, state, {page = 1}) async {
    String qu;
    if (state == null || state == 'all') {
      qu = q + "+repo%3A${name}%2F${reposName}";
    } else {
      qu = q + "+repo%3A${name}%2F${reposName}+state%3A${state}";
    }
    String url =
        Address.repositoryIssueSearch(qu) + Address.getPageParams("&", page);
    var res = await HttpManager.fetch(url, null, null, null);
    if (res != null && res.result) {
      List<IssueItemViewModel> list = new List();
      var data = res.data["items"];
      if (data == null || data.length == 0) {
        return new DataResult(null, false);
      }
      for (int i = 0; i < data.length; i++) {
        list.add(IssueItemViewModel.fromMap(data[i]));
      }
      return new DataResult(list, true);
    } else {
      return new DataResult(null, false);
    }
  }
}
