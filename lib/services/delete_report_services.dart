import '../server-app.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';

class DeleteReportServices {
  static Future<String> deleteReport({String idUser, String idReport}) async {
    String url = '${ServerApp.url}/src/report/delete_report.php';
    var data = {'id_user': idUser, 'id_report': idReport};

    try {
      http.Response response = await http.post(Uri.parse(url), body: json.encode(data));

      if (response.statusCode >= 400) {
        // error 400 keatas
        Get.snackbar('Message', 'Error, Please Try Again');
      }

      if (response.statusCode >= 200 && response.statusCode <= 399) {
        String responseBody = json.decode(response.body);
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
