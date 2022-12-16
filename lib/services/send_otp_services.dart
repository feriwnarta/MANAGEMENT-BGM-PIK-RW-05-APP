import 'package:aplikasi_rw/server-app.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class SendOtpServices {
  static Future<String> sendOtpWhatsapp({String noTelp, String email}) async {
    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));
    String url = '${ServerApp.url}src/login/otp/otp_whatsapp.php';
    var formData = FormData.fromMap({'no_telp': noTelp, 'email': email});

    var request = await dio.post(url, data: formData);

    String message = jsonDecode(request.data);
    return message;
  }

  static Future<String> sendOtpGmail({String noTelp, String email}) async {
    String url = '${ServerApp.url}src/login/otp/otp_gmail.php';

    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    var formData = FormData.fromMap({'no_telp': noTelp, 'email': email});

    var request = await dio.post(url, data: formData);
    return jsonDecode(request.data);
  }
}
