import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:aplikasi_rw/server-app.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class CountDownController extends GetxController {
  RxInt count = 60.obs;
  Timer timer;

  void countDown({String iplOrEmail}) async {
    final logger = Logger();
    count = 60.obs;
    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      logger.e(count.value);
      if (count.value != 0) {
        count.value--;
        // update();
      } else {
        timer.cancel();
        await expiredOtp(iplOrEmail);
      }
    });
  }

  void reset() {
    timer.cancel();
    this.count = 60.obs;
  }

  Future<void> expiredOtp(String iplOrEmail) async {
    String url = '${ServerApp.url}src/login/otp_expired.php';
    // Uri uri = Uri()
    var body = {'iplOrEmail': iplOrEmail};
    try {
      var response = await http.post(Uri.parse(url), body: jsonEncode(body));
      if (response.statusCode >= 200 && response.statusCode <= 399) {
        String message = jsonDecode(response.body);
        final logger = Logger();
        logger.d(message);

        if (message == 'success') {
        } else {
          // no expired
        }
      }
    } on SocketException {
      Get.snackbar('Message', 'Error On Server, Please Contact Administrator');
    } on HttpException {
      Get.snackbar('Message', 'Error On Server, Please Contact Administrator');
    }
  }
}
