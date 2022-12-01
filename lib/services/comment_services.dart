import 'dart:convert';

import 'package:aplikasi_rw/model/comment_model.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:http/http.dart' as http;

class CommentService {
  static Future<List<CommentModel>> getDataApi(
      int idStatus, int start, int limit) async {
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
    var response = await http.post(Uri.parse(apiUrl), body: json.encode(data));
    // ubah jadi json dan casting ke list
    var jsonObject = json.decode(response.body) as List;
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
