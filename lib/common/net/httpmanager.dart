import 'dart:collection';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:github/common/config/config.dart';
import 'package:github/common/local/local_storage.dart';
import 'package:github/common/net/code.dart';
import 'package:github/common/net/result_data.dart';
/**
 * @Author by whg
 * @Email ghw8908@163.com
 * @Date on 2018/8/21
 *
 * @Description  HttpManager
 *
 * PS: Stay hungry,Stay foolish.
 */

class HttpManager {
  static const CONTENT_TYPE_JSON = "application/json";
  static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";
  static Map optionParams = {
    "timeoutMs": 15000,
    "token": null,
    "authorizationCode": null,
  };

  /**
   * 网络请求
   *  url 请求链接
   *  params 请求参数
   *  header 外加头
   *  text 是否配置text返回
   *  opption  配置
   */
  static fetch(url, params, Map<String, String> header, Options option,
      {noTip = false}) async {
    //没有网络
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return new ResultData(
          Code.errorHandleFunction(Code.NETWORK_ERROR, "", noTip),
          false,
          Code.NETWORK_ERROR);
    }

    Map<String, String> headers = HashMap();

    if (header != null) {
      headers.addAll(header);
    }

    //授权码
    if (optionParams["authorizationCode"] == null) {
      var authorizationCode = await getAuthorization();
      if (authorizationCode != null) {
        optionParams["authorizationCode"] = authorizationCode;
      }
    }

    headers["Authorization"] = optionParams["authorizationCode"];

    if (Config.DEBUG) {
      print(headers["Authorization"]);
    }

    if (option != null) {
      option.headers = headers;
    } else {
      option = new Options(method: "get");
      option.headers = headers;
    }

    Dio dio = new Dio();
    Response response;
    try {
      response = await dio.request(url, data: params, options: option);
    } on DioError catch (e) {
      Response errorResponse;
      if (e.response != null) {
        errorResponse = e.response;
      } else {
        errorResponse = new Response(statusCode: 666);
      }
      if (e.type == DioErrorType.CONNECT_TIMEOUT) {
        errorResponse.statusCode = Code.NETWORK_TIMEOUT;
      }
      if (Config.DEBUG) {
        print('请求异常: ' + e.toString());
        print('请求异常url: ' + url);
      }
      return new ResultData(
          Code.errorHandleFunction(errorResponse.statusCode, e.message, noTip),
          false,
          errorResponse.statusCode);
    }

    if (Config.DEBUG) {
      print('请求url: ' + url);
      print('请求头: ' + option.headers.toString());
      if (params != null) {
        print('请求参数: ' + params.toString());
      }
      if (response != null) {
        print('返回参数: ' + response.toString());
      }
      if (optionParams["authorizationCode"] != null) {
        print('authorizationCode: ' + optionParams["authorizationCode"]);
      }
    }

    try {
      if (option.contentType != null &&
          option.contentType.primaryType == "text") {
        return new ResultData(response.data, true, Code.SUCCESS);
      } else {
        var responseJson = await response.data;
        if (response.statusCode == 201 && responseJson["token"] != null) {
          optionParams["authorizationCode"] = 'token ' + responseJson["token"];
          await LocalStorage.put(
              Config.TOKEN_KEY, optionParams["authorizationCode"]);
        }
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        return new ResultData(response.data, true, Code.SUCCESS,
            headers: response.headers);
      }
    } catch (e) {
      print(e.toString() + url);
      return new ResultData(response.data, false, response.statusCode,
          headers: response.headers);
    }
    return new ResultData(
        Code.errorHandleFunction(response.statusCode, "", noTip),
        false,
        response.statusCode);
  }

  //清理授权
  static void clearAuthorization() {
    optionParams["authorizationCode"] = null;
    LocalStorage.remove(Config.TOKEN_KEY);
  }

  ///获取授权token
  static getAuthorization() async {
    String token = await LocalStorage.get(Config.TOKEN_KEY);
    if (token == null) {
      String basic = await LocalStorage.get(Config.USER_BASIC_CODE);
      if (basic == null) {
        //提示输入账号密码
      } else {
        //通过 basic 去获取token，获取到设置，返回token
        return "Basic $basic";
      }
    } else {
      optionParams["authorizationCode"] = token;
      return token;
    }
  }
}
