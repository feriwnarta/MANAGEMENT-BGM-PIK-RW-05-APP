import 'dart:convert';

import 'package:aplikasi_rw/modules/estate_manager/data/position_employee.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';

import '../../../utils/UserSecureStorage.dart';

class CreateAccountServices {
  static Future<List<PositionEmployee>> getPosition({String type}) async {
    String idUser = await UserSecureStorage.getIdUser();

    String url = '${ServerApp.url}src/employee/get_position.php';

    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    var data = {'id_user': idUser, 'type': type};

    List<PositionEmployee> result = [];

    try {
      var response = await dio.post(url, data: jsonEncode(data));

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        var responseData = jsonDecode(response.data) as List;

        result = responseData
            .map<PositionEmployee>((item) => PositionEmployee.fromJson(item))
            .toList();

        return result;
      }
    } on DioError catch (e) {
      print(e);
    }

    return result;
  }

  static Future<String> saveEmployee({
    String username,
    String name,
    String password,
    String job,
    String email,
    String noTelp,
    String idPosition,
    String division,
    String fotoProfile,
  }) async {
    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    String url = '${ServerApp.url}src/employee/add_employee.php';

    FormData formData;

    if (fotoProfile.isNotEmpty) {
      formData = FormData.fromMap(
        {
          'username': username,
          'name': name,
          'password': password,
          'job': job,
          'email': email,
          'notelp': noTelp,
          'id_position': idPosition,
          'division': division,
          'foto_profile': MultipartFileRecreatable.fromFileSync(
            fotoProfile,
            filename: fotoProfile,
            contentType: MediaType('image', 'jpg'),
          )
        },
      );
    } else {
      formData = FormData.fromMap(
        {
          'username': username,
          'name': name,
          'password': password,
          'job': job,
          'email': email,
          'notelp': noTelp,
          'id_position': idPosition,
          'division': division,
        },
      );
    }

    String message = '';
    final logger = Logger();

    try {
      var response = await dio.post(url, data: formData);

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        message = jsonDecode(response.data);
        logger.e(message);
      }
      return message;
    } on DioError catch (e) {
      print(e);
    }

    return message;
  }

  static Future<String> cordinator(
      {String username,
      String name,
      String password,
      String cordinatorJob,
      String email,
      String noTelp,
      String fotoProfile}) async {
    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    String result = '';

    String url =
        '${ServerApp.url}src/login/login_cordinator/register_cordinator.php';

    FormData formData;

    if (fotoProfile.isNotEmpty) {
      formData = FormData.fromMap(
        {
          'username': username,
          'name_estate_cordinator': name,
          'password': password,
          'cordinator_job': cordinatorJob,
          'email': email,
          'no_telp': noTelp,
          'foto_profile': MultipartFileRecreatable.fromFileSync(
            fotoProfile,
            filename: fotoProfile,
            contentType: MediaType('image', 'jpg'),
          )
        },
      );
    } else {
      formData = FormData.fromMap(
        {
          'username': username,
          'name_estate_cordinator': name,
          'password': password,
          'cordinator_job': cordinatorJob,
          'email': email,
          'no_telp': noTelp,
          'foto_profile': ''
        },
      );
    }

    EasyLoading.show(status: 'loading');
    var response = await dio.post(url, data: formData);

    final logger = Logger();
    logger.i(response.data);

    if (response.statusCode >= 200 && response.statusCode <= 399) {
      result = jsonDecode(response.data);

      EasyLoading.dismiss();

      if (result == 'Register Successful') {
        EasyLoading.showSuccess('Akun berhasil dibuat');
      } else if (result == 'username sudah ada') {
        EasyLoading.showError('Username sudah digunakan');
      } else if (result == 'no telpon sudah ada') {
        EasyLoading.showError('Nomor telpon sudah digunakan');
      } else if (result == 'email sudah ada') {
        EasyLoading.showError('Email sudah digunakan');
      } else if (result == 'gagal menyimpan') {
        EasyLoading.showError('Gagal membuat akun, silahkan coba lagi');
      }

      return result;
    }

    return result;
  }

  static Future<String> contractor(
      {String username,
      String name,
      String password,
      String contractorJob,
      String email,
      String noTelp,
      String idEstateCord,
      String fotoProfile}) async {
    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    String result = '';

    String url =
        '${ServerApp.url}src/login/login_kontraktor/register_kontraktor.php';

    FormData formData;

    if (fotoProfile.isNotEmpty) {
      formData = FormData.fromMap(
        {
          'username': username,
          'name_contractor': name,
          'password': password,
          'contractor_job': contractorJob,
          'id_estate_cordinator': idEstateCord,
          'email': email,
          'no_telp': noTelp,
          'foto_profile': MultipartFileRecreatable.fromFileSync(
            fotoProfile,
            filename: fotoProfile,
            contentType: MediaType('image', 'jpg'),
          )
        },
      );
    } else {
      formData = FormData.fromMap(
        {
          'username': username,
          'name_contractor': name,
          'password': password,
          'contractor_job': contractorJob,
          'id_estate_cordinator': idEstateCord,
          'email': email,
          'no_telp': noTelp,
          'foto_profile': '',
        },
      );
    }

    EasyLoading.show(status: 'loading');
    var response = await dio.post(url, data: formData);

    final logger = Logger();
    logger.i(formData.fields);

    logger.i(formData.fields);

    if (response.statusCode >= 200 && response.statusCode <= 399) {
      logger.i(response.data);
      result = jsonDecode(response.data);

      EasyLoading.dismiss();

      if (result == 'register successfull') {
        EasyLoading.showSuccess('Akun berhasil dibuat');
      } else if (result == 'username sudah ada') {
        EasyLoading.showError('Username sudah digunakan');
      } else if (result == 'no telpon sudah ada') {
        EasyLoading.showError('Nomor telpon sudah digunakan');
      } else if (result == 'email sudah ada') {
        EasyLoading.showError('Email sudah digunakan');
      }

      return result;
    }

    return result;
  }

  static Future<String> manajerKontraktor(
      {String username,
      String name,
      String password,
      String contractorJob,
      String email,
      String noTelp,
      String idEstateCord,
      String idKepalaCon,
      String fotoProfile}) async {
    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    String result = '';

    String url =
        '${ServerApp.url}src/login/login_manager_kontraktor/register_manager_contractor.php';

    FormData formData;

    if (fotoProfile.isNotEmpty) {
      formData = FormData.fromMap(
        {
          'username': username,
          'name_manager': name,
          'password': password,
          'manager_job': contractorJob,
          'id_estate_cordinator': idEstateCord,
          'id_contractor': idKepalaCon,
          'email': email,
          'no_telp': noTelp,
          'foto_profile': MultipartFileRecreatable.fromFileSync(
            fotoProfile,
            filename: fotoProfile,
            contentType: MediaType('image', 'jpg'),
          )
        },
      );
    } else {
      formData = FormData.fromMap(
        {
          'username': username,
          'name_manager': name,
          'password': password,
          'manager_job': contractorJob,
          'id_estate_cordinator': idEstateCord,
          'id_contractor': idKepalaCon,
          'email': email,
          'no_telp': noTelp,
          'foto_profile': '',
        },
      );
    }

    EasyLoading.show(status: 'loading');
    var response = await dio.post(url, data: formData);

    final logger = Logger();
    logger.i(formData.fields);

    logger.i(formData.fields);

    if (response.statusCode >= 200 && response.statusCode <= 399) {
      logger.i(response.data);
      result = jsonDecode(response.data);

      EasyLoading.dismiss();

      if (result == 'register successfull') {
        EasyLoading.showSuccess('Akun berhasil dibuat');
      } else if (result == 'username sudah ada') {
        EasyLoading.showError('Username sudah digunakan');
      } else if (result == 'no telpon sudah ada') {
        EasyLoading.showError('Nomor telpon sudah digunakan');
      } else if (result == 'email sudah ada') {
        EasyLoading.showError('Email sudah digunakan');
      }

      return result;
    }

    return result;
  }

  static Future<List<dynamic>> getBagian() async {
    String idUser = await UserSecureStorage.getIdUser();
    if (idUser == null) {
      idUser = '1';
    }
    List<dynamic> result;

    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    var data = {'id_user': idUser};

    String url = '${ServerApp.url}src/cordinator/tarik_bagian.php';

    var response = await dio.post(url, data: jsonEncode(data));

    if (response.statusCode == 200) {
      var result = jsonDecode(response.data);

      final logger = Logger();
      logger.i(result);

      return result;
    }
    return result;
  }

  static Future<List<Map<String, dynamic>>> getBagianContractor() async {
    String url = '${ServerApp.url}src/contractor/tarik_bagian.php';

    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    String idUser = await UserSecureStorage.getIdUser();

    var data = {'id_user': idUser};

    var result = await dio.post(url, data: jsonEncode(data));

    if (result.statusCode >= 200 && result.statusCode <= 399) {
      var response = jsonDecode(result.data) as List;
      List<Map<String, dynamic>> data =
          response.map<Map<String, dynamic>>((e) => e).toList();
      return data;
    }
  }

  static Future<List<Map<String, dynamic>>> getKepalaBagian() async {
    String url = '${ServerApp.url}src/contractor/tarik_kepala_bagian.php';

    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    String idUser = await UserSecureStorage.getIdUser();

    var data = {'id_user': idUser};
    var result = await dio.post(url, data: jsonEncode(data));

    if (result.statusCode >= 200 && result.statusCode <= 399) {
      var response = jsonDecode(result.data) as List;
      final logger = Logger();
      logger.i(result.data);

      List<Map<String, dynamic>> dataReturn =
          response.map<Map<String, dynamic>>((e) => e).toList();

      return dataReturn;
    }
  }

  static Future<List<Map<String, dynamic>>> getKepalaKontraktor() async {
    String url = '${ServerApp.url}src/contractor/tarik_kepala_contractor.php';

    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    String idUser = await UserSecureStorage.getIdUser();

    var data = {'id_user': idUser};
    var result = await dio.post(url, data: jsonEncode(data));

    if (result.statusCode >= 200 && result.statusCode <= 399) {
      var response = jsonDecode(result.data) as List;
      final logger = Logger();

      List<Map<String, dynamic>> dataReturn =
          response.map<Map<String, dynamic>>((e) => e).toList();

      logger.i(dataReturn);

      return dataReturn;
    }
  }
}
