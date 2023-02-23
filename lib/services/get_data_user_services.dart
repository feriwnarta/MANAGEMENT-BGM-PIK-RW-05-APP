import 'package:aplikasi_rw/model/user_model.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GetDataUserServices {
  static Future<UserModel> getDataUser(String idUser) async {
    String statusUser = await UserSecureStorage.getStatus();

    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));
    String url = '${ServerApp.url}src/user/user.php';

    var data = {"id_user": idUser, "status_user": statusUser};

    var response = await dio.post(url, data: jsonEncode(data));

    if (response.statusCode >= 200 && response.data.isNotEmpty) {
      var result = jsonDecode(response.data);

      UserModel model = UserModel(
        urlProfile: result['profile_image'],
        username: result['username'],
        cluster: result['cluster'] == null ? '' : result['cluster'],
        email: result['email'] == null ? '' : result['email'],
        houseNumber:
            result['house_number'] == null ? '' : result['house_number'],
        noTelp: result['no_telp'] == null ? '' : result['no_telp'],
        rw: result['rw'] == null ? '' : result['rw'],
        name: result['name'] == null ? '-' : result['name'],
      );
      return model;
    }
  }
}
