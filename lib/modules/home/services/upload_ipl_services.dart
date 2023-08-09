import 'dart:convert';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';

class UploadIplServices {
  static Dio dio = Dio();

  static Future<String> uploadIpl(String image) async {
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    String idUser = await UserSecureStorage.getIdUser();
    if (idUser == null) {
      idUser = '1';
    }

    String url = '${ServerApp.url}src/payment_ipl/upload.php';
    var formData = FormData.fromMap({
      'id_user': idUser,
      'img_ipl': MultipartFileRecreatable.fromFileSync(
        image,
        filename: image,
        contentType: MediaType("image", "jpeg"),
      ),
    });

    EasyLoading.show(status: 'mengirim');

    var response = await dio.post(url, data: formData);

    EasyLoading.dismiss();

    if (response.statusCode >= 399) {
      return 'server failed';
    }

    var result = jsonDecode(response.data);

    if (result != null) {
      return result;
    }

    return 'failed';
  }

  static Future<Map<String, dynamic>> checkPayment() async {
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    String idUser = await UserSecureStorage.getIdUser();
    if (idUser == null) {
      idUser = '1';
    }

    String url = '${ServerApp.url}src/payment_ipl/check_payment.php';
    var data = {'id_user': idUser};

    var response = await dio.post(url, data: jsonEncode(data));
    var result = jsonDecode(response.data);

    final logger = Logger();
    logger.i(result['']);

    return result;
  }
}
