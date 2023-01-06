import 'dart:convert';

import 'package:aplikasi_rw/server-app.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:logger/logger.dart';

class CheckAccessOtp {
  static Future<Map<String, dynamic>> checkAccess({String username}) async {
    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    String url =
        '${ServerApp.url}src/login/credentials/check_access_before_login.php';

    var data = {'username': username};

    Map<String, dynamic> result = {};

    var response = await dio.post(url, data: jsonEncode(data));

    if (response.statusCode >= 200 && response.statusCode <= 399) {
      result = jsonDecode(response.data);
      return result;
    } else {
      final logger = Logger();
      logger.i('server gagal');
      return result;
    }
  }
}
