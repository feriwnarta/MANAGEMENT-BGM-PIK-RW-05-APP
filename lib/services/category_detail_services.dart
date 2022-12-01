import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import '../server-app.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    String idUser = await UserSecureStorage.getIdUser();
    String url = '${ServerApp.url}src/category/category_detail.php';
    var data = {'id_user': idUser, 'id_category': idCategory};

    http.Response response =
        await http.post(Uri.parse(url), body: jsonEncode(data));
    var obj = jsonDecode(response.body) as List;
    return obj
        .map((item) => CategoryDetailModel(
            idCategory: item['id_category'],
            idCategoryDetail: item['id_category_detail'],
            iconDetail: item['icon_detail'],
            namecategoryDetail: item['name_category_detail']))
        .toList();
  }
}
