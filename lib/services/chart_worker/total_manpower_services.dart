import 'dart:convert';

import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:logger/logger.dart';

class TotalManPowerModel {
  String idManPower, cluster, total, status;
  TotalManPowerModel({this.idManPower, this.cluster, this.total, this.status});
}

class TotalManPowerServices {
  static Future<List<TotalManPowerModel>> getManPower() async {
    String url = '${ServerApp.url}src/chart_worker/total_manpower.php';
    String idUser = await UserSecureStorage.getIdUser();
    String typeWorker = await UserSecureStorage.getStatus();

    Dio dio = Dio();
    dio.interceptors.add(
      RetryInterceptor(dio: dio, retries: 100),
    );

    var data = {'id_user': idUser, 'type_worker': typeWorker};
    var response = await dio.post(url, data: jsonEncode(data));
    if (response.statusCode >= 200 && response.statusCode <= 399) {
      var result = jsonDecode(response.data) as List;

      final logger = Logger();
      logger.i(result);

      if (result != null)
        return result
            .map<TotalManPowerModel>((e) => TotalManPowerModel(
                cluster: e['cluster'], total: e['total'], status: 'oke'))
            .toList();
    } else {
      return <TotalManPowerModel>[TotalManPowerModel(status: 'http error')];
    }
    return [];
  }
}
