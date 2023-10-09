import 'dart:convert';

import 'package:aplikasi_rw/modules/home/screens/upload_payment_ipl_screen.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class DetailCardRequest extends StatelessWidget {
  const DetailCardRequest({Key key, this.id}) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail status permintaan'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.width(16),
              vertical: SizeConfig.height(16),
            ),
            child: FutureBuilder(
              future: getCategoryRequest(idRequest: id),
              builder: (context, snapshot) => (snapshot.hasData)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Permintaan ${snapshot.data['status']}',
                                  style: TextStyle(
                                    fontSize: SizeConfig.text(16),
                                    color:
                                        (snapshot.data['status'] == 'Ditolak')
                                            ? Color(0xffCB3A31)
                                            : (snapshot.data['status'] ==
                                                    'Diproses')
                                                ? Color(0xff3267E3)
                                                : Color(0xff20573D),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.height(4),
                                ),
                                Text(
                                  'Pada ${snapshot.data['update_at']}',
                                  style: TextStyle(
                                    fontSize: SizeConfig.text(12),
                                  ),
                                ),
                              ],
                            ),
                            Image.asset(
                              (snapshot.data['status'] == 'Ditolak')
                                  ? 'assets/img/citizen_menu/permintaan-ditolak.png'
                                  : (snapshot.data['status'] == 'Diproses')
                                      ? 'assets/img/citizen_menu/process.png'
                                      : 'assets/img/citizen_menu/terkirim.png',
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.height(16),
                        ),
                        Divider(
                          color: Color(0xffF5F5F5),
                          thickness: 1,
                        ),
                        SizedBox(
                          height: SizeConfig.height(16),
                        ),
                        Row(
                          children: [
                            Image.asset(
                                'assets/img/citizen_menu/permintaan-kantong-sampah.png'),
                            SizedBox(
                              width: SizeConfig.width(8),
                            ),
                            Text(
                              'Permintaan Kantong Sampah',
                              style: TextStyle(
                                fontSize: SizeConfig.text(16),
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.height(16),
                        ),
                        Divider(
                          color: Color(0xffF5F5F5),
                          thickness: 1,
                        ),
                        SizedBox(
                          height: SizeConfig.height(16),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: CachedNetworkImage(
                            imageUrl:
                                '${ServerApp.url}${snapshot.data['image']}',
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.medium,
                            height: SizeConfig.height(156),
                            width: SizeConfig.width(156),
                            placeholder: (context, url) =>
                                CircularProgressIndicator.adaptive(value: 0.5),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.height(24),
                        ),
                        Text(
                          'Diminta oleh',
                          style: TextStyle(
                            fontSize: SizeConfig.text(10),
                            color: Color(0xff616161),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.height(4),
                        ),
                        Text(
                          '${snapshot.data['name']}, ${snapshot.data['cluster']} NO ${snapshot.data['house_number']}',
                          style: TextStyle(
                            fontSize: SizeConfig.text(12),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.height(12),
                        ),
                        Text(
                          'Diminta pada',
                          style: TextStyle(
                            fontSize: SizeConfig.text(10),
                            color: Color(0xff616161),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.height(4),
                        ),
                        Text(
                          '${snapshot.data['create_at']}',
                          style: TextStyle(
                            fontSize: SizeConfig.text(12),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.height(12),
                        ),
                        (snapshot.data['note'] == null)
                            ? SizedBox()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Alasan Ditolak',
                                    style: TextStyle(
                                      fontSize: SizeConfig.text(10),
                                      color: Color(0xff616161),
                                    ),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.height(4),
                                  ),
                                  Text(
                                    '${snapshot.data['note']}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 7,
                                    style: TextStyle(
                                      fontSize: SizeConfig.text(12),
                                    ),
                                  ),
                                ],
                              ),
                        (snapshot.data['status'] == 'Ditolak')
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(
                                  top: SizeConfig.height(76),
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.to(
                                      () => UploadPaymentIplScreen(),
                                      transition: Transition.rightToLeft,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  )),
                                  child: Text(
                                    'Upload Pembayaran IPL',
                                    style: TextStyle(
                                      fontSize: SizeConfig.text(16),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: SizeConfig.height(16),
                              ),
                        (snapshot.data['delivery_proof'] != '')
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Divider(
                                    thickness: 1,
                                    color: Color(0xffF5F5F5),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.height(16),
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                          'assets/img/citizen_menu/permintaan-kantong-sampah.png'),
                                      SizedBox(
                                        width: SizeConfig.width(8),
                                      ),
                                      Text(
                                        'Bukti Penerimaan',
                                        style: TextStyle(
                                          fontSize: SizeConfig.text(16),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: SizeConfig.height(16),
                                  ),
                                  Divider(
                                    thickness: 1,
                                    color: Color(0xffF5F5F5),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.height(16),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          '${ServerApp.urlAdmin}${snapshot.data['delivery_proof']}',
                                      fit: BoxFit.cover,
                                      filterQuality: FilterQuality.medium,
                                      height: SizeConfig.height(156),
                                      width: SizeConfig.width(156),
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator.adaptive(
                                              value: 0.5),
                                    ),
                                  ),
                                ],
                              )
                            : SizedBox(),
                      ],
                    )
                  : Center(
                      child: CircularProgressIndicator.adaptive(value: 0.5)),
            ),
          ),
        ),
      ),
    );
  }

  static Future<Map<String, dynamic>> getCategoryRequest(
      {String idRequest}) async {
    String url = '${ServerApp.url}src/request/get_detail.php';

    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    try {
      var result =
          await dio.post(url, data: jsonEncode({'id_request': idRequest}));
      var response = jsonDecode(result.data) as List;

      final logger = Logger();
      logger.i(response[0]);

      return response[0];

      // return response;
    } on Exception catch (e) {
      print(e);
      return {};
    }
  }
}
