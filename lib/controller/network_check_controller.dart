import 'dart:io';

import 'package:aplikasi_rw/server-app.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class NetworkCheckController extends GetxController {
  RxBool connectionExist = true.obs;

  void checkConnection() async {
    try {
      final logger = Logger();
      var checkConnection = await InternetAddress.lookup('${ServerApp.ip}');
      logger.i(checkConnection);

      if (checkConnection.isNotEmpty &&
          checkConnection[0].rawAddress.isNotEmpty) {
        var connection = await (Connectivity().checkConnectivity());

        if (connection == ConnectivityResult.none) {
          connectionExist = false.obs;
        }
      } else {
        connectionExist = false.obs;
      }
    } on SocketException catch (_) {
      connectionExist = false.obs;
    }
  }
}
