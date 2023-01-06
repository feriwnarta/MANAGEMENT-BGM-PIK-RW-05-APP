import 'dart:convert';

import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:logger/logger.dart';

class GetChartWorkerServices {
  static Future<Map<String, dynamic>> getChart() async {
    String url = '${ServerApp.url}src/chart_worker/get_chart_worker.php';
    String idUser = await UserSecureStorage.getIdUser();
    String status = await UserSecureStorage.getStatus();

    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    var data = {'id_user': idUser, 'type_worker': status};
    var request = await dio.post(url, data: jsonEncode(data));
    if (request.statusCode >= 200 && request.statusCode <= 399) {
      var response = jsonDecode(request.data);

      return response;
    }
  }
}
