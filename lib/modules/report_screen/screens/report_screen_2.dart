import 'dart:async';
import 'package:aplikasi_rw/services/report_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../controller/report_user_controller.dart';
import '../../../controller/user_login_controller.dart';
import '../../../services/delete_report_services.dart';
import 'card_report_screen.dart';

//ignore: must_be_immutable
class ReportScreen2 extends StatefulWidget {
  @override
  State<ReportScreen2> createState() => _ReportScreen2State();
}

class _ReportScreen2State extends State<ReportScreen2> {
  // scroll controller
  ScrollController controller = ScrollController();

  // refresh key
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  TextEditingController controllerSearch = TextEditingController();

  // List<ReportModel> searchReport;
  // Timer _timer;
  ReportUserController reportController = Get.put(ReportUserController());

  UserLoginController loginController = Get.put(UserLoginController());

  void onScroll() async {
    if (controller.position.haveDimensions) {
      if (controller.position.maxScrollExtent == controller.position.pixels) {
        final logger = Logger();
        logger.w('update');
        reportController.getDataFromDb();
        reportController.update();
      }
    }
  }

  @override
  void initState() {
    super.initState();

    reportController.getDataFromDb();
    print('initstate');
    loginController.update();
  }

  @override
  void dispose() {
    controller.dispose();
    controllerSearch.clear();
    Get.delete<ReportUserController>();

    super.dispose();
  }

