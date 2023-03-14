import 'dart:convert';

import 'package:aplikasi_rw/modules/admin/models/InformasiModel.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

class AdminServices {
  static Future<List<InformasiModel>> getInformasiWarga() async {
    String idUser = await UserSecureStorage.getIdUser();
    var data = {'id_user': idUser};

    String url = '${ServerApp.url}src/news/news.php';

    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    List<InformasiModel> model;

    try {
      var response = await dio.post(url, data: jsonEncode(data));

      if (response.statusCode >= 200 && response.statusCode <= 399) {
        var result = jsonDecode(response.data) as List;

        model = result
            .map<InformasiModel>((item) => InformasiModel.fromJson(item))
            .toList();

        return model;
      }
    } on DioError catch (e) {
      print(e);
    }

    return [];
  }
}
