import 'dart:io';

import 'package:dio/dio.dart';
import 'package:github/common/bean/issue_item_view_model.dart';
import 'package:github/common/net/address.dart';
import 'package:github/common/net/data_result.dart';
import 'package:github/common/net/httpmanager.dart';
import 'package:github/ui/page/issue_header_view_model.dart';

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

  /**
   * issue的详请
   */
  static getIssueInfoDao(userName, repository, number) async {
    String url = Address.getIssueInfo(userName, repository, number);
    //{"Accept": 'application/vnd.github.html,application/vnd.github.VERSION.raw'}
    var res = await HttpManager.fetch(url, null, null, null);
    if (res != null && res.result) {
      return new DataResult(IssueHeaderViewModel.fromMap(res.data), true);
    } else {
      return new DataResult(null, false);
    }
  }

  /**
   * issue的详请列表
   */
  static getIssueCommentDao(userName, repository, number, {page: 0}) async {
    String url = Address.getIssueComment(userName, repository, number) +
        Address.getPageParams("?", page);
    //{"Accept": 'application/vnd.github.html,application/vnd.github.VERSION.raw'}
    var res = await HttpManager.fetch(url, null, null, null);
    if (res != null && res.result) {
      List<IssueItemViewModel> list = new List();
      var data = res.data;
      if (data == null || data.length == 0) {
        return new DataResult(null, false);
      }
      for (int i = 0; i < data.length; i++) {
        list.add(IssueItemViewModel.fromMap(data[i], needTitle: false));
      }
      return new DataResult(list, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /**
   * 增加issue的回复
   */
  static addIssueCommentDao(userName, repository, number, comment) async {
    String url = Address.addIssueComment(userName, repository, number);
    var res = await HttpManager.fetch(
        url,
        {"body": comment},
        {"Accept": 'application/vnd.github.VERSION.full+json'},
        new Options(method: 'POST'));
    if (res != null && res.result) {
      return new DataResult(res.data, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /**
   * 编辑issue
   */
  static editIssueDao(userName, repository, number, issue) async {
    String url = Address.editIssue(userName, repository, number);
    var res = await HttpManager.fetch(
        url,
        issue,
        {"Accept": 'application/vnd.github.VERSION.full+json'},
        new Options(method: 'PATCH'));
    if (res != null && res.result) {
      return new DataResult(res.data, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /**
   * 锁定issue
   */
  static lockIssueDao(userName, repository, number, locked) async {
    String url = Address.lockIssue(userName, repository, number);
    var res = await HttpManager.fetch(
        url,
        null,
        {"Accept": 'application/vnd.github.VERSION.full+json'},
        new Options(
            method: locked ? "DELETE" : 'PUT', contentType: ContentType.TEXT),
        noTip: true);
    if (res != null && res.result) {
      return new DataResult(res.data, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /**
   * 创建issue
   */
  static createIssueDao(userName, repository, issue) async {
    String url = Address.createIssue(userName, repository);
    var res = await HttpManager.fetch(
        url,
        issue,
        {"Accept": 'application/vnd.github.VERSION.full+json'},
        new Options(method: 'POST'));
    if (res != null && res.result) {
      return new DataResult(res.data, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /**
   * 编辑issue回复
   */
  static editCommentDao(
      userName, repository, number, commentId, comment) async {
    String url = Address.editComment(userName, repository, commentId);
    var res = await HttpManager.fetch(
        url,
        comment,
        {"Accept": 'application/vnd.github.VERSION.full+json'},
        new Options(method: 'PATCH'));
    if (res != null && res.result) {
      return new DataResult(res.data, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /**
   * 删除issue回复
   */
  static deleteCommentDao(userName, repository, number, commentId) async {
    String url = Address.editComment(userName, repository, commentId);
    var res = await HttpManager.fetch(url, null, null,
        new Options(method: 'DELETE', contentType: ContentType.TEXT),
        noTip: true);
    if (res != null && res.result) {
      return new DataResult(res.data, true);
    } else {
      return new DataResult(null, false);
    }
  }
}
