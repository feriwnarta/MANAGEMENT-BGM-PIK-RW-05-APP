import 'dart:convert';
import 'dart:io';
import 'package:aplikasi_rw/controller/report_user_controller.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/services/history_report_services.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
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
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.h,
            ),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                this.rating.value = rating;
              },
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: TextField(
                controller: controllerComment.value,
                maxLines: 3,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 50.h, horizontal: 10.w),
                    border: OutlineInputBorder(),
                    isDense: true,
                    hintText: 'Komentar Anda',
                    hintStyle: TextStyle(fontSize: 12.sp)),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.only(right: 5.w),
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
          systemOverlayStyle: SystemUiOverlayStyle.light,
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
                          height: 300.h,
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
                      height: 20.h,
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 15.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Deskripsi',
                              style: TextStyle(
                                  fontSize: 14.sp, fontFamily: 'poppins'),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Text(
                              widget.description,
                              style: TextStyle(
                                  fontSize: 12.sp, fontFamily: 'Montserrat'),
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 15.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Masalah',
                              style: TextStyle(
                                  fontSize: 14.sp, fontFamily: 'poppins'),
                            ),
                            SizedBox(height: 1.0.h),
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
                                        size: 15.h,
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text(
                                        '${widget.dataKlasifikasi[index]}',
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            fontFamily: 'Montserrat'),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15.h)
                                ],
                              ),
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 15.h,
              ),

              // detail laporan
              buildContainerDetailLaporan(),
              SizedBox(
                height: 15.h,
              ),

              Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15.w, top: 15.h),
                      child: Text(
                        'Lokasi',
                        style:
                            TextStyle(fontSize: 14.0.sp, fontFamily: 'poppins'),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    GoogleMapViewReport(
                        latitude: widget.latitude, longitude: widget.longitude),
                    // SizedBox(height: 15.h),
                  ],
                ),
              ),

              buildContainerHistoryReport(),

              SizedBox(
                height: 2.0.h,
              ),

              Visibility(
                visible: (widget.photoProcess1.isNotEmpty ||
                        widget.photoProcess2.isNotEmpty)
                    ? true
                    : false,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 16.h,
                    horizontal: 16.w,
                  ),
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 15.w),
                        child: Text(
                          'Laporan proses kerja',
                          style: TextStyle(
                              fontSize: 12.0.sp, fontFamily: 'poppins'),
                        ),
                      ),
                      SizedBox(height: 10.h),
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
                                          height: 156.h,
                                          width: 156.w,
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
                  padding:
                      EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                  width: double.infinity,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 2.0.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15.w),
                        child: Text(
                          'Laporan selesai kerja',
                          style: TextStyle(
                              fontSize: 12.0.sp, fontFamily: 'poppins'),
                        ),
                      ),
                      SizedBox(height: 10.h),
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
                                          height: 156.h,
                                          width: 156.w,
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
                              width: 15.w,
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
                                          height: 156.h,
                                          width: 156.w,
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
                height: 15.h,
              ),

              Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        SizedBox(width: 15.w),
                        Text(
                          'Penilaian',
                          style: TextStyle(
                              fontSize: 14.0.sp, fontFamily: 'poppins'),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Obx(
                      () => Row(
                        children: [
                          SizedBox(width: 15.w),
                          RatingBarIndicator(
                            rating: (rating.value != 0)
                                ? rating.value
                                : double.parse(widget.star),
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 35.0,
                            direction: Axis.horizontal,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      margin: EdgeInsets.only(left: 15.w),
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10)),
                      width: 200.w,
                      child: (controllerComment.value.text.isNotEmpty)
                          ? Text(
                              controllerComment.value.text.isEmpty
                                  ? 'Tanpa keterangan'
                                  : controllerComment.value.text,
                              style: TextStyle(fontSize: 12.0.sp),
                            )
                          : Text(
                              (widget.comment.isEmpty)
                                  ? (widget.star.isEmpty)
                                      ? 'Belum ada penilaian'
                                      : 'Tanpa keterangan'
                                  : '${widget.comment}',
                              style: TextStyle(fontSize: 12.0.sp),
                            ),
                    ),
                    SizedBox(height: 10.h),
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
                              fontSize: 14.0.sp, fontFamily: 'poppins'),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 2.h, horizontal: 8.w),
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
                                  fontSize: 12.sp,
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
                              width: 10.w,
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
                                        margin: EdgeInsets.only(left: 15.w),
                                        height: 100.0.h,
                                        child: TimelineTile(
                                          endChild: Container(
                                            margin: EdgeInsets.only(top: 20.h),
                                            child: ListTile(
                                              title: Text(
                                                '${snapshot.data[index].statusProcess}',
                                                style: TextStyle(
                                                    fontSize: 12.0.sp),
                                              ),
                                              subtitle: Text(
                                                '${snapshot.data[index].time}',
                                                style: TextStyle(
                                                    fontSize: 11.0.sp),
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
                                            width: 19,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Center(child: Text('history kosong'))
                              : Container(),
                          SizedBox(height: 5.0.h)
                        ],
                      )
                    : Container(
                        margin: EdgeInsets.only(
                            left: 13.w, top: 10.h, bottom: 10.h),
                        child: Text(
                          'No History Report',
                          style: TextStyle(
                              fontSize: 13.sp, fontWeight: FontWeight.bold),
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
            style: TextStyle(fontSize: 14.0.sp, fontFamily: 'poppins'),
          ),
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nomor Laporan',
                    style: TextStyle(fontSize: 12.sp),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(widget.noTicket,
                      style: TextStyle(
                          fontSize: 12.0.sp,
                          fontFamily: 'Montserrat',
                          color: Colors.indigo)),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text('Waktu Masuk', style: TextStyle(fontSize: 12.0.sp)),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    widget.time,
                    style:
                        TextStyle(fontSize: 12.0.sp, fontFamily: 'Montserrat'),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text('Kategori', style: TextStyle(fontSize: 12.0.sp)),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    children: [
                      Image.network(
                        '${ServerApp.url}icon/${widget.categoryIcon}',
                        height: 20.h,
                      ),
                      SizedBox(
                        width: 10.0.w,
                      ),
                      Text(widget.category,
                          style: TextStyle(
                              fontSize: 12.0.sp, fontFamily: 'Montserrat')),
                    ],
                  ),
                  SizedBox(
                    height: 15.0.h,
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
      height: 300.h,
      child: GoogleMap(
        liteModeEnabled: (Platform.isAndroid) ? true : false,
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
