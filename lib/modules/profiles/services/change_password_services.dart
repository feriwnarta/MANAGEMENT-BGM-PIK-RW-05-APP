import 'dart:convert';

import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

class ChangePasswordServices {
  static Future<String> changePassword({
    String currentPassword,
    String newPassword,
  }) async {
    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    String url = '${ServerApp.url}src/login/change_password.php';

    var data = {
      'id_user': await UserSecureStorage.getIdUser(),
      'current_password': currentPassword,
      'new_password': newPassword
    };

    var response = await dio.post(url, data: jsonEncode(data));

    if (response.statusCode >= 200 && response.statusCode <= 399) {
      var result = jsonDecode(response.data);
      return result;
    } else {
      // error server
    }
    return 'GAGAL';
  }
}
