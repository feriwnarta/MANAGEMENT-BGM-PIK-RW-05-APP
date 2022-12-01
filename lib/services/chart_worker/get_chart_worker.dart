import 'dart:convert';

import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class GetChartWorkerServices {
  static Future<Map<String, dynamic>> getChart() async {
    String url = '${ServerApp.url}src/chart_worker/get_chart_worker.php';
    String idUser = await UserSecureStorage.getIdUser();
    String status = await UserSecureStorage.getStatus();

    var data = {'id_user': idUser, 'type_worker': status};
    var request = await http.post(Uri.parse(url), body: jsonEncode(data));
    if (request.statusCode >= 200 && request.statusCode <= 399) {
      var response = jsonDecode(request.body);
      final logger = Logger();
      logger.w(response);
      return response;
    }
  }
}
