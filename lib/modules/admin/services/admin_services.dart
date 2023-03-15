import 'dart:convert';

import 'package:aplikasi_rw/modules/admin/models/InformasiModel.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';

class AdminServices {
  static Future<List<InformasiModel>> getInformasiWarga() async {
    String idUser = await UserSecureStorage.getIdUser();
    var data = {'id_user': idUser};

    String url = '${ServerApp.url}src/news/news.php';

    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    List<InformasiModel> model;

    try {
      var response = await dio.post(url, data: jsonEncode(data));

      if (response.statusCode >= 200 && response.statusCode <= 399) {
        var result = jsonDecode(response.data) as List;

        model = result
            .map<InformasiModel>((item) => InformasiModel.fromJson(item))
            .toList();

        return model;
      }
    } on DioError catch (e) {
      print(e);
    }

    return [];
  }

  static Future<String> save(
      {String urlImage, String title, String content}) async {
    String url = '${ServerApp.url}src/news/add_news.php';
    Dio dio = Dio();

    try {
      dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

      String idUser = await UserSecureStorage.getIdUser();

      // form data
      var formData = FormData.fromMap({
        'gambar_berita': MultipartFileRecreatable.fromFileSync(
          urlImage,
          filename: urlImage,
          contentType: MediaType("image", "jpeg"),
        ),
        'caption': title,
        'content': content,
        'id_writer': idUser,
      });

      var response = await dio.post(url, data: formData);

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        var result = jsonDecode(response.data);

        return result;
      } else {
        EasyLoading.showError('ada sesuatu yang salah');
      }
    } on DioError catch (e) {
      print(e);
    }

    return '';
  }

  static Future<String> deleteNews({String id}) async {
    String url = '${ServerApp.url}src/news/delete_news.php';

    var data = {'id_user': await UserSecureStorage.getIdUser(), 'id_news': id};

    Dio dio = Dio();

    try {
      dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

      var result = await dio.post(url, data: jsonEncode(data));

      if (result.statusCode >= 200 && result.statusCode <= 299) {
        if (result.data != null) {
          var response = jsonDecode(result.data);

          return response;
        }
      }
    } on DioError catch (e) {
      print(e);
    }

    return '';
  }

  static Future<String> updateNews(
      {String idNews,
      String caption,
      String content,
      String image,
      bool isNewImage}) async {
    String url = '${ServerApp.url}src/news/update_news.php';

    Dio dio = Dio();

    try {
      dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

      String idUser = await UserSecureStorage.getIdUser();
      var formData;
      // form data
      if (isNewImage) {
        formData = FormData.fromMap({
          'image': MultipartFileRecreatable.fromFileSync(
            image,
            filename: image,
            contentType: MediaType("image", "jpeg"),
          ),
          'id_news': idNews,
          'caption': caption,
          'content': content,
          'id_writer': idUser,
        });
      } else {
        formData = FormData.fromMap({
          'image': image,
          'id_news': idNews,
          'caption': caption,
          'content': content,
          'id_writer': idUser,
        });
      }

      var response = await dio.post(url, data: formData);

      if (response.statusCode >= 200 && response.statusCode <= 399) {
        var result = jsonDecode(response.data);
        return result;
      }
    } on DioError catch (e) {
      print(e);
    }
  }
}
