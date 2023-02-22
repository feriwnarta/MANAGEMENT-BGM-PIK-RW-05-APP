import 'dart:convert';
import 'dart:io';
import 'package:aplikasi_rw/controller/report_user_controller.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/services/history_report_services.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:timeline_tile/timeline_tile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import '../../../utils/view_image.dart';

//ignore: must_be_immutable
class CardLaporanView extends StatefulWidget {
  String urlImage,
      description,
      additionalInformation,
      noTicket,
      status,
      time,
      category,
      categoryIcon,
      latitude,
      idReport,
      idUser,
      longitude,
      star,
      statusWorking,
      comment,
      photoProcess1,
      photoProcess2,
      photoComplete1,
      photoComplete2;
  List<dynamic> dataKlasifikasi;

  CardLaporanView(
      {this.urlImage,
      this.description,
      this.additionalInformation,
      this.noTicket,
      this.status,
      this.time,
      this.category,
      this.categoryIcon,
      this.latitude,
      this.idReport,
      this.idUser,
      this.dataKlasifikasi,
      this.longitude,
      this.star,
      this.comment,
      this.photoComplete1,
      this.photoComplete2,
      this.photoProcess1,
      this.photoProcess2,
      this.statusWorking});

  @override
  _CardLaporanViewState createState() => _CardLaporanViewState();
}

class _CardLaporanViewState extends State<CardLaporanView> {
  bool isVisibilityExpansion = false;
  Rx<TextEditingController> controllerComment = TextEditingController().obs;
  Rx<double> rating = 0.0.obs;
  final ReportUserController reportController = Get.put(ReportUserController());

