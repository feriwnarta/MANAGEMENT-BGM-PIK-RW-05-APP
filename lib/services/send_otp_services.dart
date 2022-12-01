import 'package:aplikasi_rw/server-app.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SendOtpServices {
  static Future<String> sendOtpWhatsapp({String noTelp, String email}) async {
    String url = '${ServerApp.url}src/login/otp/otp_whatsapp.php';

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['no_telp'] = noTelp;
    request.fields['email'] = email;
    var response = await request.send();
    var streamResponse = await http.Response.fromStream(response);

    String message = jsonDecode(streamResponse.body);
    return message;
  }

  static Future<http.MultipartRequest> sendOtpGmail(
      {String noTelp, String email}) async {
    String url = '${ServerApp.url}src/login/otp/otp_gmail.php';

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['no_telp'] = noTelp;
    request.fields['email'] = email;
    return request;
    // request.send().then((value) {
    //   http.Response.fromStream(value).then((message) {
    //     String result = jsonDecode(message.body);
    //     print('RESPONSE RESULT :: $result');
    //     return result;
    //   });
    //   return value;
    // });
  }
}
