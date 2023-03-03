import 'dart:io';

import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/modules/contractor/screens/complaint/process_report.dart';
import 'package:aplikasi_rw/modules/contractor/services/contractor_proses_complain_services.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
// import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/view_image.dart';

//ignore: must_be_immutable
class DetailReportScreen extends StatelessWidget {
  // final logger = Logger(
  //   printer: PrettyPrinter(),
  // );

  final UserLoginController userLogin = Get.put(UserLoginController());

  String url,
      title,
      description,
      location,
      time,
      latitude,
      longitude,
      idReport,
      name;
  bool isContractor;

  DetailReportScreen(
      {this.url,
      this.time,
      this.title,
      this.description,
      this.location,
      this.latitude,
      this.longitude,
      this.idReport,
      this.name,
      this.isContractor});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Detail Laporan',
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
            left: SizeConfig.width(16),
            right: SizeConfig.width(25),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(
                  0,
                  SizeConfig.height(24),
                  0,
                  0,
                ),
                width: SizeConfig.width(319),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/img/image-svg/location-marker.svg',
                      color: Colors.black,
                      width: SizeConfig.width(16),
                      height: SizeConfig.height(16),
                    ),
                    SizedBox(
                      width: SizeConfig.width(8),
                    ),
                    Expanded(
                      child: Text(
                        location,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                        style: TextStyle(
                          fontSize: SizeConfig.text(14),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 16.h, 0, 0),
                child: (title.contains(','))
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: explodeTitle().length,
                        itemBuilder: (context, index) => Container(
                          margin: EdgeInsets.only(bottom: 6.h),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/img/image-svg/Icon-warning.svg',
                                width: SizeConfig.width(16),
                                height: SizeConfig.height(16),
                              ),
                              SizedBox(width: SizeConfig.width(8)),
                              Expanded(
                                child: Text(
                                  '${explodeTitle()[index]}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: SizeConfig.text(14),
                                  ),
                                  maxLines: 2,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : Row(
                        children: [
                          SvgPicture.asset(
                            'assets/img/image-svg/Icon-warning.svg',
                            width: SizeConfig.width(16),
                            height: SizeConfig.height(16),
                          ),
                          SizedBox(width: SizeConfig.width(8)),
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: SizeConfig.text(14),
                              ),
                            ),
                          )
                        ],
                      ),
              ),
              SizedBox(height: SizeConfig.height(32)),
              GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ViewImage(
                          urlImage: url,
                        ))),
                child: SizedBox(
                  height: SizeConfig.height(188),
                  width: SizeConfig.width(399),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.height(8),
              ),
              GestureDetector(
                onTap: () =>
                    navigateTo(double.parse(latitude), double.parse(longitude)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SvgPicture.asset(
                      'assets/img/image-svg/Icon-map.svg',
                      width: SizeConfig.width(16),
                      height: SizeConfig.height(16),
                    ),
                    SizedBox(width: SizeConfig.width(4)),
                    Text(
                      'Lihat peta lokasi',
                      style: TextStyle(
                        color: Color(0xff2094F3),
                        fontSize: SizeConfig.text(10),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: SizeConfig.height(16)),
              SizedBox(
                width: SizeConfig.width(319),
                child: Text(
                  description,
                  style: TextStyle(
                    color: Color(0xff757575),
                    fontSize: SizeConfig.text(12),
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.height(122)),
              Visibility(
                visible: isContractor,
                child: SizedBox(
                  width: SizeConfig.width(328),
                  height: SizeConfig.height(40),
                  child: TextButton(
                    onPressed: () async {
                      EasyLoading.show(status: 'loading');
                      String message =
                          await ContractorProcessComplaint.acceptComplaint(
                        idReport: idReport,
                      );
                      final logger = Logger();
                      logger.i(message);
                      if (message == 'OKE') {
                        EasyLoading.dismiss();
                        Get.off(
                          () => ProcessReportScreen(
                            url: url,
                            title: title,
                            description: description,
                            idReport: idReport,
                            latitude: latitude,
                            location: location,
                            longitude: longitude,
                            isCon: true,
                            time: time,
                            name: (userLogin.status.value == 'cordinator'
                                ? userLogin.nameCordinator.value
                                : userLogin.nameContractor.value),
                          ),
                        );
                      } else {
                        EasyLoading.showError(
                            'Gagal menerima laporan, silahkan coba lagi');
                        EasyLoading.dismiss();
                      }
                    },
                    child: Text(
                      'Terima Laporan',
                      style: TextStyle(
                          fontSize: SizeConfig.height(16), color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xff2094F3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<String> explodeTitle() {
    List<String> titleParts = title.split(',');
    titleParts.removeLast();
    // logger.i('LENGTH = ${titleParts.length}');
    return titleParts;
  }

  static void navigateTo(double lat, double lng) async {
    // var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
    // var uri = Uri.parse('geo:$lat,$lng');

    String appleUrl =
        'https://maps.apple.com/?saddr=&daddr=$lat,$lng&directionsmode=driving';
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng';

    var uri;

    if (Platform.isIOS) {
      uri = Uri.parse(appleUrl);
    } else if (Platform.isAndroid) {
      uri = Uri.parse(googleUrl);
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch ${uri.toString()}';
    }
  }
}