  @override
  initState() {
    final logger = Logger();
    logger.i(widget.photoComplete1);
    logger.i(widget.photoComplete2);
    logger.i(widget.photoProcess1);
    logger.i(widget.photoProcess2);

    // call alert dialog penilaian
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String idUser = await UserSecureStorage.getIdUser();
      if ((idUser == widget.idUser && widget.status == 'Selesai') &&
          widget.star == '0') {
        _showDialog();
      }
    });
    super.initState();
  }

  _showDialog() async {
    await Future.delayed(Duration(milliseconds: 50));

    Get.defaultDialog(
      title: '',
      titlePadding: EdgeInsets.zero,
      content: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Ayo, nilai hasil kerjanya',
              style: TextStyle(
                  fontSize: SizeConfig.text(16), fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: SizeConfig.height(10),
            ),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding:
                  EdgeInsets.symmetric(horizontal: SizeConfig.width(4)),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                this.rating.value = rating;
              },
            ),
            SizedBox(height: SizeConfig.height(10)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.width(5)),
              child: TextField(
                controller: controllerComment.value,
                maxLines: 3,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                        vertical: SizeConfig.height(50),
                        horizontal: SizeConfig.width(10)),
                    border: OutlineInputBorder(),
                    isDense: true,
                    hintText: 'Komentar Anda',
                    hintStyle: TextStyle(fontSize: SizeConfig.text(12))),
              ),
            ),
            SizedBox(height: SizeConfig.height(5)),
            Padding(
              padding: EdgeInsets.only(right: SizeConfig.width(5)),
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () async {
                    EasyLoading.show(status: 'loading');
                    String result = await sendRating();
                    EasyLoading.dismiss();
                    if (result == 'OKE') {
                      Get.back();
                      reportController.refresReport();
                      reportController.update();
                      EasyLoading.showSuccess('Rating berhasil diberikan');
                    } else {
                      EasyLoading.showSuccess('Rating gagal diberikan');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    foregroundColor: Colors.blue,
                  ),
                  child: Text(
                    'Kirim',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<String> sendRating() async {
    String url = '${ServerApp.url}/src/report/gift_rating.php';
    String idUser = await UserSecureStorage.getIdUser();

    var data = {
      'id_user': idUser,
      'id_report': widget.idReport,
      'star': rating.value,
      'comment': controllerComment.value.text
    };

    var response = await http.post(Uri.parse(url), body: jsonEncode(data));
    if (response.statusCode >= 200 && response.statusCode <= 399) {
      String message = jsonDecode(response.body);
      if (message == 'OKE') {
        return 'OKE';
      } else {
        return 'FALSE';
      }
    } else {
      return 'FALSE';
    }
  }

  Future buildShowDialogAnimation(
      String title, String btnMessage, String urlAsset, double size) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              title,
              style: TextStyle(fontSize: 12.0.sp),
            ),
            insetPadding: EdgeInsets.all(10.0.h),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: SizedBox(
              width: size.w,
              height: size.h,
              child: lottie.LottieBuilder.asset(urlAsset),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(btnMessage),
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pop();
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          title: Text(''),
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: SafeArea(
          child: ListView(
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // image
                    GestureDetector(
                        child: SizedBox(
                          height: SizeConfig.height(300),
                          width: double.infinity,
                          child: Image(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                              widget.urlImage,
                            ),
                          ),
                        ),
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    ViewImage(urlImage: widget.urlImage)))),
                    SizedBox(
                      height: SizeConfig.height(20),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: SizeConfig.width(15)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Deskripsi',
                              style: TextStyle(
                                  fontSize: SizeConfig.text(14),
                                  fontFamily: 'poppins'),
                            ),
                            SizedBox(
                              height: SizeConfig.height(1),
                            ),
                            Text(
                              widget.description,
                              style: TextStyle(
                                  fontSize: SizeConfig.text(12),
                                  fontFamily: 'Montserrat'),
                            ),
                          ],
                        )),
                    SizedBox(
                      height: SizeConfig.height(10),
                    ),
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(left: SizeConfig.width(15)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Masalah',
                              style: TextStyle(
                                  fontSize: SizeConfig.text(14),
                                  fontFamily: 'poppins'),
                            ),
                            SizedBox(height: SizeConfig.height(1)),
                            ListView.builder(
                              itemCount: widget.dataKlasifikasi.length,
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) => Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.circleExclamation,
                                        color: Colors.blue,
                                        size: SizeConfig.image(15),
                                      ),
                                      SizedBox(
                                        width: SizeConfig.width(10),
                                      ),
                                      Text(
                                        '${widget.dataKlasifikasi[index]}',
                                        style: TextStyle(
                                            fontSize: SizeConfig.text(12),
                                            fontFamily: 'Montserrat'),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: SizeConfig.height(15),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )),
                    SizedBox(
                      height: SizeConfig.height(10),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: SizeConfig.height(15),
              ),

              // detail laporan
              buildContainerDetailLaporan(),
              SizedBox(
                height: SizeConfig.height(15),
              ),

              Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: SizeConfig.width(15),
                          top: SizeConfig.width(15)),
                      child: Text(
                        'Lokasi',
                        style: TextStyle(
                            fontSize: SizeConfig.text(14),
                            fontFamily: 'poppins'),
                      ),
                    ),
                    SizedBox(height: SizeConfig.height(15)),
                    GoogleMapViewReport(
                        latitude: widget.latitude, longitude: widget.longitude),
                    // SizedBox(height: 15.h),
                  ],
                ),
              ),

              buildContainerHistoryReport(),

              SizedBox(
                height: SizeConfig.height(2),
              ),

              Visibility(
                visible: (widget.photoProcess1.isNotEmpty ||
                        widget.photoProcess2.isNotEmpty)
                    ? true
                    : false,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.height(16),
                    horizontal: SizeConfig.width(16),
                  ),
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: SizeConfig.width(16)),
                        child: Text(
                          'Laporan proses kerja',
                          style: TextStyle(
                              fontSize: SizeConfig.text(12),
                              fontFamily: 'poppins'),
                        ),
                      ),
                      SizedBox(height: SizeConfig.height(10)),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            (widget.photoProcess1 != null)
                                ? (widget.photoProcess1.isNotEmpty)
                                    ? GestureDetector(
                                        onTap: () {
                                          Get.to(
                                            () => ViewImage(
                                                urlImage:
                                                    '${ServerApp.url}${widget.photoProcess1}'),
                                            transition: Transition.fadeIn,
                                          );
                                        },
                                        child: CachedNetworkImage(
                                          height: SizeConfig.height(156),
                                          width: SizeConfig.width(156),
                                          fit: BoxFit.cover,
                                          imageUrl:
                                              '${ServerApp.url}${widget.photoProcess1}',
                                          progressIndicatorBuilder:
                                              (context, url, progress) =>
                                                  CircularProgressIndicator(),
                                        ),
                                      )
                                    : Spacer()
                                : Spacer(),
                            SizedBox(
                              width: 15.w,
                            ),
                            (widget.photoProcess2 != null)
                                ? (widget.photoProcess2.isNotEmpty)
                                    ? GestureDetector(
                                        onTap: () {
                                          Get.to(
                                            () => ViewImage(
                                              urlImage:
                                                  '${ServerApp.url}${widget.photoProcess2}',
                                            ),
                                            transition: Transition.fadeIn,
                                          );
                                        },
                                        child: CachedNetworkImage(
                                          height: 156.h,
                                          width: 156.w,
                                          fit: BoxFit.cover,
                                          imageUrl:
                                              '${ServerApp.url}${widget.photoProcess2}',
                                          progressIndicatorBuilder:
                                              (context, url, progress) =>
                                                  CircularProgressIndicator(),
                                        ),
                                      )
                                    : Spacer()
                                : Spacer()
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Visibility(
                visible: (widget.photoComplete1 != null ||
                            widget.photoComplete2 != null) &&
                        (widget.photoComplete1.isNotEmpty ||
                            widget.photoComplete2.isNotEmpty)
                    ? true
                    : false,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.height(16),
                      horizontal: SizeConfig.width(16)),
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: SizeConfig.height(2),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: SizeConfig.width(15)),
                        child: Text(
                          'Laporan selesai kerja',
                          style: TextStyle(
                              fontSize: SizeConfig.text(12),
                              fontFamily: 'poppins'),
                        ),
                      ),
                      SizedBox(height: SizeConfig.height(10)),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            (widget.photoComplete1 != null)
                                ? (widget.photoComplete1.isNotEmpty)
                                    ? GestureDetector(
                                        onTap: () {
                                          Get.to(
                                            () => ViewImage(
                                              urlImage:
                                                  '${ServerApp.url}${widget.photoComplete1}',
                                            ),
                                            transition: Transition.fadeIn,
                                          );
                                        },
                                        child: CachedNetworkImage(
                                          height: SizeConfig.height(156),
                                          width: SizeConfig.width(156),
                                          fit: BoxFit.cover,
                                          imageUrl:
                                              '${ServerApp.url}${widget.photoComplete1}',
                                          progressIndicatorBuilder:
                                              (context, url, progress) =>
                                                  CircularProgressIndicator(),
                                        ),
                                      )
                                    : Spacer()
                                : Spacer(),
                            SizedBox(
                              width: SizeConfig.width(15),
                            ),
                            (widget.photoComplete2 != null)
                                ? (widget.photoComplete2.isNotEmpty)
                                    ? GestureDetector(
                                        onTap: () {
                                          Get.to(
                                            () => ViewImage(
                                              urlImage:
                                                  '${ServerApp.url}${widget.photoComplete2}',
                                            ),
                                            transition: Transition.fadeIn,
                                          );
                                        },
                                        child: CachedNetworkImage(
                                          height: SizeConfig.height(156),
                                          width: SizeConfig.width(156),
                                          fit: BoxFit.cover,
                                          imageUrl:
                                              '${ServerApp.url}${widget.photoComplete2}',
                                          progressIndicatorBuilder:
                                              (context, url, progress) =>
                                                  CircularProgressIndicator(),
                                        ),
                                      )
                                    : Spacer()
                                : Spacer()
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: SizeConfig.height(15),
              ),

              Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: SizeConfig.height(10)),
                    Row(
                      children: [
                        SizedBox(width: SizeConfig.width(15)),
                        Text(
                          'Penilaian',
                          style: TextStyle(
                              fontSize: SizeConfig.text(14),
                              fontFamily: 'poppins'),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.height(10),
                    ),
                    Obx(
                      () => Row(
                        children: [
                          SizedBox(width: SizeConfig.width(15)),
                          RatingBarIndicator(
                            rating: (rating.value != 0)
                                ? rating.value
                                : double.parse(widget.star),
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: SizeConfig.image(30),
                            direction: Axis.horizontal,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: SizeConfig.height(10)),
                    Container(
                      margin: EdgeInsets.only(left: SizeConfig.width(15)),
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.width(5),
                          vertical: SizeConfig.height(5)),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10)),
                      width: SizeConfig.width(200),
                      child: (controllerComment.value.text.isNotEmpty)
                          ? Text(
                              controllerComment.value.text.isEmpty
                                  ? 'Tanpa keterangan'
                                  : controllerComment.value.text,
                              style: TextStyle(fontSize: SizeConfig.text(12)),
                            )
                          : Text(
                              (widget.comment.isEmpty)
                                  ? (widget.star.isEmpty)
                                      ? 'Belum ada penilaian'
                                      : 'Tanpa keterangan'
                                  : '${widget.comment}',
                              style: TextStyle(fontSize: SizeConfig.text(12)),
                            ),
                    ),
                    SizedBox(height: SizeConfig.height(10)),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Container buildContainerHistoryReport() {
    return Container(
      color: Colors.white,
      child: Theme(
        data: ThemeData().copyWith(
            dividerColor: Colors.transparent, accentColor: Colors.black),
        child: FutureBuilder<List<HistoryReportModel>>(
            future: HistoryReportServices.getHistoryProcess(
                widget.idReport, widget.idUser),
            builder: (context, snapshot) => (snapshot.hasData)
                ? (snapshot.data.isNotEmpty)
                    ? ExpansionTile(
                        expandedAlignment: Alignment.centerLeft,
                        childrenPadding: EdgeInsets.zero,
                        initiallyExpanded: true,
                        onExpansionChanged: (value) =>
                            isVisibilityExpansion = value,
                        title: Text(
                          'Status Laporan',
                          style: TextStyle(
                              fontSize: SizeConfig.text(14),
                              fontFamily: 'poppins'),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.height(2),
                                  horizontal: SizeConfig.width(8)),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: (widget.status == 'Menunggu')
                                      ? Color(0xffEEB4B0)
                                      : (widget.status == 'Diproses')
                                          ? Color(0xffEECEB0)
                                          : (widget.status == 'Selesai')
                                              ? Color(0xffB8DBCA)
                                              : Color(
                                                  0xffFF6A6A,
                                                ),
                                ),
                                borderRadius: BorderRadius.circular(6),
                                color: (widget.status == 'Menunggu')
                                    ? Color(0xffEEB4B0).withOpacity(0.5)
                                    : (widget.status == 'Diproses')
                                        ? Color(0xffEECEB0).withOpacity(0.5)
                                        : (widget.status == 'Selesai')
                                            ? Color(0xffB8DBCA).withOpacity(0.5)
                                            : Color(0xffFFC9C9)
                                                .withOpacity(0.5),
                              ),
                              child: Text(
                                widget.status,
                                style: TextStyle(
                                  fontSize: SizeConfig.text(12),
                                  color:
                                      (widget.status == 'Eskalasi tingkat 1' ||
                                              widget.status ==
                                                  'Eskalasi tingkat 2' ||
                                              widget.status ==
                                                  'Eskalasi tingkat 3')
                                          ? Color(0xffF32020)
                                          : Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.width(10),
                            ),
                          ],
                        ),
                        children: [
                          (snapshot.hasData)
                              ? (snapshot.data.length > 0)
                                  ? ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: snapshot.data.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) =>
                                          Container(
                                        margin: EdgeInsets.only(
                                            left: SizeConfig.width(15)),
                                        height: 100.0.h,
                                        child: TimelineTile(
                                          endChild: Container(
                                            margin: EdgeInsets.only(
                                                top: SizeConfig.height(20)),
                                            child: ListTile(
                                              title: Text(
                                                '${snapshot.data[index].statusProcess}',
                                                style: TextStyle(
                                                    fontSize:
                                                        SizeConfig.text(12)),
                                              ),
                                              subtitle: Text(
                                                '${snapshot.data[index].time}',
                                                style: TextStyle(
                                                    fontSize:
                                                        SizeConfig.text(11)),
                                              ),
                                            ),
                                          ),
                                          isFirst: index == 0 ? true : false,
                                          beforeLineStyle: LineStyle(
                                              color: Colors.blueAccent,
                                              thickness: 1),
                                          afterLineStyle: LineStyle(
                                              color: Colors.blueAccent,
                                              thickness: 1),
                                          indicatorStyle: IndicatorStyle(
                                            color: Colors.green,
                                            width: SizeConfig.width(19),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Center(
                                      child: Text(
                                      'history kosong',
                                      style: TextStyle(
                                          fontSize: SizeConfig.text(15)),
                                    ))
                              : Container(),
                          SizedBox(height: SizeConfig.height(10))
                        ],
                      )
                    : Container(
                        margin: EdgeInsets.only(
                            left: SizeConfig.width(13),
                            top: SizeConfig.height(10),
                            bottom: SizeConfig.width(10)),
                        child: Text(
                          'No History Report',
                          style: TextStyle(
                              fontSize: SizeConfig.text(13),
                              fontWeight: FontWeight.bold),
                        ),
                      )
                : Container()),
      ),
    );
  }

  Container buildContainerDetailLaporan() {
    return Container(
      color: Colors.white,
      child: Theme(
        data: ThemeData().copyWith(
            dividerColor: Colors.transparent, accentColor: Colors.black),
        child: ExpansionTile(
          expandedAlignment: Alignment.centerLeft,
          initiallyExpanded: true,
          title: Text(
            'Detail Masalah',
            style:
                TextStyle(fontSize: SizeConfig.text(14), fontFamily: 'poppins'),
          ),
          children: [
            Padding(
              padding: EdgeInsets.only(left: SizeConfig.width(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nomor Laporan',
                    style: TextStyle(fontSize: SizeConfig.text(12)),
                  ),
                  SizedBox(
                    height: SizeConfig.height(5),
                  ),
                  Text(widget.noTicket,
                      style: TextStyle(
                          fontSize: SizeConfig.text(12),
                          fontFamily: 'Montserrat',
                          color: Colors.indigo)),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    'Waktu Masuk',
                    style: TextStyle(
                      fontSize: SizeConfig.text(12),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.height(5),
                  ),
                  Text(
                    widget.time,
                    style: TextStyle(
                        fontSize: SizeConfig.text(12),
                        fontFamily: 'Montserrat'),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text('Kategori',
                      style: TextStyle(fontSize: SizeConfig.text(12))),
                  SizedBox(
                    height: SizeConfig.height(5),
                  ),
                  Row(
                    children: [
                      Image.network(
                        '${ServerApp.url}icon/${widget.categoryIcon}',
                        height: SizeConfig.image(20),
                      ),
                      SizedBox(
                        width: SizeConfig.width(10),
                      ),
                      Text(widget.category,
                          style: TextStyle(
                              fontSize: SizeConfig.text(12),
                              fontFamily: 'Montserrat')),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.height(15),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GoogleMapViewReport extends StatefulWidget {
  const GoogleMapViewReport({
    Key key,
    @required this.latitude,
    @required this.longitude,
  }) : super(key: key);

  final String latitude;
  final String longitude;

  @override
  _GoogleMapViewReportState createState() => _GoogleMapViewReportState();
}

class _GoogleMapViewReportState extends State<GoogleMapViewReport> {
  GoogleMapController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.height(300),
      child: GoogleMap(
        liteModeEnabled: (Platform.isAndroid) ? true : false,
        compassEnabled: false,
        myLocationButtonEnabled: false,
        initialCameraPosition: CameraPosition(
            bearing: 192.8334901395799,
            target: LatLng(
                double.parse(widget.latitude), double.parse(widget.longitude)),
            tilt: 0,
            zoom: 12.151926040649414),
        zoomControlsEnabled: false,
        zoomGesturesEnabled: false,
        onMapCreated: (controller) => _controller = controller,
        mapType: MapType.normal,
        buildingsEnabled: false,
        markers: {
          Marker(
              markerId: MarkerId('1'),
              position: LatLng(double.parse(widget.latitude),
                  double.parse(widget.longitude)))
        },
      ),
    );
  }
}
