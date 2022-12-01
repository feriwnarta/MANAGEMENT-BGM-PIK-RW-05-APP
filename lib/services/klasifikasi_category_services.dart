import 'package:logger/logger.dart';

import '../server-app.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    String url = '${ServerApp.url}src/category/klasifikasi_category.php';
    var data = {'id_category': idCategory};

    http.Response response =
        await http.post(Uri.parse(url), body: jsonEncode(data));
    var obj = jsonDecode(response.body) as List;
    final logger = Logger();
    logger.e(obj);

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
