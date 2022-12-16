import 'dart:convert';

import 'package:aplikasi_rw/model/comment_model.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class CommentService {
  static Future<List<CommentModel>> getDataApi(
      int idStatus, int start, int limit) async {
    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));
    String idUser = await UserSecureStorage.getIdUser();
    String apiUrl = '${ServerApp.url}src/status/comment/comment.php';
    var data = {
      'id_user': idUser,
      'id_status': idStatus,
      'start': start,
      'limit': limit
    };
    // Dio dio = Dio();
    // dio.interceptors.add(RetryOnConnectionChangeInterceptor(
    //   requestRetrier: DioConnectivityRequestRetrier(
    //     dio: dio,
    //     connectivity: Connectivity(),
    //   ),
    // ));
    // ambil data dari api
    var response = await dio.post(apiUrl, data: json.encode(data));
    // ubah jadi json dan casting ke list
    var jsonObject = json.decode(response.data) as List;
    // print(jsonObject);
    return jsonObject
        .map<CommentModel>((item) => CommentModel(
            urlImage: '${ServerApp.url}${item['image_profile']}',
            comment: item['comment'],
            userName: item['username'],
            date: item['time']))
        .toList();
  }
}
