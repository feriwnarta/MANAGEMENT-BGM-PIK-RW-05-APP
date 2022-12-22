import 'dart:convert';
import 'dart:io';

import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/services/cordinator/process_report_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
// import 'package:logger/logger.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:http/http.dart' as http;

import 'complete_screen.dart';

//ignore: must_be_immutable
class FinishReportScreen extends StatefulWidget {
  FinishReportScreen(
      {Key key,
      this.url,
      this.time,
      this.title,
      this.description,
      this.location,
      this.latitude,
      this.longitude,
      this.idReport,
      name})
      : super(key: key);

  String url,
      title,
      description,
      location,
      time,
      latitude,
      longitude,
      idReport,
      name;
  var pickedFile;
  ImagePicker _picker = ImagePicker();
  String imagePathCond1 = '';
  String imagePathCond2 = '';
  FinishWorkCordinator work;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  var displayTime;
  final UserLoginController userLogin = Get.put(UserLoginController());

  @override
  _FinishReportScreenState createState() => _FinishReportScreenState();
}

class _FinishReportScreenState extends State<FinishReportScreen> {
  @override
  void dispose() async {
    super.dispose();
    await widget._stopWatchTimer.dispose();
  }

  @override
  initState() {
    widget._stopWatchTimer.onExecute.add(StopWatchExecute.start);
    widget._stopWatchTimer
        .setPresetTime(mSec: getMiliSecondFromDatabase(widget.time));
    super.initState();
  }

  final stopWatchTimer = StopWatchTimer();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // final logger = Logger(printer: PrettyPrinter());

