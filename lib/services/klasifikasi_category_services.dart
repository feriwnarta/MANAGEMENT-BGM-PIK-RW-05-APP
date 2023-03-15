import 'package:dio_smart_retry/dio_smart_retry.dart';
import '../server-app.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

class KlasifikasiCategory {
  String name, idCategoryDetail;
  List<Map<String, dynamic>> dataKlasifikasi;

  KlasifikasiCategory({
    this.idCategoryDetail,
    this.name,
    this.dataKlasifikasi,
  });
}

class KlasifikasiCategoryServices {
  // static Stream<List<KlasifikasiCategory>> getKlasifikasiCategory(
  //     String idCategory) async* {
  //   String url = '${ServerApp.url}src/category/klasifikasi_category.php';
  //   var data = {'id_category': idCategory};

  //   http.Response response = await http.post(url, body: jsonEncode(data));
  //   var obj = jsonDecode(response.body) as List;
  //   yield obj
  //       .map((item) => KlasifikasiCategory(
  //           idCategoryDetail: item['id_castegory_detail'],
  //           idKlasifikasi: item['id_klasifikasi'],
  //           klasifikasi: item['klasifikasi']))
  //       .toList();
  // }

  static Future<List<KlasifikasiCategory>> getKlasifikasiCategory2(
      String idCategory) async {
    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));
    String url = '${ServerApp.url}src/category/klasifikasi_category.php';
    var data = {'id_category': idCategory};

    var response = await dio.post(url, data: jsonEncode(data));
    var obj = jsonDecode(response.data) as List;

    return obj
        .map(
          (item) => KlasifikasiCategory(
            idCategoryDetail: item['id_category_detail'],
            name: item['name'],
            dataKlasifikasi: item['data_klasifikasi']
                .map<Map<String, dynamic>>(
                  (data) => {
                    'name_klasifikasi': data['name_klasifikasi'],
                    'id_klasifikasi': data['id_klasifikasi'],
                  },
                )
                .toList(),
          ),
        )
        .toList();
  }
}
