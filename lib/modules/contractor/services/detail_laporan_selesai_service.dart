import 'dart:convert';

import 'package:aplikasi_rw/modules/contractor/data/detail_laporan_selesai_model.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:logger/logger.dart';

class DetailLaporanSelesaiSevices {
  static Future<DetailLaporanSelesaiModel> getDetail({String idReport}) async {
    String url = '${ServerApp.url}src/report/get_detail_report_finished.php';

    var data = {'id_report': idReport};

    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    DetailLaporanSelesaiModel detail;

    try {
      var result = await dio.post(url, data: jsonEncode(data));

      if (result.statusCode >= 200 && result.statusCode <= 299) {
        var response = jsonDecode(result.data);

        var processReport = response['process_report'] as List;
        processReport =
            processReport.map<Map<String, dynamic>>((e) => e).toList();

        var complaint = response['complaint'] as List;
        complaint = complaint.map<String>((e) => e.toString()).toList();

        detail = DetailLaporanSelesaiModel(
          imageProcess1: response['image_foto_work1'],
          imageProcess2: response['image_foto_work2'],
          imageComplete1: response['image_foto_complete1'],
          imageComplete2: response['image_foto_complete2'],
          location: response['location'],
          star: response['star'],
          duration: response['duration'],
          processReport: processReport,
          complaint: complaint,
        );

        final logger = Logger();
        logger.i(detail.complaint);

        return detail;
      }
    } on DioError catch (e) {
      print(e);
    }

    return detail;
  }
}
