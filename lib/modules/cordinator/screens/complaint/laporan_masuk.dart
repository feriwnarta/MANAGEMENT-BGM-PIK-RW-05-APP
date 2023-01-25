import 'dart:async';
import 'package:aplikasi_rw/modules/cordinator/screens/complaint/finish_report_screen.dart';
import 'package:aplikasi_rw/modules/cordinator/screens/complaint/process_report.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controller/report_cordinator_complaint_controller.dart';
import '../../../../controller/user_login_controller.dart';
import '../../../../server-app.dart';
import '../../../../services/cordinator/process_report_services.dart';
import 'detail_report_screen.dart';

class CardReport extends StatefulWidget {
  CardReport({Key key, this.name, this.status}) : super(key: key);

  String name, status;

  @override
  _CardReportState createState() => _CardReportState();
}

class _CardReportState extends State<CardReport>
    with AutomaticKeepAliveClientMixin {
  Timer timer;

  // final ScrollController scrollController = ScrollController();
  final reportCordinatorController = Get.put(ReportCordinatorComplaint());
  final userLoginController = Get.put(UserLoginController());

  void onScroll() {
    if (reportCordinatorController.scrollController.position.maxScrollExtent ==
        reportCordinatorController.scrollController.position.pixels) {
      if (userLoginController.status.value == 'cordinator') {
        reportCordinatorController.getDataFromDb('cordinator');
      } else if (userLoginController.status.value == 'contractor') {
        reportCordinatorController.getDataFromDb('contractor');
      } else {
        reportCordinatorController.getDataFromDb('user');
      }
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    if (timer.isActive) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (userLoginController.status.value == 'cordinator') {
      reportCordinatorController.getDataFromDb('cordinator');
    } else if (userLoginController.status.value == 'contractor') {
      reportCordinatorController.getDataFromDb('contractor');
    } else {
      reportCordinatorController.getDataFromDb('user');
    }
  }

  final logger = Logger();

  @override
  didChangeDependencies() async {
    super.didChangeDependencies();
    timer = Timer.periodic(Duration(seconds: 1), (second) {
      if (userLoginController.status.value == 'cordinator') {
        reportCordinatorController.realtimeData('cordinator');
      } else if (userLoginController.status.value == 'contractor') {
        reportCordinatorController.realtimeData('contractor');
        logger.i(reportCordinatorController.listReport.length);
      } else {
        reportCordinatorController.realtimeData('user');
      }
    });
    reportCordinatorController.scrollController.addListener(onScroll);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan Masuk'),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SingleChildScrollView(
        child: GetX<ReportCordinatorComplaint>(
          init: ReportCordinatorComplaint(),
          builder: (controller) {
            if (controller.isLoading.value) {
              return Center(
                child: SizedBox(
                    height: 30, width: 30, child: CircularProgressIndicator()),
              );
            } else {
              return ListView.builder(
                  shrinkWrap: true,
                  controller: reportCordinatorController.scrollController,
                  itemCount: (controller.isMaxReached.value)
                      ? controller.listReport.length + 1
                      : controller.listReport.length + 1,
                  // itemCount: loaded.listReport.length,
                  itemBuilder: (context, index) => (controller
                              .listReport.length ==
                          0)
                      ? Center(
                          child: Padding(
                          padding: EdgeInsets.only(top: 20.h),
                          child: Text('Tidak ada laporan yang masuk'),
                        ))
                      : (index < controller.listReport.length)
                          ? CardListReport(
                              description:
                                  controller.listReport[index].description,
                              location: controller.listReport[index].address,
                              time: controller.listReport[index].time,
                              title: controller.listReport[index].title,
                              url:
                                  '${ServerApp.url}${controller.listReport[index].urlImage}',
                              idReport: controller.listReport[index].idReport,
                              latitude: controller.listReport[index].latitude,
                              longitude: controller.listReport[index].longitude,
                              name: widget.name,
                              status: '',
                            )
                          : (index == controller.listReport.length)
                              ? SizedBox()
                              : Center(
                                  child: SizedBox(
                                    height: 30.h,
                                    width: 30.h,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1.5,
                                    ),
                                  ),
                                ));
            }
          },
        ),
      ),
    );
  }
}

//ignore: must_be_immutable
class CardListReport extends StatelessWidget {
  CardListReport(
      {Key key,
      this.url,
      this.title,
      this.description,
      this.location,
      this.time,
      this.idReport,
      this.latitude,
      this.name,
      this.status,
      this.longitude,
      this.management})
      : super(key: key);

  String url,
      title,
      description,
      location,
      time,
      latitude,
      longitude,
      idReport,
      name,
      status,
      management;

  final userLogin = UserLoginController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (status == null) {
          EasyLoading.showSuccess('Laporan ini sudah selesai dikerjakan');
        } else {
          EasyLoading.show(status: 'loading');
          Map<String, dynamic> result =
              await ProcessReportServices.checkExistProcess(idReport);
          final logger = Logger();
          logger.e(result);
          EasyLoading.dismiss();
          if (result['status'] == 'NOT EXIST') {
            Get.to(
              () => DetailReportScreen(
                description: description,
                idReport: idReport,
                latitude: latitude,
                location: location,
                longitude: longitude,
                time: time,
                title: title,
                url: url,
              ),
              transition: Transition.cupertino,
            );
          } else if (result['status'] == 'BEEN PROCESSED') {
            Get.to(
              () => FinishReportScreen(
                description: description,
                idReport: idReport,
                latitude: latitude,
                longitude: longitude,
                time: result['data']['create_at'],
                title: title,
                url: url,
              ),
              transition: Transition.cupertino,
            );
          } else {
            Get.to(
              () => ProcessReportScreen(
                description: description,
                idReport: idReport,
                latitude: latitude,
                location: location,
                longitude: longitude,
                time: time,
                title: title,
                url: url,
              ),
              transition: Transition.cupertino,
            );
          }
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 2.h),
        color: Colors.white,
        height: 120.h,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: url,
                height: 70.h,
                width: 70.w,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => SizedBox(
                    height: 70.h,
                    width: 70.w,
                    child: Center(child: CircularProgressIndicator())),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 185.w,
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16),
                      )),
                  SizedBox(
                    width: 180.w,
                    height: 51.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                            'assets/img/image-svg/location-marker.svg'),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            location,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14, color: Color(0xff757575)),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(width: 3.w),
              Text(
                time,
                style: TextStyle(fontSize: 12, color: Color(0xff757575)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
