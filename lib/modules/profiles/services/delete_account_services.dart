import 'dart:convert';

import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

class DeleteAccount {
  static Future<String> delete() async {
    String idUser = await UserSecureStorage.getIdUser();
    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));
    String url = '${ServerApp.url}src/profile/delete_account.php';
    var data = {'id_user': idUser};
    var response = await dio.post(url, data: json.encode(data));
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      String message = json.decode(response.data);
      return message;
    }
    return '';
  }
}
