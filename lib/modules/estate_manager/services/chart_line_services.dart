import 'dart:convert';
import 'package:aplikasi_rw/modules/estate_manager/models/LineChartModel.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:logger/logger.dart';

class ChartLineServices {
  static Future<List<LineChartModel>> getChart(
      {String date, String rangeDate}) async {
    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    // String idUser = await UserSecureStorage.getIdUser();
    String idUser = '1';

    var data = {'id_user': idUser, 'date': date, 'range_date': rangeDate};
    var response = await dio.post(
        '${ServerApp.url}/src/estate_manager/get_data_chart.php',
        data: jsonEncode(data));
    if (response.statusCode == 200) {
      var obj = jsonDecode(response.data) as List;
      var logger = Logger();

      return obj.map((e) {
        LineChartModel model = LineChartModel.fromJson(
            title: e['unit'],
            dataChart: e['category'].map((data) => data['data_chart']).toList(),
            dropdown: e['category']
                .map((data) => {
                      'id_category': data['id_category'],
                      'name_category': data['name_category'],
                    })
                .toList(),
            persentase:
                (e['category'].map((data) => data['persentase']).toList()),
            status: e['category'].map((data) => data['status']).toList(),
            pic: e['category'].map((data) => data['pic']).toList(),
            persentaseSekarang: (e['category']
                .map((data) => data['persentase_sekarang'])
                .toList()));

        logger.i(model.dataChart);

        return model;
      }).toList();
    }
    return [];
  }

  static Future<Map<String, dynamic>> updateChart(
      {String idUser, String rangeDate, String date, String idCategory}) async {
    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    var data = {
      'id_user': idUser,
      'date': date,
      'range_date': rangeDate,
      'id_category': idCategory
    };
    var response = await dio.post(
        '${ServerApp.url}/src/estate_manager/update_chart_line.php',
        data: jsonEncode(data));

    if (response.statusCode == 200) {
      var result = jsonDecode(response.data);
      return result;
    }

    return {};
  }
}
