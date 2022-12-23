import 'dart:async';
import 'package:aplikasi_rw/controller/report_cordinator_complaint_controller.dart';
import 'package:aplikasi_rw/controller/report_cordinator_finish.dart';
import 'package:aplikasi_rw/controller/report_cordinator_process.dart';
import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/modules/cordinator/screens/complaint/process_report.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/services/cordinator/process_report_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import 'detail_report_screen.dart';
import 'finish_report_screen.dart';

//ignore: must_be_immutable
class ComplaintScreen extends StatefulWidget {
  ComplaintScreen({Key key, this.name}) : super(key: key);
  String name;

  @override
  _ComplaintScreenState createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  void dispose() {
    // Get.delete<ReportCordinatorComplaint>();
    // Get.delete<ReportCordinatorProcess>();
    // Get.delete<ReportCordinatorFinish>();
    super.dispose();
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));

    super.build(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color(0xffE0E0E0),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(104.h),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xFF2094F3),
            flexibleSpace: Container(
              padding: EdgeInsets.only(top: 48.h, left: 16.w, right: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Complaint',
                        style: TextStyle(
                            fontFamily: 'inter',
                            fontSize: 19.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      SizedBox(height: 4.h),
                    ],
                  ),
                  InkWell(
                      splashColor: Colors.white,
                      borderRadius: BorderRadius.circular(200),
                      radius: 15.h,
                      onTap: () {},
                      child: SizedBox(
                        height: 20.h,
                        child: IconButton(
                            splashRadius: 15.h,
                            icon: SvgPicture.asset(
                                'assets/img/image-svg/search.svg'),
                            padding: EdgeInsets.zero,
                            onPressed: () {}),
                      )),
                ],
              ),
            ),
            bottom: TabBar(
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: TextStyle(fontSize: 14.sp),
              tabs: [
                Tab(
                  text: 'Complaint',
                ),
                Tab(
                  text: 'Proses',
                ),
                Tab(text: 'Selesai'),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            CardReport(
              name: widget.name,
              status: 'bukan finish',
            ),
            CardReportProcess(
              name: widget.name,
              status: 'bukan finish',
            ),
            CardReportFinish(
              name: widget.name,
              status: 'finish',
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

//ignore: must_be_immutable
class CardReportProcess extends StatefulWidget {
  CardReportProcess({Key key, this.name, this.status}) : super(key: key);

  String name, status;

  @override
  _CardReportProcessState createState() => _CardReportProcessState();
}

class _CardReportProcessState extends State<CardReportProcess>
    with AutomaticKeepAliveClientMixin {
  Timer timer;
  final controllerReportProcess = Get.put(ReportCordinatorProcess());

  void onScroll() {
    if (controllerReportProcess.scrollcontroller.position.maxScrollExtent ==
        controllerReportProcess.scrollcontroller.position.pixels) {
      controllerReportProcess.getDataFromDb();
    }
  }

  @override
  void dispose() {
    print('dispose 2');
    if (timer.isActive) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  didChangeDependencies() async {
    super.didChangeDependencies();
    controllerReportProcess.scrollcontroller.addListener(onScroll);
    timer = Timer.periodic(Duration(seconds: 3), (second) {
      controllerReportProcess.realtimeData();
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      child: GetX<ReportCordinatorProcess>(
          init: ReportCordinatorProcess(),
          initState: (state) => controllerReportProcess.getDataFromDb(),
          builder: (controller) {
            if (controller.isLoading.value) {
              return Center(
                child: SizedBox(
                    height: 30, width: 30, child: CircularProgressIndicator()),
              );
            } else {
              return ListView.builder(
                  controller: controllerReportProcess.scrollcontroller,
                  itemCount: (controller.isMaxReached.value)
                      ? controller.listReport.length + 1
                      : controller.listReport.length + 1,
                  // itemCount: loaded.listReport.length,
                  itemBuilder: (context, index) => (index <
                          controller.listReport.length)
                      ? CardListReport(
                          description: controller.listReport[index].description,
                          location: controller.listReport[index].address,
                          time: controller.listReport[index].time,
                          title: controller.listReport[index].title,
                          url:
                              '${ServerApp.url}${controller.listReport[index].urlImage}',
                          idReport: controller.listReport[index].idReport,
                          latitude: controller.listReport[index].latitude,
                          longitude: controller.listReport[index].longitude,
                          name: widget.name,
                          status: widget.status,
                        )
                      : (index == controller.listReport.length)
                          ? Center(
                              child: Column(
                              children: [
                                SizedBox(height: 10.h),
                                Text('Tidak ada laporan lagi'),
                              ],
                            ))
                          : Center(
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                ),
                              ),
                            ));
            }
          }),
    );
  }
}

//ignore: must_be_immutable
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
    print('dispose');
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
    timer = Timer.periodic(Duration(seconds: 3), (second) {
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
    return Container(
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
                  controller: reportCordinatorController.scrollController,
                  itemCount: (controller.isMaxReached.value)
                      ? controller.listReport.length + 1
                      : controller.listReport.length + 1,
                  // itemCount: loaded.listReport.length,
                  itemBuilder: (context, index) => (index <
                          controller.listReport.length)
                      ? CardListReport(
                          description: controller.listReport[index].description,
                          location: controller.listReport[index].address,
                          time: controller.listReport[index].time,
                          title: controller.listReport[index].title,
                          url:
                              '${ServerApp.url}${controller.listReport[index].urlImage}',
                          idReport: controller.listReport[index].idReport,
                          latitude: controller.listReport[index].latitude,
                          longitude: controller.listReport[index].longitude,
                          name: widget.name,
                          status: widget.status,
                        )
                      : (index == controller.listReport.length)
                          ? Center(
                              child: Column(
                              children: [
                                SizedBox(height: 10.h),
                                Text('Tidak ada laporan lagi'),
                              ],
                            ))
                          : Center(
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                ),
                              ),
                            ));
            }
          }),
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
    print('finish from $status');

    return GestureDetector(
      onTap: () {
        EasyLoading.show(status: 'loading');
        (status != 'finish')
            ? ProcessReportServices.getDataFinish(idReport: idReport)
                .then((value) {
                if (value == null) {
                  EasyLoading.dismiss();
                  ProcessReportServices.checkExistProcess(idReport)
                      .then((value) {
                    if (value == 'FALSE') {
                      print(value);
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => ProcessReportScreen(
                      //           url: url,
                      //           title: title,
                      //           description: description,
                      //           idReport: idReport,
                      //           latitude: latitude,
                      //           location: location,
                      //           longitude: longitude,
                      //           time: time,
                      //           name: (userLogin.status.value == 'cordinator')
                      //               ? userLogin.nameCordinator.value
                      //               : userLogin.nameContractor.value,
                      //         )));
                      Get.to(() => ProcessReportScreen(
                            url: url,
                            title: title,
                            description: description,
                            idReport: idReport,
                            latitude: latitude,
                            location: location,
                            longitude: longitude,
                            time: time,
                            name: (userLogin.status.value == 'cordinator')
                                ? userLogin.nameCordinator.value
                                : userLogin.nameContractor.value,
                          ));
                    } else {
                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (context) => DetailReportScreen(
                      //       description: description,
                      //       idReport: idReport,
                      //       latitude: latitude,
                      //       location: location,
                      //       longitude: longitude,
                      //       time: time,
                      //       title: title,
                      //       url: url,
                      //       name: (userLogin.status.value == 'cordinator')
                      //           ? userLogin.nameCordinator.value
                      //           : userLogin.nameContractor.value),
                      // ));
                      Get.to(() => DetailReportScreen(
                          description: description,
                          idReport: idReport,
                          latitude: latitude,
                          location: location,
                          longitude: longitude,
                          time: time,
                          title: title,
                          url: url,
                          name: (userLogin.status.value == 'cordinator')
                              ? userLogin.nameCordinator.value
                              : userLogin.nameContractor.value));
                    }
                  });
                } else {
                  EasyLoading.dismiss();
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => FinishReportScreen(
                  //           idReport: value.idReport,
                  //           time: value.currentTimeWork,
                  //           name: (userLogin.status.value == 'cordinator')
                  //               ? userLogin.nameCordinator.value
                  //               : userLogin.nameContractor.value,
                  //         )));
                  Get.to(() => FinishReportScreen(
                        idReport: value.idReport,
                        time: value.currentTimeWork,
                        name: (userLogin.status.value == 'cordinator')
                            ? userLogin.nameCordinator.value
                            : userLogin.nameContractor.value,
                      ));
                }
              })
            : EasyLoading.dismiss();
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

//ignore: must_be_immutable
class CardReportFinish extends StatefulWidget {
  CardReportFinish({Key key, this.name, this.status}) : super(key: key);

  String name, status;

  @override
  _CardReportFinish createState() => _CardReportFinish();
}

class _CardReportFinish extends State<CardReportFinish>
    with AutomaticKeepAliveClientMixin {
  Timer timer;

  // final ScrollController scrollcontroller = ScrollController();
  final controller = Get.put(ReportCordinatorFinish());

  void onScroll() {
    if (controller.scrollcontroller.position.maxScrollExtent ==
        controller.scrollcontroller.position.pixels) {
      controller.getDataFromDb();
    }
  }

  @override
  void dispose() {
    if (timer.isActive) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  didChangeDependencies() async {
    super.didChangeDependencies();
    timer = Timer.periodic(Duration(seconds: 3), (second) {
      controller.realtimeData();
    });
    controller.scrollcontroller.addListener(onScroll);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: GetX<ReportCordinatorFinish>(
          init: ReportCordinatorFinish(),
          initState: (state) => controller.getDataFromDb(),
          builder: (controller) {
            if (controller.isLoading.value) {
              return Center(
                child: SizedBox(
                    height: 30, width: 30, child: CircularProgressIndicator()),
              );
            } else {
              return ListView.builder(
                  controller: controller.scrollcontroller,
                  itemCount: (controller.isMaxReached.value)
                      ? controller.listReport.length + 1
                      : controller.listReport.length + 1,
                  // itemCount: loaded.listReport.length,
                  itemBuilder: (context, index) => (index <
                          controller.listReport.length)
                      ? CardListReport(
                          description: controller.listReport[index].description,
                          location: controller.listReport[index].address,
                          time: controller.listReport[index].time,
                          title: controller.listReport[index].title,
                          url:
                              '${ServerApp.url}${controller.listReport[index].urlImage}',
                          idReport: controller.listReport[index].idReport,
                          latitude: controller.listReport[index].latitude,
                          longitude: controller.listReport[index].longitude,
                          name: widget.name,
                          status: widget.status,
                        )
                      : (index == controller.listReport.length)
                          ? Center(
                              child: Column(
                              children: [
                                SizedBox(height: 10.h),
                                Text('Tidak ada laporan lagi'),
                              ],
                            ))
                          : Center(
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                ),
                              ),
                            ));
            }
          }),
    );
  }
}
