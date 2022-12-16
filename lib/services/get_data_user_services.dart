import 'package:aplikasi_rw/model/user_model.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';

class GetDataUserServices {
  static Future<UserModel> getDataUser(String idUser) async {
    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));
    String url = '${ServerApp.url}src/user/user.php';

    var data = {"id_user": idUser};
    var response = await dio.post(url, data: jsonEncode(data));
    if (response.statusCode >= 200 && response.data.isNotEmpty) {
      var result = jsonDecode(response.data);
      print(result['username']);
      UserModel model = UserModel(
          urlProfile: result['profile_image'], username: result['username']);
      return model;
    }
  }
}
