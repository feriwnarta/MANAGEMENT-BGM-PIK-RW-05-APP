import 'dart:convert';

import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:http/http.dart' as http;

class PieChartServices {
  static Future<Map<String, dynamic>> getPie() async {
    String idUser = await UserSecureStorage.getIdUser();
    String typeWorker = await UserSecureStorage.getStatus();

    String url = '${ServerApp.url}src/chart_worker/get_pie_chart_worker.php';
    var data = {'id_user': idUser, 'type_worker': typeWorker};
    Map<String, dynamic> response;

    var request = await http.post(Uri.parse(url), body: jsonEncode(data));
    if (request.statusCode >= 200 && request.statusCode <= 399) {
      response = jsonDecode(request.body);
      return response;
    }

    return response;
  }
}
