import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:logger/logger.dart';

import '../../../server-app.dart';

class ChartPieModel {
  String title, total;

  List<Map<String, dynamic>> dataPie;

  ChartPieModel({this.title, this.total, this.dataPie});
}

class ChartPieServices {
  static Future<List<ChartPieModel>> getChartPie(
      {String date, String rangeDate}) async {
    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    // String idUser = await UserSecureStorage.getIdUser();
    String idUser = '1';

    var data = {'id_user': idUser, 'date': date, 'range_date': rangeDate};
    var response = await dio.post(
        '${ServerApp.url}/src/estate_manager/get_pie_chart.php',
        data: jsonEncode(data));

    final logger = Logger();
    if (response.statusCode == 200) {
      var obj = jsonDecode(response.data) as List;
      return obj.map<ChartPieModel>((e) {
        // logger.e(e['data_pie']);

        List<dynamic> dataPie = e['data_pie'] as List;

        List<Map<String, dynamic>> data =
            dataPie.map<Map<String, dynamic>>((e) => e).toList();

        return ChartPieModel(
          title: e['title'],
          total: e['total'],
          dataPie: data,
        );
      }).toList();
    }
  }
}
