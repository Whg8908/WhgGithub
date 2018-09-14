import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:whg_github/common/bean/event_view_model.dart';
import 'package:whg_github/common/bean/file_item_view_model.dart';
import 'package:whg_github/common/bean/push_code_item_view_model.dart';
import 'package:whg_github/common/bean/push_header_view_model.dart';
import 'package:whg_github/common/bean/repos_header_view_model.dart';
import 'package:whg_github/common/bean/repos_view_model.dart';
import 'package:whg_github/common/bean/trending_repo_model.dart';
import 'package:whg_github/common/bean/user_item_view_model.dart';
import 'package:whg_github/common/net/address.dart';
import 'package:whg_github/common/net/data_result.dart';
import 'package:whg_github/common/net/httpmanager.dart';
import 'package:whg_github/common/net/trend/github_trend.dart';

/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/22
 *
 * @Description ReposDao
 *
 * PS: Stay hungry,Stay foolish.
 */

class ReposDao {
  /**
   * 趋势数据
   * @param page 分页，趋势数据其实没有分页
   * @param since 数据时长， 本日，本周，本月
   * @param languageType 语言
   */
  static getTrendDao({since = "daily", languageType, page = 0}) async {
//    String localLanguage = (languageType != null) ? languageType : "*";
    String url = Address.trending(since, languageType);

    var res = await GitHubTrending.fetchTrending(url);
    if (res != null && res.result && res.data.length > 0) {
      List<ReposViewModel> list = new List();
      var data = res.data;
      if (data == null || data.length == 0) {
        return new DataResult(null, false);
      }
      for (int i = 0; i < data.length; i++) {
        TrendingRepoModel model = data[i];
        ReposViewModel reposViewModel = new ReposViewModel();
        reposViewModel.ownerName = model.name;
        reposViewModel.ownerPic = model.contributors[0];
        reposViewModel.repositoryName = model.reposName;
        reposViewModel.repositoryStar = model.starCount;
        reposViewModel.repositoryFork = model.forkCount;
        reposViewModel.repositoryWatch = model.meta;
        reposViewModel.repositoryType = model.language;
        reposViewModel.repositoryDes = model.description;
        list.add(reposViewModel);
      }
      return new DataResult(list, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /**
   * 仓库的详情数据
   */
  static getRepositoryDetailDao(userName, reposName, branch) async {
    String url = Address.getReposDetail(userName, reposName) + "?ref=" + branch;
    var res = await HttpManager.fetch(url, null,
        {"Accept": 'application/vnd.github.mercy-preview+json'}, null);
    if (res != null && res.result && res.data.length > 0) {
      List<ReposHeaderViewModel> list = new List();
      var data = res.data;
      if (data == null || data.length == 0) {
        return new DataResult(null, false);
      }
      return new DataResult(
          ReposHeaderViewModel.fromHttpMap(reposName, userName, data), true);
    } else {
      return new DataResult(null, false);
    }
  }

  /**
   * 仓库活动事件
   */
  static getRepositoryEventDao(userName, reposName,
      {page = 0, branch = "master"}) async {
    String url = Address.getReposEvent(userName, reposName) +
        Address.getPageParams("?", page);

    var res = await HttpManager.fetch(url, null, null, null);
    if (res != null && res.result) {
      List<EventViewModel> list = new List();
      var data = res.data;
      if (data == null || data.length == 0) {
        return new DataResult(null, false);
      }
      for (int i = 0; i < data.length; i++) {
        list.add(EventViewModel.fromEventMap(data[i]));
      }
      return new DataResult(list, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /**
   * 获取用户对当前仓库的star、watcher状态
   */
  static getRepositoryStatusDao(userName, reposName) async {
    String urls = Address.resolveStarRepos(userName, reposName);
    String urlw = Address.resolveWatcherRepos(userName, reposName);
    var resS = await HttpManager.fetch(
        urls, null, null, new Options(contentType: ContentType.TEXT),
        noTip: true);
    var resW = await HttpManager.fetch(
        urlw, null, null, new Options(contentType: ContentType.TEXT),
        noTip: true);
    var data = {"star": resS.result, "watch": resW.result};
    return new DataResult(data, true);
  }

  /**
   * 获取仓库的提交列表
   */
  static getReposCommitsDao(userName, reposName,
      {page = 0, branch = "master"}) async {
    String url = Address.getReposCommits(userName, reposName) +
        Address.getPageParams("?", page) +
        "&sha=" +
        branch;

    var res = await HttpManager.fetch(url, null, null, null);
    if (res != null && res.result) {
      List<EventViewModel> list = new List();
      var data = res.data;
      if (data == null || data.length == 0) {
        return new DataResult(null, false);
      }
      for (int i = 0; i < data.length; i++) {
        list.add(EventViewModel.fromCommitMap(data[i]));
      }
      return new DataResult(list, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /***
   * 获取仓库的文件列表
   */
  static getReposFileDirDao(userName, reposName,
      {path = '', branch, text = false}) async {
    String url = Address.reposDataDir(userName, reposName, path, branch);
    var res = await HttpManager.fetch(
      url,
      null,
      text
          ? {"Accept": 'application/vnd.github.VERSION.raw'}
          : {"Accept": 'application/vnd.github.html'},
      new Options(contentType: text ? ContentType.TEXT : ContentType.JSON),
    );
    if (res != null && res.result) {
      if (text) {
        return new DataResult(res.data, true);
      }
      List<FileItemViewModel> list = new List();
      var data = res.data;
      if (data == null || data.length == 0) {
        return new DataResult(null, false);
      }
      List<FileItemViewModel> dirs = [];
      List<FileItemViewModel> files = [];
      for (int i = 0; i < data.length; i++) {
        FileItemViewModel file = FileItemViewModel.fromMap(data[i]);
        if (file.type == 'file') {
          files.add(file);
        } else {
          dirs.add(file);
        }
      }
      list.addAll(dirs);
      list.addAll(files);
      return new DataResult(list, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /**
   * star仓库
   */
  static Future<DataResult> doRepositoryStarDao(
      userName, reposName, star) async {
    String url = Address.resolveStarRepos(userName, reposName);
    var res = await HttpManager.fetch(
        url,
        null,
        null,
        new Options(
            method: !star ? 'PUT' : 'DELETE', contentType: ContentType.TEXT));
    return Future<DataResult>(() {
      return new DataResult(null, res.result);
    });
  }

  /**
   * watcher仓库
   */
  static doRepositoryWatchDao(userName, reposName, watch) async {
    String url = Address.resolveWatcherRepos(userName, reposName);
    var res = await HttpManager.fetch(
        url,
        null,
        null,
        new Options(
            method: !watch ? 'PUT' : 'DELETE', contentType: ContentType.TEXT));
    return new DataResult(null, res.result);
  }

  /**
   * 创建仓库的fork分支
   */
  static createForkDao(userName, reposName) async {
    String url = Address.createFork(userName, reposName);
    var res =
        await HttpManager.fetch(url, null, null, new Options(method: "POST"));
    return new DataResult(null, res.result);
  }

  /**
   * 获取当前仓库所有订阅用户
   */
  static getRepositoryWatcherDao(userName, reposName, page) async {
    String url = Address.getReposWatcher(userName, reposName) +
        Address.getPageParams("?", page);
    var res = await HttpManager.fetch(url, null, null, null);
    if (res != null && res.result) {
      List<UserItemViewModel> list = new List();
      var data = res.data;
      if (data == null || data.length == 0) {
        return new DataResult(null, false);
      }
      for (int i = 0; i < data.length; i++) {
        list.add(
            new UserItemViewModel(data[i]['login'], data[i]["avatar_url"]));
      }
      return new DataResult(list, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /**
   * 获取当前仓库所有star用户
   */
  static getRepositoryStarDao(userName, reposName, page) async {
    String url = Address.getReposStar(userName, reposName) +
        Address.getPageParams("?", page);
    var res = await HttpManager.fetch(url, null, null, null);
    if (res != null && res.result) {
      List<UserItemViewModel> list = new List();
      var data = res.data;
      if (data == null || data.length == 0) {
        return new DataResult(null, false);
      }
      for (int i = 0; i < data.length; i++) {
        list.add(
            new UserItemViewModel(data[i]['login'], data[i]["avatar_url"]));
      }
      return new DataResult(list, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /**
   * 获取仓库的fork分支
   */
  static getRepositoryForksDao(userName, reposName, page) async {
    String url = Address.getReposForks(userName, reposName) +
        Address.getPageParams("?", page);
    var res = await HttpManager.fetch(url, null, null, null);
    if (res != null && res.result && res.data.length > 0) {
      List<ReposViewModel> list = new List();
      var dataList = res.data;
      if (dataList == null || dataList.length == 0) {
        return new DataResult(null, false);
      }
      for (int i = 0; i < dataList.length; i++) {
        var data = dataList[i];
        list.add(ReposViewModel.fromMap(data));
      }
      return new DataResult(list, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /**
   * 获取当前仓库所有star用户
   */
  static getStarRepositoryDao(userName, page, sort) async {
    String url =
        Address.userStar(userName, sort) + Address.getPageParams("&", page);
    var res = await HttpManager.fetch(url, null, null, null);
    if (res != null && res.result && res.data.length > 0) {
      List<ReposViewModel> list = new List();
      var dataList = res.data;
      if (dataList == null || dataList.length == 0) {
        return new DataResult(null, false);
      }
      for (int i = 0; i < dataList.length; i++) {
        var data = dataList[i];
        list.add(ReposViewModel.fromMap(data));
      }
      return new DataResult(list, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /**
   * 用户的仓库
   */
  static getUserRepositoryDao(userName, page, sort) async {
    String url =
        Address.userRepos(userName, sort) + Address.getPageParams("&", page);
    var res = await HttpManager.fetch(url, null, null, null);
    if (res != null && res.result && res.data.length > 0) {
      List<ReposViewModel> list = new List();
      var dataList = res.data;
      if (dataList == null || dataList.length == 0) {
        return new DataResult(null, false);
      }
      for (int i = 0; i < dataList.length; i++) {
        var data = dataList[i];
        list.add(ReposViewModel.fromMap(data));
      }
      return new DataResult(list, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /**
   * 获取当前仓库所有分支
   */
  static getBranchesDao(userName, reposName) async {
    String url = Address.getbranches(userName, reposName);
    var res = await HttpManager.fetch(url, null, null, null);
    if (res != null && res.result && res.data.length > 0) {
      List<String> list = new List();
      var dataList = res.data;
      if (dataList == null || dataList.length == 0) {
        return new DataResult(null, false);
      }
      for (int i = 0; i < dataList.length; i++) {
        var data = dataList[i];
        list.add(data['name']);
      }
      return new DataResult(list, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /**
   * 用户的前100仓库
   */
  static getUserRepository100StatusDao(userName) async {
    String url = Address.userRepos(userName, 'pushed') + "&page=1&per_page=100";
    var res = await HttpManager.fetch(url, null, null, null);
    if (res != null && res.result && res.data.length > 0) {
      int stared = 0;
      for (int i = 0; i < res.data.length; i++) {
        var data = res.data[i];
        stared += data["watchers_count"];
      }
      return new DataResult(stared, true);
    }
    return new DataResult(null, false);
  }

  /**
   * 详情的remde数据
   */
  static getRepositoryDetailReadmeDao(userName, reposName, branch) async {
    String url = Address.readmeFile(userName + '/' + reposName, branch);
    var res = await HttpManager.fetch(
        url,
        null,
        {"Accept": 'application/vnd.github.VERSION.raw'},
        new Options(contentType: ContentType.TEXT));
    if (res != null && res.result) {
      return new DataResult(res.data, true);
    }
    return new DataResult(null, false);
  }

  /**
   * 搜索仓库
   * @param q 搜索关键字
   * @param sort 分类排序，beat match、most star等
   * @param order 倒序或者正序
   * @param type 搜索类型，人或者仓库 null \ 'user',
   * @param page
   * @param pageSize
   */
  static searchRepositoryDao(
      q, language, sort, order, type, page, pageSize) async {
    if (language != null) {
      q = q + "%2Blanguage%3A$language";
    }
    String url = Address.search(q, sort, order, type, page, pageSize);
    var res = await HttpManager.fetch(url, null, null, null);
    if (type == null) {
      if (res != null && res.result && res.data["items"] != null) {
        List<ReposViewModel> list = new List();
        var dataList = res.data["items"];
        if (dataList == null || dataList.length == 0) {
          return new DataResult(null, false);
        }
        for (int i = 0; i < dataList.length; i++) {
          var data = dataList[i];
          list.add(ReposViewModel.fromMap(data));
        }
        return new DataResult(list, true);
      } else {
        return new DataResult(null, false);
      }
    } else {
      if (res != null && res.result && res.data["items"] != null) {
        List<UserItemViewModel> list = new List();
        var data = res.data["items"];
        if (data == null || data.length == 0) {
          return new DataResult(null, false);
        }
        for (int i = 0; i < data.length; i++) {
          list.add(
              new UserItemViewModel(data[i]['login'], data[i]["avatar_url"]));
        }
        return new DataResult(list, true);
      } else {
        return new DataResult(null, false);
      }
    }
  }

  /**
   * 获取仓库的单个提交详情
   */
  static getReposCommitsInfoDao(userName, reposName, sha) async {
    String url = Address.getReposCommitsInfo(userName, reposName, sha);
    var res = await HttpManager.fetch(url, null, null, null);
    if (res != null && res.result) {
      PushHeaderViewModel pushHeaderViewModel =
          PushHeaderViewModel.forMap(res.data);
      var files = res.data["files"];
      for (int i = 0; i < files.length; i++) {
        pushHeaderViewModel.files.add(PushCodeItemViewModel.fromMap(files[i]));
      }
      return new DataResult(pushHeaderViewModel, true);
    } else {
      return new DataResult(null, false);
    }
  }
}
