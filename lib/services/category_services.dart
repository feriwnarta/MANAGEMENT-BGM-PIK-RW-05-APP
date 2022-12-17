import 'package:aplikasi_rw/model/category_model.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import '../server-app.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

class CategoryServices {
  static Future<List<CategoryModel>> getCategory() async {
    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));
    String idUser = await UserSecureStorage.getIdUser();
    String url = '${ServerApp.url}src/category/category.php';
    var data = {'id_user': idUser};

    var response = await dio.post(url, data: jsonEncode(data));
    var obj = jsonDecode(response.data) as List;
    return obj
        .map((item) => CategoryModel(
            idCategory: item['id_category'],
            category: item['category'],
            icon: item['icon']))
        .toList();
  }
}
