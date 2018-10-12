import 'dart:io';

import 'package:dio/dio.dart';
import 'package:github/common/net/code.dart';
import 'package:github/common/net/httpmanager.dart';
import 'package:github/common/net/result_data.dart';
import 'package:github/common/utils/trendingutils.dart';

class GitHubTrending {
  fetchTrending(url) async {
    var res = await HttpManager.fetch(
        url, null, null, new Options(contentType: ContentType.TEXT));
    if (res != null && res.result && res.data != null) {
      return new ResultData(
          TrendingUtil.htmlToRepo(res.data), true, Code.SUCCESS);
    } else {
      return res;
    }
  }
}
