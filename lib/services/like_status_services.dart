import 'package:aplikasi_rw/server-app.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

class LikeStatusService {
  static Future<String> getLike({String idUser, String idStatus}) async {
    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));
    String url = '${ServerApp.url}src/status/like/like.php';
    var data = {'id_user': idUser, 'id_status': idStatus};
    var response = await dio.post(url, data: json.encode(data));
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      String message = json.decode(response.data);
      return message;
    }
    return '';
  }

  static Future<String> addLike({String idUser, String idStatus}) async {
    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));
    String url = '${ServerApp.url}src/status/like/add_like.php';
    var data = {'id_user': idUser, 'id_status': idStatus};
    var response = await dio.post(url, data: json.encode(data));
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      String message = json.decode(response.data);
      return message;
    }
    return '';
  }

  static Future<int> isLike({String idUser, String idStatus}) async {
    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));
    String url = '${ServerApp.url}src/status/like/is_like.php';
    var data = {'id_user': idUser, 'id_status': idStatus};
    var response = await dio.post(url, data: json.encode(data));
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      int message = json.decode(response.data);
      return message;
    }
    return 0;
  }

  static Future<String> deleteLike({String idUser, String idStatus}) async {
    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));
    String url = '${ServerApp.url}src/status/like/delete_like.php';
    var data = {'id_user': idUser, 'id_status': idStatus};
    var response = await dio.post(url, data: json.encode(data));
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      String message = json.decode(response.data);
      return message;
    }
    return '';
  }
}
