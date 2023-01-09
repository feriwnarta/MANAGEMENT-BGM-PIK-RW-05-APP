import 'dart:convert';

import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:logger/logger.dart';

class NotificationServices {
  static Future<String> updateNotification(
      {String status, bool value}) async {
    String idUser = await UserSecureStorage.getIdUser();

    String url =
        '${ServerApp.url}src/settings_notification/update_settings_notification.php';

    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    var data = {'id_user': idUser, 'status': status, 'value': value};

    String result;

    try {
      var response = await dio.post(url, data: jsonEncode(data));

      if (response.statusCode >= 200 && response.statusCode <= 399) {
        result = jsonDecode(response.data);
      }
    } on Exception catch (_) {
      print('error');
    }
    return result;
  }

  static Future<Map<String, dynamic>> getNotification() async {
    String idUser = await UserSecureStorage.getIdUser();
    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    String url =
        '${ServerApp.url}src/settings_notification/get_settings_notification.php';

    var data = {'id_user': idUser};

    Map<String, dynamic> result;

    try {
      var response = await dio.post(url, data: jsonEncode(data));

      if (response.statusCode >= 200 && response.statusCode <= 399) {
        result = jsonDecode(response.data);
        final logger = Logger();
        logger.i(result);
        return result;
      }
    } on Exception catch (e) {
      print(e);
    }
    return result;
  }
}
