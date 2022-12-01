import 'package:aplikasi_rw/model/category_model.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import '../server-app.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoryServices {

  static Future<List<CategoryModel>> getCategory() async {
    String idUser = await UserSecureStorage.getIdUser();
    String url = '${ServerApp.url}src/category/category.php';
    var data = {'id_user': idUser};

    http.Response response = await http.post(Uri.parse(url), body: jsonEncode(data));
    var obj = jsonDecode(response.body) as List;
    return obj.map((item) => CategoryModel(
      idCategory: item['id_category'],
      category: item['category'],
      icon: item['icon']
    )).toList();
  }
}