import 'dart:convert';
import 'dart:developer';

import 'package:aplikasi_rw/modules/home/models/request.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:logger/logger.dart';

class RequestService {
  static Future<List<Request>> getHistory(
      {int start, int limit, String type, String category}) async {
    String url = '${ServerApp.url}src/request/get_history.php';

    if (start != null && limit != null) {
      String idUser = await UserSecureStorage.getIdUser();

      Dio dio = Dio();
      dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

      try {
        var result = await dio.post(url,
            data: jsonEncode({
              'id_user': idUser,
              'start': start,
              'limit': limit,
              'type': type,
              'category': category
            }));

        final logger = Logger();
        logger.i(result);
        logger.i(type);
        logger.i(category);

        if (result == 'something went wrong') {
          return [];
        }

        var response = jsonDecode(result.data) as List;

        response = response
            .map<Request>(
              (history) => Request(
                  id: history['id'],
                  idUser: history['id_user'],
                  image: history['image'],
                  note: history['note'],
                  periode: history['periode'],
                  status: history['status'],
                  createAt: history['create_at']),
            )
            .toList();

        return response;
      } on Exception catch (e) {
        print(e);
      }

      return [];
    }

    return [];
  }
}