  @override
  didChangeDependencies() async {
    controller.addListener(onScroll);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Status Peduli Lingkungan',
        ),
        titleTextStyle: TextStyle(fontSize: 19.sp),
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
      ),
      body: RefreshIndicator(
        onRefresh: () async => loadReport(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Stack(children: [
              Container(
                width: 328.w,
                margin: EdgeInsets.symmetric(
                  horizontal: 16.w,
                ).copyWith(top: 16.h),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none),
                      hintText: 'Nomor Laporan',
                      hintStyle: TextStyle(fontSize: 14.sp),
                      suffixIcon: Icon(
                        Icons.search,
                      ),
                    ),
                    style: TextStyle(fontSize: 14.sp),
                    onChanged: (value) async {
                      if (value.isNotEmpty) {
                        reportController.listReport =
                            await ReportServices.search(value);
                        // reportController.update();
                        setState(() {});
                      } else {
                        reportController.listReport.clear();
                        reportController.refresReport().then((value) {
                          final logger = Logger();
                          logger.w(reportController.listReport[0].description);
                          logger.d(reportController.listReport.length);
                          FocusScope.of(context).requestFocus(FocusNode());
                          setState(() {});
                        });
                      }
                    },
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: 84.h,
                  ),
                  Obx(
                    () => (reportController.isLoading.value)
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: 7,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) => ShimmerReport(),
                          )
                        : ListView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: (reportController.isMaxReached.value)
                                ? reportController.listReport.length
                                : (reportController.listReport.length + 1),
                            itemBuilder: (context, index) => (reportController.listReport.length ==
                                    0)
                                ? Center(
                                    child: Text(
                                      'Tidak ada laporan',
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
                                  )
                                : (index < reportController.listReport.length)
                                    ? (reportController.listReport[index].idUser ==
                                            loginController.idUser.value)
                                        ? Slidable(
                                            // actionPane:
                                            //     SlidableDrawerActionPane(),
                                            enabled: true,
                                            endActionPane: ActionPane(
                                              motion: ScrollMotion(),
                                              children: [
                                                SlidableAction(
                                                  label: 'delete',
                                                  backgroundColor: Colors.red,
                                                  icon: Icons
                                                      .delete_forever_outlined,
                                                  onPressed: (_) {
                                                    String noTicket =
                                                        '${reportController.listReport[index].noTicket}';
                                                    DeleteReportServices.deleteReport(
                                                            idReport:
                                                                '${reportController.listReport[index].idReport}',
                                                            idUser:
                                                                loginController
                                                                    .idUser
                                                                    .value)
                                                        .then((status) {
                                                      if (status ==
                                                          'success delete') {
                                                        // delete dri list report
                                                        reportController
                                                            .listReport
                                                            .removeWhere((element) =>
                                                                element
                                                                    .idReport ==
                                                                reportController
                                                                    .listReport[
                                                                        index]
                                                                    .idReport);

                                                        EasyLoading.showInfo(
                                                            '$noTicket berhasil dihapus');
                                                        reportController
                                                            .refresReport();
                                                        reportController
                                                            .update();
                                                      } else if (status ==
                                                          'failed delete') {
                                                        EasyLoading.showError(
                                                            '$noTicket tidak bisa dihapus, karena bukan anda pembuat');
                                                      } else if (status ==
                                                          'can\'t delete') {
                                                        EasyLoading.showError(
                                                            'laporan tidak bisa dihapus jika sedang diproses atau selesai');
                                                      }
                                                    });
                                                  },
                                                )
                                              ],
                                            ),

                                            child: CardReportScreen(
                                                urlImageReport: reportController
                                                    .listReport[index]
                                                    .urlImageReport,
                                                description: reportController
                                                    .listReport[index]
                                                    .description,
                                                location: reportController
                                                    .listReport[index].location,
                                                noTicket: reportController
                                                    .listReport[index].noTicket,
                                                time: reportController
                                                    .listReport[index].time,
                                                status: reportController
                                                    .listReport[index].status,
                                                category: reportController
                                                    .listReport[index].category,
                                                categoryIcon: reportController
                                                    .listReport[index]
                                                    .iconCategory,
                                                latitude: reportController
                                                    .listReport[index].latitude,
                                                longitude: reportController
                                                    .listReport[index]
                                                    .longitude,
                                                idReport: reportController
                                                    .listReport[index].idReport,
                                                idUser: reportController
                                                    .listReport[index].idUser,
                                                dataKlasifikasi: reportController
                                                    .listReport[index]
                                                    .dataKlasifikasi,
                                                statusWorking: reportController
                                                    .listReport[index]
                                                    .statusWorking,
                                                photoComplete1: reportController
                                                    .listReport[index]
                                                    .photoComplete1,
                                                photoComplete2: reportController
                                                    .listReport[index]
                                                    .photoComplete2,
                                                photoProcess1: reportController
                                                    .listReport[index]
                                                    .photoProcess1,
                                                photoProcess2: reportController
                                                    .listReport[index]
                                                    .photoProcess2,
                                                star: reportController.listReport[index].star,
                                                comment: reportController.listReport[index].comment
                                                // additionalInformation: ,
                                                ),
                                          )
                                        : CardReportScreen(
                                            urlImageReport: reportController
                                                .listReport[index]
                                                .urlImageReport,
                                            description: reportController
                                                .listReport[index].description,
                                            location: reportController
                                                .listReport[index].location,
                                            noTicket: reportController
                                                .listReport[index].noTicket,
                                            time: reportController
                                                .listReport[index].time,
                                            status: reportController
                                                .listReport[index].status,
                                            category: reportController
                                                .listReport[index].category,
                                            categoryIcon: reportController
                                                .listReport[index].iconCategory,
                                            latitude: reportController
                                                .listReport[index].latitude,
                                            longitude: reportController
                                                .listReport[index].longitude,
                                            idReport: reportController
                                                .listReport[index].idReport,
                                            idUser: reportController
                                                .listReport[index].idUser,
                                            dataKlasifikasi: reportController
                                                .listReport[index]
                                                .dataKlasifikasi,
                                            statusWorking: reportController
                                                .listReport[index]
                                                .statusWorking,
                                            photoComplete1: reportController.listReport[index].photoComplete1,
                                            photoComplete2: reportController.listReport[index].photoComplete2,
                                            photoProcess1: reportController.listReport[index].photoProcess1,
                                            photoProcess2: reportController.listReport[index].photoProcess2,
                                            star: reportController.listReport[index].star,
                                            comment: reportController.listReport[index].comment
                                            // additionalInformation: ,
                                            )
                                    : (reportController.listReport.length <= 9)
                                        ? SizedBox()
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Future loadReport() async {
    reportController.refresReport();
    reportController.update();
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
