import 'dart:convert';

import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class AbsenServices {
  /// method service ini digunakan untuk absen, baik absen masuk atau pulang
  static Future<Map<String, dynamic>> sendAbsen(
      {String idUser,
      String status,
      String hour,
      String location,
      String image}) async {
    String url = '${ServerApp.url}src/absen/absen_masuk_keluar.php';

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['id_user'] = idUser;
    request.fields['status'] = status;
    request.fields['jam'] = hour;
    request.fields['lokasi'] = location;
    var pic = await http.MultipartFile.fromPath('image', image);
    request.files.add(pic);

    var strResponse = await request.send();
    var response = await http.Response.fromStream(strResponse);
    var message = jsonDecode(response.body) as Map;
    final logger = Logger();
    logger.i(message);
    return message;
  }

  static Future<Map<String, dynamic>> checkAbsen() async {
    final logger = Logger();
    Map<String, dynamic> response;
    String url = '${ServerApp.url}src/absen/absen_cordinator_contractor.php';
    var data = {
      'id_user': await UserSecureStorage.getIdUser(),
      'status': await UserSecureStorage.getStatus()
    };
    try {
      var request = await http.post(Uri.parse(url), body: jsonEncode(data));
      if (request.statusCode >= 200 && request.statusCode <= 399) {
        response = jsonDecode(request.body);
        return response;
      } else {
        logger.e(request.statusCode);
      }
    } catch (e) {
      logger.e(e.toString());
    }
    return response;
  }
}
