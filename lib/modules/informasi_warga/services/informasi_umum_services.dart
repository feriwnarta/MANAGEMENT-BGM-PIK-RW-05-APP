import 'dart:convert';

import 'package:aplikasi_rw/modules/admin/models/InformasiModel.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

class InformasiUmumServices {
  static Future<List<InformasiUmumModel>> getInformasiUmum() async {
    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    var data = {'id_user': await UserSecureStorage.getIdUser()};

    String url = '${ServerApp.url}src/informasi_umum/informasi_umum.php';

    try {
      var response = await dio.post(url, data: jsonEncode(data));

      if (response.statusCode >= 200 && response.statusCode <= 399) {
        var result = jsonDecode(response.data) as List;

        return result
            .map<InformasiUmumModel>((e) => InformasiUmumModel.fromJson(e))
            .toList();
      }
    } on DioError catch (e) {
      print(e);
    }

    return [];
  }
}
