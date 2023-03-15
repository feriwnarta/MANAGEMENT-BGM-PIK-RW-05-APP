import 'package:aplikasi_rw/server-app.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

class CountCommentServices {
  static Future<String> getCountComment(
      {String idUser, String idStatus}) async {
    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));
    String url = '${ServerApp.url}/src/status/comment/count_comment.php';
    var data = {'id_user': idUser, 'id_status': idStatus};
    var response = await dio.post(url, data: json.encode(data));
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      String message = json.decode(response.data);
      if (message != null) {
        return message;
      }
    }
    return '';
  }
}
