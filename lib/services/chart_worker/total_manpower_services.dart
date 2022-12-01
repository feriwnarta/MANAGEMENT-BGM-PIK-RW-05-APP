import 'dart:convert';

import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:http/http.dart' as http;
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
    var data = {'id_user': idUser, 'type_worker': typeWorker};
    var response = await http.post(Uri.parse(url), body: jsonEncode(data));
    if (response.statusCode >= 200 && response.statusCode <= 399) {
      final logger = Logger();
      var result = jsonDecode(response.body) as List;
      logger.w(result);
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
