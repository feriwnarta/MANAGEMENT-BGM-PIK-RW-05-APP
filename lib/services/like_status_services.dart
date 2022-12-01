import 'package:aplikasi_rw/server-app.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LikeStatusService {
  static Future<String> getLike({String idUser, String idStatus}) async {
    String url = '${ServerApp.url}src/status/like/like.php';
    var data = {'id_user': idUser, 'id_status': idStatus};
    http.Response response =
        await http.post(Uri.parse(url), body: json.encode(data));
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      String message = json.decode(response.body);
      return message;
    }
  }

  static Future<String> addLike({String idUser, String idStatus}) async {
    // Dio dio = Dio();
    // dio.interceptors.add(RetryOnConnectionChangeInterceptor(
    //   requestRetrier: DioConnectivityRequestRetrier(
    //     dio: dio,
    //     connectivity: Connectivity(),
    //   ),
    // ));
    String url = '${ServerApp.url}src/status/like/add_like.php';
    var data = {'id_user': idUser, 'id_status': idStatus};
    var response = await http.post(Uri.parse(url), body: json.encode(data));
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      String message = json.decode(response.body);
      return message;
    }
  }

  static Future<int> isLike({String idUser, String idStatus}) async {
    // Dio dio = Dio();
    // dio.interceptors.add(RetryOnConnectionChangeInterceptor(
    //   requestRetrier: DioConnectivityRequestRetrier(
    //     dio: dio,
    //     connectivity: Connectivity(),
    //   ),
    // ));
    String url = '${ServerApp.url}src/status/like/is_like.php';
    var data = {'id_user': idUser, 'id_status': idStatus};
    var response = await http.post(Uri.parse(url), body: json.encode(data));
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      int message = json.decode(response.body);
      return message;
    }
  }

  static Future<String> deleteLike({String idUser, String idStatus}) async {
    String url = '${ServerApp.url}src/status/like/delete_like.php';
    var data = {'id_user': idUser, 'id_status': idStatus};
    http.Response response =
        await http.post(Uri.parse(url), body: json.encode(data));
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      String message = json.decode(response.body);
      return message;
    }
  }
}
