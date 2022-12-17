import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import '../server-app.dart';
import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';

class DeleteReportServices {
  static Future<String> deleteReport({String idUser, String idReport}) async {
    String url = '${ServerApp.url}/src/report/delete_report.php';
    var data = {'id_user': idUser, 'id_report': idReport};
    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    try {
      var response = await dio.post(url, data: json.encode(data));

      if (response.statusCode >= 400) {
        // error 400 keatas
        Get.snackbar('Message', 'Error, Please Try Again');
      }

      if (response.statusCode >= 200 && response.statusCode <= 399) {
        String responseBody = json.decode(response.data);
        if (responseBody.isNotEmpty && responseBody != null) {
          return responseBody;
        } else {
          // body kosong kemungkinan terjadi error
          Get.snackbar('Message', 'Error, Please Try Again');
        }
      }
    } on SocketException {
      Get.snackbar('Message', 'Error On Server, Please Contact Administrator');
    } on HttpException {
      Get.snackbar('Message', 'Error On Server, Please Contact Administrator');
    }
  }
}
