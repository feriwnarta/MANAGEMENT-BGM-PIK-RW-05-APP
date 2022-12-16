import 'dart:async';
import 'package:aplikasi_rw/screen/report_screen2/card_report_screen.dart';
import 'package:aplikasi_rw/screen/report_screen2/finished_report_scren.dart';
import 'package:aplikasi_rw/screen/report_screen2/sub_menu_report.dart';
import 'package:aplikasi_rw/services/report_finished_services.dart';
import 'package:aplikasi_rw/services/report_services.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';
import '../../controller/report_user_controller.dart';
import '../../services/delete_report_services.dart';
import '../../controller/user_login_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//ignore: must_be_immutable
class ReportScreen2 extends StatefulWidget {
  @override
  State<ReportScreen2> createState() => _ReportScreen2State();
}

class _ReportScreen2State extends State<ReportScreen2> {
  // scroll controller
  ScrollController controller = ScrollController();
  Future _future;

  // refresh key
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  TextEditingController controllerSearch = TextEditingController();

  // List<ReportModel> searchReport;
  // Timer _timer;
  ReportUserController reportController = Get.put(ReportUserController());

  final loginController = Get.put(UserLoginController());

  void onScroll() async {
    if (controller.position.haveDimensions) {
      // if (controller.position.maxScrollExtent == controller.position.pixels) {
      //   final logger = Logger();
      //   logger.w('update');
      //   reportController.getDataFromDb();
      //   reportController.update();
      // }
      if (controller.offset >= controller.position.maxScrollExtent &&
          !controller.position.outOfRange) {
        final logger = Logger();
        logger.w('botoom');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _future = ReportFinishedServices.getDataApi();
  }

  @override
  void dispose() {
    // if (_timer.isActive) _timer.cancel();
    controller.dispose();
    controllerSearch.clear();
    // Get.delete<ReportUserController>();

    super.dispose();
  }

  @override
  didChangeDependencies() async {
    // controller.addListener(onScroll);
    // _timer = Timer.periodic(Duration(seconds: 5), (timer) {
    // context.read<ReportBloc>().add(ReportEventRefresh());
    // print(timer);
    // reportController.realtimeData();
    // });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => loadReport(),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              expandedHeight: 120.h,
              // floating: true,
              // leadingWidth: 400.w,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Row(children: [
                  SizedBox(
                    width: 16.w,
                  ),
                  Text(
                    'Riwayat keluhan',
                    style: TextStyle(
                      fontSize: 19.sp,
                      color: Color(0xff2094F3),
                    ),
                  ),
                  SizedBox(
                    width: 161.w,
                  ),
                  FutureBuilder<List<ReportFinishedModel>>(
                      future: _future,
                      builder: (context, snapshot) => (snapshot.hasData)
                          ? GestureDetector(
                              onTap: () {
                                if (snapshot.data != null) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => FinishedReportScreen(
                                      report: snapshot.data,
                                    ),
                                  ));
                                } else {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => FinishedReportScreen(
                                      report: [],
                                    ),
                                  ));
                                }
                              },
                              child: Badge(
                                badgeColor: Colors.red,
                                badgeContent: (snapshot.data != null &&
                                        snapshot.data.isNotEmpty)
                                    ? Text(
                                        snapshot.data[0].total,
                                        style: TextStyle(color: Colors.white),
                                      )
                                    : Text(
                                        '0',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                position:
                                    BadgePosition.topEnd(top: -15, end: -10),
                                child: Icon(
                                  Icons.notifications,
                                  color: Colors.black,
                                ),
                                animationType: BadgeAnimationType.scale,
                              ),
                            )
                          : Badge(
                              badgeColor: Colors.red,
                              badgeContent: Text(
                                '0',
                                style: TextStyle(color: Colors.white),
                              ),
                              position:
                                  BadgePosition.topEnd(top: -17, end: -17),
                              child: Icon(
                                Icons.notifications,
                                color: Color(0xff404040),
                              ),
                              animationType: BadgeAnimationType.scale,
                            )),
                ]),
                titlePadding:
                    EdgeInsets.only(top: 17.h, left: 16.w, right: 16.w),
                title: SizedBox(
                  width: 340.w,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 2,
                    child: TextField(
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 2.h, horizontal: 12.w),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide.none),
                          hintText: 'Nomor Laporan',
                          suffixIcon: Icon(
                            Icons.search,
                          )),
                      style: TextStyle(fontSize: 14.sp),
                      onChanged: (value) async {
                        if (value.isNotEmpty) {
                          reportController.listReport =
                              await ReportServices.search(value);
                          // reportController.update();
                          setState(() {});
                        } else {
                          // setState(() {
                          // reportController.searchReport = null;
                          // reportController.isLoading = true.obs;
                          // reportController.listReport.clear();
                          // reportController.getDataFromDb();
                          reportController.listReport.clear();
                          reportController.refresReport().then((value) {
                            final logger = Logger();
                            logger
                                .w(reportController.listReport[0].description);
                            logger.d(reportController.listReport.length);
                            FocusScope.of(context).requestFocus(FocusNode());
                            setState(() {});
                          });
                          // });
                        }
                      },
                    ),
                  ),
                ),
                expandedTitleScale: 1.0,
                // expandedTitleScale: 20,
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification.metrics.maxScrollExtent >
                              notification.metrics.pixels &&
                          notification.metrics.maxScrollExtent -
                                  notification.metrics.pixels <=
                              60.0) {
                        reportController.getDataFromDb();
                      }
                      return false;
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 32.h,
                          ),
                          GetBuilder<ReportUserController>(
                            init: ReportUserController(),
                            initState: (state) =>
                                reportController.getDataFromDb(),
                            builder: (controller) =>
                                (controller.isLoading.value)
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: 7,
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index) =>
                                            ShimmerReport(),
                                      )
                                    : ListView.builder(
                                        physics: ScrollPhysics(),
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        itemCount: (controller
                                                .isMaxReached.value)
                                            ? controller.listReport.length
                                            : (controller.listReport.length +
                                                1),
                                        itemBuilder: (context, index) => (controller
                                                    .listReport.length ==
                                                0)
                                            ? Center(
                                                child: Text(
                                                'No reports',
                                                style:
                                                    TextStyle(fontSize: 12.sp),
                                              ))
                                            : (index <
                                                    controller
                                                        .listReport.length)
                                                ? (controller.listReport[index].idUser ==
                                                        loginController
                                                            .idUser.value)
                                                    ? Slidable(
                                                        // actionPane:
                                                        //     SlidableDrawerActionPane(),
                                                        enabled: true,
                                                        endActionPane:
                                                            ActionPane(
                                                          motion:
                                                              ScrollMotion(),
                                                          children: [
                                                            SlidableAction(
                                                              label: 'delete',
                                                              backgroundColor:
                                                                  Colors.red,
                                                              icon: Icons
                                                                  .delete_forever_outlined,
                                                              onPressed: (_) {
                                                                String
                                                                    noTicket =
                                                                    '${controller.listReport[index].noTicket}';
                                                                DeleteReportServices.deleteReport(
                                                                        idReport:
                                                                            '${controller.listReport[index].idReport}',
                                                                        idUser: loginController
                                                                            .idUser
                                                                            .value)
                                                                    .then(
                                                                        (status) {
                                                                  if (status ==
                                                                      'success delete') {
                                                                    // delete dri list report
                                                                    controller.listReport.removeWhere((element) =>
                                                                        element
                                                                            .idReport ==
                                                                        controller
                                                                            .listReport[index]
                                                                            .idReport);
                                                                    // Get.snackbar(
                                                                    //     'Message',
                                                                    //     '$noTicket delete',
                                                                    //     backgroundColor:
                                                                    //         Colors.blue,
                                                                    //     colorText:
                                                                    //         Colors
                                                                    //             .white,
                                                                    //     overlayBlur: 2);
                                                                    EasyLoading
                                                                        .showInfo(
                                                                            '$noTicket berhasil dihapus');
                                                                    reportController
                                                                        .refresReport();
                                                                    reportController
                                                                        .update();
                                                                  } else if (status ==
                                                                      'failed delete') {
                                                                    // Get.snackbar(
                                                                    //     'Message',
                                                                    //     '$noTicket can\'t delete',
                                                                    //     backgroundColor:
                                                                    //         Colors.blue,
                                                                    //     colorText:
                                                                    //         Colors
                                                                    //             .white,
                                                                    //     overlayBlur: 2);
                                                                    EasyLoading
                                                                        .showError(
                                                                            '$noTicket tidak bisa dihapus, karena bukan anda pembuat');
                                                                  } else if (status ==
                                                                      'can\'t delete') {
                                                                    // Get.snackbar(
                                                                    //     'Message',
                                                                    //     'can\'t delete the report if it\'s beeing processed or finish',
                                                                    //     backgroundColor:
                                                                    //         Colors.blue,
                                                                    //     colorText:
                                                                    //         Colors
                                                                    //             .white,
                                                                    //     overlayBlur: 2);
                                                                    EasyLoading
                                                                        .showError(
                                                                            'laporan tidak bisa dihapus jika sedang diproses atau selesai');
                                                                  }
                                                                });
                                                              },
                                                            )
                                                          ],
                                                        ),

                                                        child: CardReportScreen(
                                                            urlImageReport:
                                                                controller
                                                                    .listReport[
                                                                        index]
                                                                    .urlImageReport,
                                                            description:
                                                                controller
                                                                    .listReport[
                                                                        index]
                                                                    .description,
                                                            location: controller
                                                                .listReport[
                                                                    index]
                                                                .location,
                                                            noTicket: controller
                                                                .listReport[
                                                                    index]
                                                                .noTicket,
                                                            time: controller
                                                                .listReport[
                                                                    index]
                                                                .time,
                                                            status: controller
                                                                .listReport[
                                                                    index]
                                                                .status,
                                                            category: controller
                                                                .listReport[
                                                                    index]
                                                                .category,
                                                            categoryIcon: controller
                                                                .listReport[
                                                                    index]
                                                                .iconCategory,
                                                            latitude: controller
                                                                .listReport[
                                                                    index]
                                                                .latitude,
                                                            longitude:
                                                                controller
                                                                    .listReport[
                                                                        index]
                                                                    .longitude,
                                                            idReport: controller
                                                                .listReport[
                                                                    index]
                                                                .idReport,
                                                            idUser: controller
                                                                .listReport[
                                                                    index]
                                                                .idUser,
                                                            dataKlasifikasi: controller
                                                                .listReport[
                                                                    index]
                                                                .dataKlasifikasi,
                                                            statusWorking: controller
                                                                .listReport[index]
                                                                .statusWorking,
                                                            photoComplete1: controller.listReport[index].photoComplete1,
                                                            photoComplete2: controller.listReport[index].photoComplete2,
                                                            photoProcess1: controller.listReport[index].photoProcess1,
                                                            photoProcess2: controller.listReport[index].photoProcess2,
                                                            star: controller.listReport[index].star,
                                                            comment: controller.listReport[index].comment
                                                            // additionalInformation: ,
                                                            ),
                                                      )
                                                    : CardReportScreen(
                                                        urlImageReport: controller
                                                            .listReport[index]
                                                            .urlImageReport,
                                                        description: controller.listReport[index].description,
                                                        location: controller.listReport[index].location,
                                                        noTicket: controller.listReport[index].noTicket,
                                                        time: controller.listReport[index].time,
                                                        status: controller.listReport[index].status,
                                                        category: controller.listReport[index].category,
                                                        categoryIcon: controller.listReport[index].iconCategory,
                                                        latitude: controller.listReport[index].latitude,
                                                        longitude: controller.listReport[index].longitude,
                                                        idReport: controller.listReport[index].idReport,
                                                        idUser: controller.listReport[index].idUser,
                                                        dataKlasifikasi: controller.listReport[index].dataKlasifikasi,
                                                        statusWorking: controller.listReport[index].statusWorking,
                                                        photoComplete1: controller.listReport[index].photoComplete1,
                                                        photoComplete2: controller.listReport[index].photoComplete2,
                                                        photoProcess1: controller.listReport[index].photoProcess1,
                                                        photoProcess2: controller.listReport[index].photoProcess2,
                                                        star: controller.listReport[index].star,
                                                        comment: controller.listReport[index].comment
                                                        // additionalInformation: ,
                                                        )
                                                : (controller.listReport.length <= 9)
                                                    ? SizedBox()
                                                    : Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            width: 30,
                                                            height: 30,
                                                            child:
                                                                CircularProgressIndicator(),
                                                          ),
                                                        ],
                                                      ),
                                      ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        child: Icon(
          Icons.add,
          size: 20.h,
        ),
        onPressed: () {
          // Navigator.of(context)
          //     .push(MaterialPageRoute(
          //   builder: (context) => AddReport(),
          // ))
          //     .then((value) {
          //   if (value == 'reload') {
          //     bloc.add(ReportEventRefresh());
          //   }
          // });
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => SubMenuReport(),
          ));
          //     .then((value) {
          //   if (value == 'reload') {
          //     bloc.add(ReportEventRefresh());
          //     _future = ReportFinishedServices.getDataApi();
          //   }
          // });
        },
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Stack(children: [
  //     Scaffold(
  //       resizeToAvoidBottomInset: false,
  //       // resizeToAvoidBottomPadding: false,
  //       body: SafeArea(
  //         child: NestedScrollView(
  //             controller: controller,
  //             headerSliverBuilder: (context, innerBoxIsScrolled) => [
  //                   SliverAppBar(
  //                     backgroundColor: Colors.red,
  //                     expandedHeight: 120.h,
  //                     pinned: true,
  //                     bottom: PreferredSize(
  //                       preferredSize: const Size.fromHeight(0),
  //                       child: Container(
  //                         padding: EdgeInsets.symmetric(horizontal: 1.5.w),
  //                         height: 36.h,
  //                         child: TextField(
  //                           keyboardType: TextInputType.datetime,
  //                           maxLines: 1,
  //                           decoration: InputDecoration(
  //                               contentPadding: EdgeInsets.only(top: 1.2.h),
  //                               prefixIcon: Icon(
  //                                 Icons.search,
  //                                 size: 2.5.h,
  //                               ),
  //                               fillColor: Colors.grey[50],
  //                               filled: true,
  //                               hintText: 'Nomor laporan',
  //                               hintStyle: TextStyle(
  //                                 fontSize: 11.0.sp,
  //                               ),
  //                               focusedBorder: OutlineInputBorder(
  //                                   borderRadius: BorderRadius.circular(10),
  //                                   borderSide:
  //                                       BorderSide(color: Colors.grey[300])),
  //                               enabledBorder: OutlineInputBorder(
  //                                   borderRadius: BorderRadius.circular(10),
  //                                   borderSide:
  //                                       BorderSide(color: Colors.grey[300])),
  //                               border: OutlineInputBorder(
  //                                 borderRadius: BorderRadius.circular(10),
  //                               )),
  //                           onChanged: (value) async {
  //                             if (value.isNotEmpty) {
  //                               reportController.listReport =
  //                                   await ReportServices.search(value);
  //                               // reportController.update();
  //                               setState(() {});
  //                             } else {
  //                               // setState(() {
  //                               // reportController.searchReport = null;
  //                               // reportController.isLoading = true.obs;
  //                               // reportController.listReport.clear();
  //                               // reportController.getDataFromDb();
  //                               reportController.listReport.clear();
  //                               reportController.refresReport().then((value) {
  //                                 final logger = Logger();
  //                                 logger.w(reportController
  //                                     .listReport[0].description);
  //                                 logger.d(reportController.listReport.length);
  //                                 FocusScope.of(context)
  //                                     .requestFocus(FocusNode());
  //                                 setState(() {});
  //                               });
  //                               // });
  //                             }
  //                           },
  //                         ),
  //                       ),
  //                     ),
  //                     flexibleSpace: FlexibleSpaceBar(
  //                       background: Container(
  //                         margin: EdgeInsets.only(bottom: 6.0.h),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           children: [
  //                             SizedBox(
  //                               width: 16.w,
  //                             ),
  //                             Text(
  //                               'Riwayat keluhan',
  //                               style: TextStyle(
  //                                   fontSize: 19.sp, color: Color(0xff485E88)),
  //                             ),
  //                             SizedBox(width: 161.w),
  //                             FutureBuilder<List<ReportFinishedModel>>(
  //                                 future: _future,
  //                                 builder: (context, snapshot) => (snapshot
  //                                         .hasData)
  //                                     ? GestureDetector(
  //                                         onTap: () {
  //                                           if (snapshot.data != null) {
  //                                             Navigator.of(context)
  //                                                 .push(MaterialPageRoute(
  //                                               builder: (context) =>
  //                                                   FinishedReportScreen(
  //                                                 report: snapshot.data,
  //                                               ),
  //                                             ));
  //                                           } else {
  //                                             Navigator.of(context)
  //                                                 .push(MaterialPageRoute(
  //                                               builder: (context) =>
  //                                                   FinishedReportScreen(
  //                                                 report: [],
  //                                               ),
  //                                             ));
  //                                           }
  //                                         },
  //                                         child: Badge(
  //                                           badgeColor: Colors.red,
  //                                           badgeContent: (snapshot.data !=
  //                                                       null &&
  //                                                   snapshot.data.isNotEmpty)
  //                                               ? Text(
  //                                                   snapshot.data[0].total,
  //                                                   style: TextStyle(
  //                                                       color: Colors.white),
  //                                                 )
  //                                               : Text(
  //                                                   '0',
  //                                                   style: TextStyle(
  //                                                       color: Colors.white),
  //                                                 ),
  //                                           position: BadgePosition.topEnd(
  //                                               top: -15, end: -10),
  //                                           child: Icon(
  //                                             Icons.notifications,
  //                                             color: Colors.indigo,
  //                                           ),
  //                                           animationType:
  //                                               BadgeAnimationType.scale,
  //                                         ),
  //                                       )
  //                                     : Badge(
  //                                         badgeColor: Colors.red,
  //                                         badgeContent: Text(
  //                                           '0',
  //                                           style:
  //                                               TextStyle(color: Colors.white),
  //                                         ),
  //                                         position: BadgePosition.topEnd(
  //                                             top: -17, end: -17),
  //                                         child: Icon(
  //                                           Icons.notifications,
  //                                           color: Colors.indigo,
  //                                         ),
  //                                         animationType:
  //                                             BadgeAnimationType.scale,
  //                                       )),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //             body: RefreshIndicator(
  //               key: refreshIndicatorKey,
  //               onRefresh: () async => loadReport(),
  //               child: NotificationListener<ScrollNotification>(
  //                 onNotification: (notification) {
  //                   if (notification.metrics.maxScrollExtent >
  //                           notification.metrics.pixels &&
  //                       notification.metrics.maxScrollExtent -
  //                               notification.metrics.pixels <=
  //                           60.0) {
  //                     reportController.getDataFromDb();
  //                   }
  //                   return false;
  //                 },
  //                 child: SingleChildScrollView(
  //                   child: Column(
  //                     children: [
  //                       Divider(
  //                         color: Colors.black,
  //                         height: 3.0.h,
  //                         thickness: 0.3,
  //                       ),
  //                       GetBuilder<ReportUserController>(
  //                           init: ReportUserController(),
  //                           initState: (state) =>
  //                               reportController.getDataFromDb(),
  //                           builder: (controller) => (controller
  //                                   .isLoading.value)
  //                               ? ListView.builder(
  //                                   shrinkWrap: true,
  //                                   itemCount: 5,
  //                                   itemBuilder: (context, index) =>
  //                                       ShimmerReport(),
  //                                 )
  //                               : ListView.builder(
  //                                   physics: ScrollPhysics(),
  //                                   shrinkWrap: true,
  //                                   itemCount: (controller.isMaxReached.value)
  //                                       ? controller.listReport.length
  //                                       : (controller.listReport.length + 1),
  //                                   itemBuilder: (context, index) => (controller
  //                                               .listReport.length ==
  //                                           0)
  //                                       ? Center(
  //                                           child: Text(
  //                                           'No reports',
  //                                           style: TextStyle(fontSize: 12.sp),
  //                                         ))
  //                                       : (index < controller.listReport.length)
  //                                           ? Slidable(
  //                                               // actionPane:
  //                                               //     SlidableDrawerActionPane(),
  //                                               enabled: true,
  //                                               endActionPane: ActionPane(
  //                                                 motion: ScrollMotion(),
  //                                                 children: [
  //                                                   SlidableAction(
  //                                                     label: 'delete',
  //                                                     backgroundColor:
  //                                                         Colors.red,
  //                                                     icon: Icons
  //                                                         .delete_forever_outlined,
  //                                                     onPressed: (_) {
  //                                                       String noTicket =
  //                                                           '${controller.listReport[index].noTicket}';
  //                                                       DeleteReportServices.deleteReport(
  //                                                               idReport:
  //                                                                   '${controller.listReport[index].idReport}',
  //                                                               idUser:
  //                                                                   loginController
  //                                                                       .idUser
  //                                                                       .value)
  //                                                           .then((status) {
  //                                                         if (status ==
  //                                                             'success delete') {
  //                                                           // delete dri list report
  //                                                           controller.listReport
  //                                                               .removeWhere((element) =>
  //                                                                   element
  //                                                                       .idReport ==
  //                                                                   controller
  //                                                                       .listReport[
  //                                                                           index]
  //                                                                       .idReport);
  //                                                           Get.snackbar(
  //                                                               'Message',
  //                                                               '$noTicket delete',
  //                                                               backgroundColor:
  //                                                                   Colors.blue,
  //                                                               colorText:
  //                                                                   Colors
  //                                                                       .white,
  //                                                               overlayBlur: 2);
  //                                                           reportController
  //                                                               .refresReport();
  //                                                           reportController
  //                                                               .update();
  //                                                         } else if (status ==
  //                                                             'failed delete') {
  //                                                           Get.snackbar(
  //                                                               'Message',
  //                                                               '$noTicket can\'t delete',
  //                                                               backgroundColor:
  //                                                                   Colors.blue,
  //                                                               colorText:
  //                                                                   Colors
  //                                                                       .white,
  //                                                               overlayBlur: 2);
  //                                                         } else if (status ==
  //                                                             'can\'t delete') {
  //                                                           Get.snackbar(
  //                                                               'Message',
  //                                                               'can\'t delete the report if it\'s beeing processed or finish',
  //                                                               backgroundColor:
  //                                                                   Colors.blue,
  //                                                               colorText:
  //                                                                   Colors
  //                                                                       .white,
  //                                                               overlayBlur: 2);
  //                                                         }
  //                                                       });
  //                                                     },
  //                                                   )
  //                                                 ],
  //                                               ),

  //                                               child: CardReportScreen(
  //                                                   urlImageReport: controller
  //                                                       .listReport[index]
  //                                                       .urlImageReport,
  //                                                   description: controller
  //                                                       .listReport[index]
  //                                                       .description,
  //                                                   location: controller
  //                                                       .listReport[index]
  //                                                       .location,
  //                                                   noTicket: controller
  //                                                       .listReport[index]
  //                                                       .noTicket,
  //                                                   time: controller
  //                                                       .listReport[index].time,
  //                                                   status: controller
  //                                                       .listReport[index]
  //                                                       .status,
  //                                                   category: controller
  //                                                       .listReport[index]
  //                                                       .category,
  //                                                   categoryIcon: controller
  //                                                       .listReport[index]
  //                                                       .iconCategory,
  //                                                   latitude: controller
  //                                                       .listReport[index]
  //                                                       .latitude,
  //                                                   longitude: controller
  //                                                       .listReport[index]
  //                                                       .longitude,
  //                                                   idReport: controller
  //                                                       .listReport[index]
  //                                                       .idReport,
  //                                                   idUser: controller
  //                                                       .listReport[index]
  //                                                       .idUser,
  //                                                   dataKlasifikasi: controller
  //                                                       .listReport[index]
  //                                                       .dataKlasifikasi,
  //                                                   statusWorking: controller
  //                                                       .listReport[index]
  //                                                       .statusWorking,
  //                                                   photoComplete1: controller
  //                                                       .listReport[index]
  //                                                       .photoComplete1,
  //                                                   photoComplete2: controller
  //                                                       .listReport[index]
  //                                                       .photoComplete2,
  //                                                   photoProcess1: controller
  //                                                       .listReport[index]
  //                                                       .photoProcess1,
  //                                                   photoProcess2: controller
  //                                                       .listReport[index]
  //                                                       .photoProcess2,
  //                                                   star: controller
  //                                                       .listReport[index].star,
  //                                                   comment: controller
  //                                                       .listReport[index]
  //                                                       .comment
  //                                                   // additionalInformation: ,
  //                                                   ),
  //                                             )
  //                                           : (controller.listReport.length <=
  //                                                   9)
  //                                               ? SizedBox()
  //                                               : Row(
  //                                                   mainAxisAlignment:
  //                                                       MainAxisAlignment
  //                                                           .center,
  //                                                   children: [
  //                                                     Container(
  //                                                       width: 30,
  //                                                       height: 30,
  //                                                       child:
  //                                                           CircularProgressIndicator(),
  //                                                     ),
  //                                                   ],
  //                                                 )))
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             )),
  //       ),
  //       floatingActionButton: FloatingActionButton(
  //         child: Icon(
  //           Icons.add,
  //           size: 4.0.h,
  //         ),
  //         onPressed: () {
  //           // Navigator.of(context)
  //           //     .push(MaterialPageRoute(
  //           //   builder: (context) => AddReport(),
  //           // ))
  //           //     .then((value) {
  //           //   if (value == 'reload') {
  //           //     bloc.add(ReportEventRefresh());
  //           //   }
  //           // });
  //           Navigator.of(context).push(MaterialPageRoute(
  //             builder: (_) => SubMenuReport(),
  //           ));
  //           //     .then((value) {
  //           //   if (value == 'reload') {
  //           //     bloc.add(ReportEventRefresh());
  //           //     _future = ReportFinishedServices.getDataApi();
  //           //   }
  //           // });
  //         },
  //       ),
  //     ),
  //     Container()
  //   ]);
  // }

  Future loadReport() async {
    // await Future.delayed(Duration(seconds: 1));
    // final logger = Logger();
    // logger.e('user adalah kami');
    // bloc.add(ReportEventRefresh());
    reportController.refresReport();
    reportController.update();
    _future = ReportFinishedServices.getDataApi();
  }
}

class ShimmerReport extends StatelessWidget {
  const ShimmerReport({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.0.h),
              Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[200],
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10)),
                    width: 70.w,
                    height: 70.h,
                    // margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  )),
            ],
          ),
          // shimmer title
          SizedBox(
            width: 16.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.0.h),
              Row(
                children: [
                  Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[200],
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10)),
                        width: 100.w,
                        height: 12.h,
                      )),
                  SizedBox(
                    width: 34.w,
                  ),
                  Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[200],
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10)),
                        width: 78.w,
                        height: 12.h,
                      )),
                ],
              ),
              SizedBox(
                height: 4.h,
              ),
              Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[200],
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10)),
                    width: 150.w,
                    height: 12.h,
                  )),
              SizedBox(
                height: 4.h,
              ),
              Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[200],
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10)),
                    width: 75.w,
                    height: 12.h,
                  )),
            ],
          )
        ],
      ),
    );
  }
}
