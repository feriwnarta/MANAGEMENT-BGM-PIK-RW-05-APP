import 'package:aplikasi_rw/model/status_user_model.dart';
import 'package:dio/dio.dart' as sidio;
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';

import '../server-app.dart';

class StatusUserServices extends StatusUserModel {
  static Future<String> sendDataStatus(
      {String idUser,
      String imgPath,
      String username,
      String foto_profile,
      String caption,
      String location}) async {
    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    String uri = '${ServerApp.url}src/status/add_status.php';
    var data = {};

    if (imgPath != null && imgPath.isNotEmpty) {
      if (imgPath != 'no_image') {
        data.addEntries({
          'status_image': await MultipartFile.fromFile(imgPath,
              filename: imgPath, contentType: MediaType('image', 'jpg'))
        }.entries);
        // var pic = await http.MultipartFile.fromPath('status_image', imgPath);
        // request.files.add(pic);
      } else {
        // request.fields['status_image'] = imgPath;
        data.addEntries({'status_image': imgPath}.entries);
      }
      data.addAll({
        'id_user': idUser,
        'username': username,
        'foto_profile': foto_profile,
        'caption': caption,
        'location': location
      });

      final logger = Logger();
      logger.i(data);

      var request = await dio.post(uri, data: data);

      // request.fields['id_user'] = idUser;
      // request.fields['username'] = username;
      // request.fields['foto_profile'] = foto_profile;
      // request.fields['caption'] = caption;

      return request.data;

      // await request.send().then((value) {
      //   http.Response.fromStream(value).then((value) {
      //     String message = json.decode(value.body);
      //     print('msg' + message);
      //   });
      // });

    }
  }

  static Future<List<StatusUserModel>> getDataApi(
      String idUser, int start, int limit) async {
    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    var data = {'id_user': idUser, 'start': start, 'limit': limit};
    String apiUrl = '${ServerApp.url}src/status/status.php';
    // ambil data dari api
    var apiResult = await dio.post(apiUrl, data: json.encode(data));
    // ubah jadi json dan casting ke list
    var jsonObject = json.decode(apiResult.data) as List;
    return jsonObject
        .map<StatusUserModel>((item) => StatusUserModel(
            userName: item['username'],
            uploadTime: item['upload_time'],
            urlProfile: item['foto_profile'],
            caption: item['caption'],
            urlStatusImage: '${ServerApp.url}' + item['status_image'],
            numberOfComments: item['comment'],
            idStatus: item['id_status'],
            numberOfLikes: item['like'],
            isLike: item['is_like'],
            likeCount: item['like_count'],
            commentCount: item['comment_count']))
        .toList();
  }

  static Future<String> sendStatus(
      sidio.FormData formData, sidio.Dio dio) async {
    String m;
    final response = await dio.post('${ServerApp.url}src/status/add_status.php',
        data: formData);
    if (response.statusCode >= 200 && response.statusCode <= 399) {
      m = jsonDecode(response.data);
      return m;
    }
    return m;
  }
}
