import 'dart:convert';

import 'package:aplikasi_rw/modules/home/models/category_request.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

class CategoryRequestService {
  static Future<List<CategoryRequest>> getCategoryRequest() async {
    String url = '${ServerApp.url}src/request/category.php';

    String idUser = await UserSecureStorage.getIdUser();

    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    try {
      var result = await dio.post(url, data: jsonEncode({'id_user': idUser}));
      var response = jsonDecode(result.data) as List;

      response = response
          .map<CategoryRequest>((category) => CategoryRequest(
              id: category['id'],
              idMasterCategory: category['id_master_category'],
              category: category['category'],
              icon: category['icon']))
          .toList();

      return response;
    } on Exception catch (e) {
      print(e);
    }
    return [];
  }
}
