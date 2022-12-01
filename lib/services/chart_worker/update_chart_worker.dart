import 'dart:convert';

import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class UpdateChartWorkerServices {
  static Future<Map<String, dynamic>> updateChart({String category}) async {
    String url = '${ServerApp.url}src/chart_worker/update_chart_worker.php';
    String idUser = await UserSecureStorage.getIdUser();
    String status = await UserSecureStorage.getStatus();
    Map<String, dynamic> response;
    var data = {'id_user': idUser, 'type_worker': status, 'category': category};
    var request = await http.post(Uri.parse(url), body: jsonEncode(data));
    if (request.statusCode >= 200 && request.statusCode <= 299) {
      response = jsonDecode(request.body);
      final logger = Logger();
      logger.w(response);
      if (response.isNotEmpty) {
        return response;
      }
    }
    return response;
  }
}
