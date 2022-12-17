import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:logger/logger.dart';
import '../server-app.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

class HistoryReportModel {
  String statusProcess;
  String time;

  HistoryReportModel({this.statusProcess, this.time});
}

class HistoryReportServices {
  static Future<List<HistoryReportModel>> getHistoryProcess(
      String idReport, String idUser) async {
    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));
    String url = '${ServerApp.url}src/process_report/process_report.php';
    var data = {'id_report': idReport, 'id_user': idUser};
    var response = await dio.post(url, data: jsonEncode(data));
    var obj = jsonDecode(response.data) as List;
    final logger = Logger();
    logger.w(jsonDecode(idReport));
    return obj
        .map((item) => HistoryReportModel(
            statusProcess: item['status_process'],
            time: item['current_time_process']))
        .toList();
  }
}
