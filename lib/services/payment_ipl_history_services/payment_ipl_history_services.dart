import 'dart:convert';

import 'package:aplikasi_rw/model/payment_ipl_history_model.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:logger/logger.dart';

class HistoryPaymentIplServices {
  static Future<List<PaymentIplHistoryModel>> getLastPayment() async {
    String url =
        '${ServerApp.url}src/payment_ipl_history/show_last_payment.php';
    String idUser = await UserSecureStorage.getIdUser();
    String noIpl = await UserSecureStorage.readKey(key: 'noIpl');

    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));
    var data = {'no_ipl': noIpl, 'id_user': idUser};
    var response = await dio.post(url, data: data);
    if (response.statusCode >= 200 && response.statusCode <= 399) {
      var result = jsonDecode(response.data);
      if (result is String) {
        return List.empty();
      } else {
        var rs = jsonDecode(response.data) as List;
        return rs
            .map(
              (e) => PaymentIplHistoryModel(
                  nomorIpl: e['nomor_bast'],
                  jumlahTagihan: e['nominal_tgh'],
                  statusPembayaran: e['status'],
                  tanggalPembayaran: e['tanggal_transaksi'],
                  bulanTagihan: e['bulan_tagihan']),
            )
            .toList();
      }
    } else {
      //! response error dari server
      final logger = Logger();
      logger.e('server error');
    }
    return [];
  }
}
