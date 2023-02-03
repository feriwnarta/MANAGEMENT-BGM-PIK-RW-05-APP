import 'dart:convert';

import 'package:aplikasi_rw/modules/home/models/notification_model.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

class NotificationServices {
  static Future<List<NotificationModel>> getListNotification() async {
    String url = '${ServerApp.url}src/list_notif/get_notification.php';

    String idUser = await UserSecureStorage.getIdUser();

    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    try {
      var result = await dio.post(url, data: jsonEncode({'id_user': idUser}));

      if (result.statusCode >= 200 && result.statusCode <= 399) {
        if (jsonDecode(result.data) != "EMPTY") {
          var response = jsonDecode(result.data) as List;

          return response
              .map<NotificationModel>(
                (rs) => NotificationModel(
                  caption: rs['caption'],
                  time: rs['time'],
                  title: rs['title'],
                  urlImage: rs['url_profile'],
                  content: rs['content'],
                ),
              )
              .toList();
        } else {
          return [];
        }
      } else {
        // print error server
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  static Future<String> countNotif() async {
    String idUser = await UserSecureStorage.getIdUser();

    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    try {
      String url = '${ServerApp.url}src/list_notif/count_of_notification.php';

      var response = await dio.post(url, data: jsonEncode({'id_user': idUser}));

      if (response.data != null && response.data != '') {
        var message = jsonDecode(response.data)['count'];
        print(message);
        print(idUser);
        return message;
      } else {
        return '0';
      }
    } on Exception catch (e) {
      print(e);
    }

    // return response.data['count'];
  }
}
