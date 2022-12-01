import 'package:logger/logger.dart';

import '../server-app.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoryReportModel {
  String statusProcess;
  String time;

  HistoryReportModel({this.statusProcess, this.time});
}

class HistoryReportServices {
  static Future<List<HistoryReportModel>> getHistoryProcess(
      String idReport, String idUser) async {
    String url = '${ServerApp.url}src/process_report/process_report.php';
    var data = {'id_report': idReport, 'id_user': idUser};
    http.Response response = await http.post(Uri.parse(url), body: jsonEncode(data));
    var obj = jsonDecode(response.body) as List;
    final logger = Logger();
    logger.w(jsonDecode(idReport));
    return obj
        .map((item) => HistoryReportModel(
            statusProcess: item['status_process'],
            time: item['current_time_process']))
        .toList();
  }
}
