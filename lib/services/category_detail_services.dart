import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import '../server-app.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';

class CategoryDetailModel {
  String idCategoryDetail, idCategory, iconDetail, namecategoryDetail;

  CategoryDetailModel(
      {this.idCategory,
      this.idCategoryDetail,
      this.iconDetail,
      this.namecategoryDetail});
}

class CategoryDetailServices {
  static Future<List<CategoryDetailModel>> getCategoryDetail(
      String idCategory) async {
    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));
    String idUser = await UserSecureStorage.getIdUser();
    String url = '${ServerApp.url}src/category/category_detail.php';
    var data = {'id_user': idUser, 'id_category': idCategory};

    var response = await dio.post(url, data: jsonEncode(data));
    var obj = jsonDecode(response.data) as List;
    return obj
        .map((item) => CategoryDetailModel(
            idCategory: item['id_category'],
            idCategoryDetail: item['id_category_detail'],
            iconDetail: item['icon_detail'],
            namecategoryDetail: item['name_category_detail']))
        .toList();
  }
}
