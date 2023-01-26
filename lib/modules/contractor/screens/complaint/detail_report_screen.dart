import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/modules/contractor/screens/complaint/process_report.dart';
import 'package:aplikasi_rw/modules/contractor/services/contractor_proses_complain_services.dart';
import 'package:aplikasi_rw/services/cordinator/process_report_services.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  DetailReportScreen(
      {this.url,
      this.time,
      this.title,
      this.description,
      this.location,
      this.latitude,
      this.longitude,
      this.idReport,
      this.name});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: Text(
          'Detail Laporan',
          style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 16.w, right: 25.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 24.h, 0, 0),
                width: 319.w,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/img/image-svg/location-marker.svg',
                      color: Colors.black,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: AutoSizeText(
                        location,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                        minFontSize: 13,
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w400),
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
                                  'assets/img/image-svg/Icon-warning.svg'),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: AutoSizeText(
                                  '${explodeTitle()[index]}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14.sp,
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
                              'assets/img/image-svg/Icon-warning.svg'),
                          SizedBox(width: 8.w),
                          Expanded(child: Text(title))
                        ],
                      ),
              ),
              SizedBox(height: 32.h),
              GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ViewImage(
                          urlImage: url,
                        ))),
                child: SizedBox(
                  height: 188.w,
                  width: 319.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: () =>
                    navigateTo(double.parse(latitude), double.parse(longitude)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SvgPicture.asset('assets/img/image-svg/Icon-map.svg'),
                    SizedBox(width: 4.w),
                    Text(
                      'Lihat peta lokasi',
                      style:
                          TextStyle(color: Color(0xff2094F3), fontSize: 10.sp),
                    )
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                width: 319.w,
                child: Text(
                  description,
                  style: TextStyle(
                    color: Color(0xff757575),
                    fontSize: 12.sp,
                  ),
                ),
              ),
              SizedBox(height: 122.h),
              SizedBox(
                width: 328.w,
                height: 40.h,
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
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xff2094F3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
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
    var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch ${uri.toString()}';
    }
  }
}