  @override
  Widget build(BuildContext context) {
    ProcessReportServices.getDataFinish(idReport: widget.idReport)
        .then((value) => print('id estate ${value.photo1}'));

    // logger.i(widget.name);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xffE0E0E0),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(104.h),
        child: AppBar(
          backgroundColor: Color(0xFF2094F3),
          title: Text(
            'Laporan Selesai',
            style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 2.h),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 24.h, left: 16.w),
                    child: Text('Laporan Sedang Proses'),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      SizedBox(width: 16.w),
                      FutureBuilder<FinishWorkCordinator>(
                          future: ProcessReportServices.getDataFinish(
                              idReport: widget.idReport),
                          builder: (context, snapshot) => (snapshot.hasData)
                              ? (snapshot.data.photo1 != null &&
                                      snapshot.data.photo1.isNotEmpty)
                                  ? Container(
                                      height: 70.h,
                                      width: 70.w,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            '${ServerApp.url}${snapshot.data.photo1}',
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : SizedBox()
                              : CircularProgressIndicator()),
                      SizedBox(width: 16.w),
                      FutureBuilder<FinishWorkCordinator>(
                          future: ProcessReportServices.getDataFinish(
                              idReport: widget.idReport),
                          builder: (context, snapshot) => (snapshot.hasData)
                              ? (snapshot.data.photo2 != null &&
                                      snapshot.data.photo2.isNotEmpty)
                                  ? Container(
                                      height: 70.h,
                                      width: 70.w,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            '${ServerApp.url}${snapshot.data.photo2}',
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : SizedBox(
                                      width: 16.w,
                                    )
                              : CircularProgressIndicator()),
                      SizedBox(width: 16.w),
                      Container(
                        width: 156.w,
                        height: 70.h,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Waktu Kerja'),
                            SizedBox(height: 14.h),
                            StreamBuilder<int>(
                              stream: widget._stopWatchTimer.rawTime,
                              initialData: 0,
                              builder: (context, snap) {
                                final value = snap.data;
                                widget.displayTime =
                                    StopWatchTimer.getDisplayTime(
                                  value,
                                  hours: true,
                                  milliSecond: false,
                                );

                                return Column(
                                  children: <Widget>[
                                    Text(
                                      widget.displayTime,
                                      style: TextStyle(
                                          fontSize: 20.sp,
                                          fontFamily: 'inter',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 42.h),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              width: double.infinity,
              child: Container(
                margin: EdgeInsets.only(left: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    Text(
                      'Konfirmasi Selesai',
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    Text(
                      'Foto Pengerjaan',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    SizedBox(height: 31.h),
                    Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                                height: 156.h,
                                width: 156.w,
                                decoration: BoxDecoration(
                                    color: Color(0xffE0E0E0),
                                    borderRadius: BorderRadius.circular(4)),
                                child: (widget.imagePathCond1.isEmpty)
                                    ? SvgPicture.asset(
                                        'assets/img/image-svg/plus.svg',
                                        color: Colors.grey,
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: Image(
                                            fit: BoxFit.cover,
                                            height: 156.h,
                                            width: 156.w,
                                            image: FileImage(
                                                File(widget.imagePathCond1))),
                                      )),
                            Material(
                              color: Colors.transparent,
                              child: SizedBox(
                                  height: 156.h,
                                  width: 156.w,
                                  child: InkWell(
                                      borderRadius: BorderRadius.circular(5),
                                      splashColor:
                                          Colors.grey[100].withOpacity(0.5),
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: ((builder) =>
                                                bottomImagePicker(
                                                    context, '1')));
                                      })),
                            )
                          ],
                        ),
                        SizedBox(width: 16.w),
                        Stack(
                          children: [
                            Container(
                                height: 156.h,
                                width: 156.w,
                                decoration: BoxDecoration(
                                    color: Color(0xffE0E0E0),
                                    borderRadius: BorderRadius.circular(4)),
                                child: (widget.imagePathCond2.isEmpty)
                                    ? SvgPicture.asset(
                                        'assets/img/image-svg/plus.svg',
                                        color: Colors.grey,
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: Image(
                                            fit: BoxFit.cover,
                                            height: 156.h,
                                            width: 156.w,
                                            image: FileImage(
                                                File(widget.imagePathCond2))),
                                      )),
                            Material(
                              color: Colors.transparent,
                              child: SizedBox(
                                  height: 156.h,
                                  width: 156.w,
                                  child: InkWell(
                                      borderRadius: BorderRadius.circular(5),
                                      splashColor:
                                          Colors.grey[100].withOpacity(0.5),
                                      onTap: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: ((builder) =>
                                                bottomImagePicker(
                                                    context, '2')));
                                      })),
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 110.h),
                    Visibility(
                      visible: (widget.userLogin.status.value == 'cordinator' ||
                              widget.userLogin.status.value == 'contractor')
                          ? true
                          : false,
                      child: SizedBox(
                        width: 328.w,
                        height: 40.h,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Color(0xff2094F3)),
                          child: Text(
                            'Laporan selesai',
                            style:
                                TextStyle(fontSize: 16.sp, color: Colors.white),
                          ),
                          onPressed: () async {
                            if (widget.imagePathCond1.isNotEmpty ||
                                widget.imagePathCond2.isNotEmpty) {
                              String dateNow = DateTime.now().toString();
                              final logger = Logger();
                              EasyLoading.show(status: 'loading');
                              String message =
                                  await ProcessReportServices.completeWorks(
                                      duration: widget.displayTime,
                                      finishTime: dateNow,
                                      idReport: widget.idReport,
                                      img1: widget.imagePathCond1,
                                      img2: widget.imagePathCond2,
                                      message: (widget
                                                  .userLogin.status.value) ==
                                              'cordinator'
                                          ? 'Laporan telah selesai, divalidasi oleh estate cordinator (${widget.userLogin.nameCordinator.value})'
                                          : 'Laporan telah selesai, divalidasi oleh contractor (${widget.userLogin.nameContractor.value})');

                              logger.i(message);
                              EasyLoading.dismiss();

                              if (message != null && message == 'OKE') {
                                Get.off(CompleteScreen(
                                  time: widget.displayTime,
                                  name: widget.name,
                                ));
                              }
                              // ProcessReportServices.completeWorks(
                              //         duration: widget.displayTime,
                              //         finishTime: dateNow,
                              //         idReport: widget.idReport,
                              //         img1: widget.imagePathCond1,
                              //         img2: widget.imagePathCond2,
                              //         message: (widget
                              //                     .userLogin.status.value) ==
                              //                 'cordinator'
                              //             ? 'Laporan telah selesai, divalidasi oleh estate cordinator (${widget.userLogin.nameCordinator.value})'
                              //             : 'Laporan telah selesai, divalidasi oleh contractor (${widget.userLogin.nameContractor.value})')
                              //     .then((value) {
                              //   value.send().then((value) {
                              //     http.Response.fromStream(value).then((value) {
                              //       String message = json.decode(value.body);

                              //       if (message != null && message == 'OKE') {
                              //         Navigator.of(context).push(
                              //             MaterialPageRoute(
                              //                 builder: (context) =>
                              //                     CompleteScreen(
                              //                         time: widget.displayTime,
                              //                         name: widget.name)));
                              //       } else {
                              //         print('gagal');
                              //       }
                              //     });
                              //   });
                              // });
                            } else {
                              // _scaffoldKey.currentState.showSnackBar(SnackBar(
                              //     content: Text(
                              //         'harap masukan foto terlebih dahulu')));
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'harap masukan foto terlebih dahulu')));
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget bottomImagePicker(BuildContext context, String cond) => Container(
        margin: EdgeInsets.only(top: 20),
        // width: MediaQuery.of(context).size.width,
        height: 90.h,
        child: Column(
          children: [
            Text(
              'Pilih gambar',
              style: TextStyle(fontSize: 13.0.sp, fontFamily: 'Pt Sans Narrow'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                    icon: Icon(Icons.camera_alt),
                    label: Text(
                      'Kamera',
                      style: TextStyle(
                          fontSize: 13.0.sp, fontFamily: 'Pt Sans Narrow'),
                    ),
                    onPressed: () {
                      getImage(ImageSource.camera, cond);
                      Navigator.of(context)
                          .pop(); // -> digunakan untuk menutup show modal bottom sheet secara programatic
                    }),
                TextButton.icon(
                  icon: Icon(Icons.image),
                  label: Text(
                    'Gallery',
                    style: TextStyle(
                        fontSize: 13.0.sp, fontFamily: 'Pt Sans Narrow'),
                  ),
                  onPressed: () {
                    getImage(ImageSource.gallery, cond);
                    Navigator.of(context)
                        .pop(); // -> digunakan untuk menutup show modal bottom sheet secara programatic
                  },
                )
              ],
            )
          ],
        ),
      );

  Future getImage(ImageSource source, String condition) async {
    widget.pickedFile =
        await widget._picker.pickImage(source: source, imageQuality: 50);
    if (condition == '1') {
      if (widget.pickedFile != null) {
        widget.imagePathCond1 = widget.pickedFile.path;
        setState(() {});
      }
    } else {
      if (widget.pickedFile != null) {
        widget.imagePathCond2 = widget.pickedFile.path;
        setState(() {});
      }
    }
  }

  int getMiliSecondFromDatabase(String time) {
    int before = DateTime.parse(time).millisecondsSinceEpoch;

    String timeNow = DateTime.now().toString();
    int after = DateTime.parse(timeNow).millisecondsSinceEpoch;

    return after - before;
  }
}
