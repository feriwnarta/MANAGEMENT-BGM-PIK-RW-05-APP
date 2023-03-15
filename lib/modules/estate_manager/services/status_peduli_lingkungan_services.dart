import 'dart:convert';

import 'package:aplikasi_rw/modules/estate_manager/models/card_status_peduli_em_model.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';

class RadioStatusPeduli {
  String value;
  String title;
  String groupValue;

  RadioStatusPeduli({this.value, this.groupValue, this.title});
}

class StatusPeduliEmServices {
  static Future<List<RadioStatusPeduli>> listMasterCategory() async {
    String idUser = await UserSecureStorage.getIdUser();

    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    String url = '${ServerApp.url}src/estate_manager/get_master_category.php';

    var response = await dio.post(url, data: jsonEncode({'id_user': idUser}));
    List<RadioStatusPeduli> rs;

    if (response.statusCode >= 200 && response.statusCode <= 399) {
      var result = jsonDecode(response.data) as List;

      final logger = Logger();
      logger.i(result);

      rs = result
          .map<RadioStatusPeduli>(
            (e) => RadioStatusPeduli(
              groupValue: e['id_master_category'],
              title: e['unit'],
              value: e['id_master_category'],
            ),
          )
          .toList();

      return rs;
    }
    return rs;
  }

  static Future<List<StatusPeduliEmModel>> getListReport(
      {String status, int start, int limit}) async {
    String idUser = await UserSecureStorage.getIdUser();

    var data = {
      'id_user': idUser,
      'status': status,
      'start': start,
      'limit': limit
    };

    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    String url = '${ServerApp.url}src/estate_manager/get_list_report_em.php';

    try {
      var response = await dio.post(url, data: jsonEncode(data));

      // logger.e(response.data);

      List<StatusPeduliEmModel> model;

      if (response.statusCode >= 200 && response.statusCode <= 399) {
        var result = jsonDecode(response.data) as List;

        model = result.map<StatusPeduliEmModel>((model) {
          var cordinator = model['pic'] as List;

          List<Map<String, dynamic>> listCordinator;
          if (cordinator != null) {
            listCordinator =
                cordinator.map<Map<String, dynamic>>((e) => e).toList();
          } else {
            listCordinator = [];
          }

          return StatusPeduliEmModel(
            address: model['address'],
            image: model['url_image'],
            lat: model['latitude'],
            long: model['longitude'],
            status: (model['status_eskalasi'] == ''
                ? model['status']
                : model['status_eskalasi']),
            title: model['category'],
            idReport: model['id_report'],
            waktu: model['waktu'],
            cordinatorPhone: listCordinator,

            // image:
          );
        }).toList();
      }

      return model;
    } on Exception {
      EasyLoading.showError(
          'Ada kesalahan saat mengambil laporan terbaru, silahakan hubungi admin');
    }
    return [];
  }

  static Future<Map<String, dynamic>> getDataReportCard(
      {String idReport}) async {
    String url = '${ServerApp.url}src/estate_manager/get_data_report_card.php';

    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    var data = {'id_report': idReport};

    Map<String, dynamic> result = {};

    try {
      var response = await dio.post(url, data: jsonEncode(data));

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        result = jsonDecode(response.data);

        return result;
      } else {}
    } on DioError catch (e) {
      print(e);
    }

    return result;
  }
}
