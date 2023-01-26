import 'dart:convert';

import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:logger/logger.dart';

class UpdateChartWorkerServices {
  static Future<List<Map<String, dynamic>>> updateChart(
      {String category}) async {
    String url = '${ServerApp.url}src/chart_worker/update_chart_worker.php';
    String idUser = await UserSecureStorage.getIdUser();
    String status = await UserSecureStorage.getStatus();

    Dio dio = Dio();
    dio.interceptors.add(
      RetryInterceptor(dio: dio, retries: 100),
    );

    List<Map<String, dynamic>> response = [];
    var data = {'id_user': idUser, 'type_worker': status, 'category': category};

    try {
      var request = await dio.post(url, data: jsonEncode(data));
      if (request.statusCode >= 200 && request.statusCode <= 299) {
        var result = jsonDecode(request.data) as List;
        response = result.map<Map<String, dynamic>>((e) => e).toList();
        final logger = Logger();
        logger.w(response);

        if (response.isNotEmpty) {
          return response;
        }
      }
    } on Exception catch (e) {
      print(e);
    }

    return response;
  }
}
