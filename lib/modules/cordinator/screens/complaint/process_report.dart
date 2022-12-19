import 'dart:convert';
import 'dart:io';
import 'package:aplikasi_rw/services/cordinator/process_report_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../../../controller/user_login_controller.dart';
import 'finish_report_screen.dart';

//ignore: must_be_immutable
class ProcessReportScreen extends StatefulWidget {
  ProcessReportScreen(
      {Key key,
      this.url,
      this.time,
      this.title,
      this.description,
      this.latitude,
      this.location,
      this.idReport,
      this.longitude,
      this.name})
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
  @override
  _ProcessReportScreenState createState() => _ProcessReportScreenState();

  static void navigateTo(double lat, double lng) async {
    var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch ${uri.toString()}';
    }
  }
}

class _ProcessReportScreenState extends State<ProcessReportScreen> {
  ImagePicker _picker = ImagePicker();

  var pickedFile;

  String imagePathCond1 = '';

  String imagePathCond2 = '';

  PickedFile imageFile;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _userLoginController = Get.put(UserLoginController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xffE0E0E0),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(104.h),
          child: AppBar(
            backgroundColor: Color(0xFF2094F3),
            automaticallyImplyLeading: false,
            title: Text(
              'Proses Laporan',
              style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                child: Container(
                    margin: EdgeInsets.only(left: 16.w, right: 32.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 24.h),
                        Text('Detail Laporan'),
                        SizedBox(height: 16.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 88.h,
                              width: 88.w,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.network(
                                  widget.url,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      width: 208.w,
                                      child: (widget.title.contains(','))
                                          ? ListView.builder(
                                              itemCount: explodeTitle().length,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) =>
                                                  Text(explodeTitle()[index]))
                                          : Text(widget.title)),
                                  SizedBox(height: 8.h),
                                  Text(
                                    widget.description,
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        color: Color(0xff757575)),
                                  ),
                                  SizedBox(height: 13.h),
                                  GestureDetector(
                                    onTap: () => ProcessReportScreen.navigateTo(
                                        double.parse(widget.latitude),
                                        double.parse(widget.longitude)),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                            'assets/img/image-svg/Icon-map.svg'),
                                        SizedBox(width: 4.w),
                                        Text('Lihat peta lokasi',
                                            style: TextStyle(
                                                color: Color(0xff2094F3),
                                                fontSize: 10.sp))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 24.h)
                      ],
                    )),
              ),
              SizedBox(height: 2.h),

              // Informasi Pengerjaan
              Container(
                color: Colors.white,
                child: Container(
                  margin: EdgeInsets.only(left: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.h),
                      Text(
                        'Informasi Pengerjaan',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 24.h),
                      Text('Foto Pengerjaan'),
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
                                  child: (imagePathCond1.isEmpty)
                                      ? SvgPicture.asset(
                                          'assets/img/image-svg/plus.svg',
                                          color: Colors.grey,
                                        )
                                      : Image(
                                          fit: BoxFit.cover,
                                          height: 156.h,
                                          width: 156.w,
                                          image:
                                              FileImage(File(imagePathCond1)))),
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
                                  child: (imagePathCond2.isEmpty)
                                      ? SvgPicture.asset(
                                          'assets/img/image-svg/plus.svg',
                                          color: Colors.grey,
                                        )
                                      : Image(
                                          fit: BoxFit.cover,
                                          height: 156.h,
                                          width: 156.w,
                                          image:
                                              FileImage(File(imagePathCond2)))),
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
                                              enableDrag: true,
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
                        visible: (_userLoginController.status.value ==
                                    'cordinator' ||
                                _userLoginController.status.value ==
                                    'contractor')
                            ? true
                            : false,
                        child: SizedBox(
                          width: 328.w,
                          height: 40.h,
                          child: TextButton(
                            // color: Color(0xff2094F3),
                            style: TextButton.styleFrom(
                                foregroundColor: Color(0xff2094F3)),
                            child: Text(
                              'Proses Laporan',
                              style: TextStyle(
                                  fontSize: 16.sp, color: Colors.white),
                            ),
                            onPressed: () {
                              // insert process work ke tb process
                              if (imagePathCond1.isNotEmpty ||
                                  imagePathCond2.isNotEmpty) {
                                ProcessReportServices.insertProcessWork(
                                        idReport: widget.idReport,
                                        img1: imagePathCond1,
                                        img2: imagePathCond2,
                                        message: 'Laporan sedang dikerjakan')
                                    .then((value) {
                                  value.send().then((value) {
                                    http.Response.fromStream(value)
                                        .then((value) {
                                      String message = json.decode(value.body);
                                      if (message != null &&
                                          message.isNotEmpty) {
                                        if (message == 'OKE') {
                                          ProcessReportServices.getDataFinish(
                                                  idReport: widget.idReport)
                                              .then((value) {
                                            print(
                                                'current time ${value.currentTimeWork}');
                                            if (value != null) {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          FinishReportScreen(
                                                              idReport: widget
                                                                  .idReport,
                                                              time: value
                                                                  .currentTimeWork,
                                                              name:
                                                                  widget.name)))
                                                  .then((value) =>
                                                      Navigator.of(context)
                                                        ..pop()
                                                        ..pop());
                                            }
                                          });
                                        }
                                      }
                                    });
                                  });
                                });
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> explodeTitle() {
    List<String> titleParts = widget.title.split(',');
    List<String> wantedParts = [titleParts.removeAt(0), titleParts.join("")];
    return wantedParts;
  }

  Future getImage(ImageSource source, String condition) async {
    pickedFile = await _picker.pickImage(source: source, imageQuality: 50);
    if (condition == '1') {
      if (pickedFile != null) {
        imagePathCond1 = pickedFile.path;
        setState(() {});
      }
    } else {
      if (pickedFile != null) {
        imagePathCond2 = pickedFile.path;
        setState(() {});
      }
    }
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
}
