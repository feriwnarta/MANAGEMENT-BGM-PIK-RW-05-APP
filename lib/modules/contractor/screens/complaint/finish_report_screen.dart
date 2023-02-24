import 'dart:io';

import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/modules/contractor/services/contractor_proses_complain_services.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/services/cordinator/process_report_services.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
// import 'package:logger/logger.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

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
      this.isCon,
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
  bool isCon;
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

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Laporan Sedang Proses',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: SizeConfig.height(2)),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: SizeConfig.height(24), left: SizeConfig.width(16)),
                    child: Text(
                      'Laporan Sedang Di Proses',
                      style: TextStyle(fontSize: SizeConfig.text(16)),
                    ),
                  ),
                  SizedBox(height: SizeConfig.height(10)),
                  Row(
                    children: [
                      SizedBox(width: SizeConfig.width(16)),
                      FutureBuilder<FinishWorkContractor>(
                          future: ContractorProcessComplaint.getFinishComplaint(
                            idReport: widget.idReport,
                          ),
                          builder: (context, snapshot) => (snapshot.hasData)
                              ? (snapshot.data.photo1 != null &&
                                      snapshot.data.photo1.isNotEmpty)
                                  ? Container(
                                      height: SizeConfig.height(70),
                                      width: SizeConfig.width(70),
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
                              : CircularProgressIndicator.adaptive()),
                      SizedBox(width: SizeConfig.width(16)),
                      FutureBuilder<FinishWorkContractor>(
                          future: ContractorProcessComplaint.getFinishComplaint(
                            idReport: widget.idReport,
                          ),
                          builder: (context, snapshot) => (snapshot.hasData)
                              ? (snapshot.data.photo2 != null &&
                                      snapshot.data.photo2.isNotEmpty)
                                  ? Container(
                                      height: SizeConfig.height(70),
                                      width: SizeConfig.width(70),
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
                                      width: SizeConfig.width(16),
                                    )
                              : CircularProgressIndicator()),
                      SizedBox(width: SizeConfig.width(16)),
                      Container(
                        width: SizeConfig.width(156),
                        height: SizeConfig.height(70),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Waktu Kerja',
                              style: TextStyle(fontSize: SizeConfig.text(10)),
                            ),
                            SizedBox(height: SizeConfig.height(14)),
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
                                          fontSize: SizeConfig.text(20),
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
                  SizedBox(height: SizeConfig.height(42)),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              width: double.infinity,
              child: Container(
                margin: EdgeInsets.only(left: SizeConfig.width(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: SizeConfig.height(16)),
                    Text(
                      'Konfirmasi Selesai',
                      style: TextStyle(
                          fontSize: SizeConfig.text(16),
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: SizeConfig.height(24),
                    ),
                    Text(
                      'Foto Pengerjaan',
                      style: TextStyle(fontSize: SizeConfig.text(16)),
                    ),
                    SizedBox(height: SizeConfig.height(31)),
                    Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                                height: SizeConfig.height(156),
                                width: SizeConfig.width(156),
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
                                            height: SizeConfig.height(156),
                                            width: SizeConfig.width(156),
                                            image: FileImage(
                                                File(widget.imagePathCond1))),
                                      )),
                            Material(
                              color: Colors.transparent,
                              child: SizedBox(
                                  height: SizeConfig.height(156),
                                  width: SizeConfig.width(156),
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
                        SizedBox(width: SizeConfig.width(16)),
                        Stack(
                          children: [
                            Container(
                                height: SizeConfig.height(156),
                                width: SizeConfig.width(156),
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
                                            height: SizeConfig.height(156),
                                            width: SizeConfig.width(156),
                                            image: FileImage(
                                                File(widget.imagePathCond2))),
                                      )),
                            Material(
                              color: Colors.transparent,
                              child: SizedBox(
                                  height: SizeConfig.height(156),
                                  width: SizeConfig.width(156),
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
                    SizedBox(height: SizeConfig.height(110)),
                    Visibility(
                      visible: widget.isCon,
                      child: SizedBox(
                        width: SizeConfig.width(328),
                        height: SizeConfig.height(40),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xff2094F3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: Text(
                            'Laporan selesai',
                            style: TextStyle(
                                fontSize: SizeConfig.text(16),
                                color: Colors.white),
                          ),
                          onPressed: () async {
                            if (widget.imagePathCond1.isNotEmpty ||
                                widget.imagePathCond2.isNotEmpty) {
                              String dateNow = DateTime.now().toString();
                              final logger = Logger();
                              EasyLoading.show(status: 'loading');
                              String message = await ContractorProcessComplaint
                                  .finishComplaint(
                                duration: widget.displayTime,
                                finishTime: dateNow,
                                idReport: widget.idReport,
                                img1: widget.imagePathCond1,
                                img2: widget.imagePathCond2,
                              );

                              logger.i(message);
                              EasyLoading.dismiss();

                              if (message != null && message == 'OKE') {
                                Get.off(
                                  CompleteScreen(
                                    time: widget.displayTime,
                                    name: widget.name,
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'harap masukan foto terlebih dahulu',
                                    style: TextStyle(
                                        fontSize: SizeConfig.text(16)),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: SizeConfig.height(32))
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
        margin: EdgeInsets.only(top: SizeConfig.height(20)),
        // width: MediaQuery.of(context).size.width,
        height: SizeConfig.height(90),
        child: Column(
          children: [
            Text(
              'Pilih gambar',
              style: TextStyle(
                  fontSize: SizeConfig.text(13), fontFamily: 'Pt Sans Narrow'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                    icon: Icon(Icons.camera_alt),
                    label: Text(
                      'Kamera',
                      style: TextStyle(
                        fontSize: SizeConfig.text(13),
                      ),
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
                      fontSize: SizeConfig.text(13),
                    ),
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
