import 'dart:convert';

import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:logger/logger.dart';

class GetChartWorkerServices {
  static Future<Map<String, dynamic>> getChart() async {
    String idUser = await UserSecureStorage.getIdUser();
    String status = await UserSecureStorage.getStatus();

    String url = '${ServerApp.url}/src/chart_worker/get_chart_worker.php';

    Dio dio = Dio();
    dio.interceptors.add(
      RetryInterceptor(dio: dio, retries: 100),
    );

    var data = {'id_user': idUser, 'type_worker': status};
    Map<String, dynamic> response = {};

    try {
      var result = await dio.post(url, data: jsonEncode(data));

      if (result.statusCode >= 200 && result.statusCode <= 399) {
        response = jsonDecode(result.data);
        final logger = Logger();
        logger.i(response);

        return response;
      } else {
        print('error server');
      }
    } on Exception catch (e) {
      print(e);
    }

    return response;
  }
}
