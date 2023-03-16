import 'dart:convert';
import 'package:aplikasi_rw/modules/home/models/card_news.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

class NewsServices {
  static Future<List<CardNews>> getNews() async {
    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    String idUser = await UserSecureStorage.getIdUser();
    if (idUser == null) {
      idUser = '1';
    }

    String url = '${ServerApp.url}src/news/news.php';
    var data = {'id_user': idUser};

    var response = await dio.post(url, data: jsonEncode(data));
    // http.Response response = await http.post(url, body: jsonEncode(data));

    var obj = jsonDecode(response.data) as List;
    return obj
        .map(
          (item) => CardNews(
              url: item['url_news_image'],
              content: item['content'],
              title: item['caption']),
        )
        .toList();
  }
}
