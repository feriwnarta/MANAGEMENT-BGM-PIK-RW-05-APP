import 'dart:async';
import 'package:aplikasi_rw/modules/theme/sizer.dart';
import 'package:aplikasi_rw/services/report_services.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
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
        title: const Text(
          'Status Peduli Lingkungan',
        ),
        titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: RefreshIndicator(
        onRefresh: () async => loadReport(),
        child: SafeArea(
          child: SingleChildScrollView(
            controller: controller,
            child: Stack(
              children: [
                Center(
                  child: Container(
                    width: SizeConfig.width(328),
                    height: SizeConfig.height(36),
                    margin: EdgeInsets.only(
                      top: SizeConfig.height(16),
                    ),
                    child: Card(
                      margin: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: (12 / Sizer.slicingWidth) *
                                SizeConfig.heightMultiplier,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Nomor Laporan',
                          hintStyle: TextStyle(
                            fontSize: SizeConfig.text(14),
                          ),
                          suffixIcon: Icon(
                            Icons.search,
                            size: (16 / Sizer.slicingImage) *
                                SizeConfig.imageSizeMultiplier,
                          ),
                        ),
                        style: TextStyle(fontSize: SizeConfig.text(12)),
                        onChanged: (value) async {
                          if (value.isNotEmpty) {
                            reportController.listReport =
                                await ReportServices.search(value);
                            setState(() {});
                          } else {
                            reportController.listReport.clear();
                            await reportController.refresReport();
                            final logger = Logger();
                            logger
                                .w(reportController.listReport[0].description);
                            logger.d(reportController.listReport.length);
                            FocusScope.of(context).requestFocus(FocusNode());
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: SizeConfig.width(328),
                    child: Column(
                      children: [
                        SizedBox(
                          height: (68 / Sizer.slicingHeight) *
                              SizeConfig.heightMultiplier,
                        ),
                        Obx(
                          () => (reportController.isLoading.value)
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
                                  itemCount: (reportController
                                          .isMaxReached.value)
                                      ? reportController.listReport.length
                                      : (reportController.listReport.length +
                                          1),
                                  itemBuilder: (context, index) {
                                    if (reportController.listReport.length ==
                                        0) {
                                      return Center(
                                        child: Text(
                                          'Tidak ada laporan',
                                          style: TextStyle(
                                            fontSize: SizeConfig.text(12),
                                          ),
                                        ),
                                      );
                                    } else if (index <
                                        reportController.listReport.length) {
                                      final currentReport =
                                          reportController.listReport[index];
                                      return (currentReport.idUser ==
                                              loginController.idUser.value)
                                          ? Slidable(
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
                                                          '${currentReport.noTicket}';
                                                      DeleteReportServices
                                                          .deleteReport(
                                                        idReport:
                                                            '${currentReport.idReport}',
                                                        idUser: loginController
                                                            .idUser.value,
                                                      ).then((status) {
                                                        if (status ==
                                                            'success delete') {
                                                          reportController
                                                              .listReport
                                                              .removeWhere((element) =>
                                                                  element
                                                                      .idReport ==
                                                                  currentReport
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
                                                              '$noTicket tidak bisa dihapus, karena bukan pembuat laporan');
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
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    bottom:
                                                        SizeConfig.height(10)),
                                                child: CardReportScreen(
                                                  urlImageReport: currentReport
                                                      .urlImageReport,
                                                  description:
                                                      currentReport.description,
                                                  location:
                                                      currentReport.location,
                                                  noTicket:
                                                      currentReport.noTicket,
                                                  time: currentReport.time,
                                                  status: currentReport.status,
                                                  category:
                                                      currentReport.category,
                                                  categoryIcon: currentReport
                                                      .iconCategory,
                                                  latitude:
                                                      currentReport.latitude,
                                                  longitude:
                                                      currentReport.longitude,
                                                  idReport:
                                                      currentReport.idReport,
                                                  idUser: currentReport.idUser,
                                                  dataKlasifikasi: currentReport
                                                      .dataKlasifikasi,
                                                  statusWorking: currentReport
                                                      .statusWorking,
                                                  photoComplete1: currentReport
                                                      .photoComplete1,
                                                  photoComplete2: currentReport
                                                      .photoComplete2,
                                                  photoProcess1: currentReport
                                                      .photoProcess1,
                                                  photoProcess2: currentReport
                                                      .photoProcess2,
                                                  star: currentReport.star,
                                                  comment:
                                                      currentReport.comment,
                                                ),
                                              ),
                                            )
                                          : Padding(
                                              padding: EdgeInsets.only(
                                                  bottom:
                                                      SizeConfig.height(10)),
                                              child: CardReportScreen(
                                                urlImageReport: currentReport
                                                    .urlImageReport,
                                                description:
                                                    currentReport.description,
                                                location:
                                                    currentReport.location,
                                                noTicket:
                                                    currentReport.noTicket,
                                                time: currentReport.time,
                                                status: currentReport.status,
                                                category:
                                                    currentReport.category,
                                                categoryIcon:
                                                    currentReport.iconCategory,
                                                latitude:
                                                    currentReport.latitude,
                                                longitude:
                                                    currentReport.longitude,
                                                idReport:
                                                    currentReport.idReport,
                                                idUser: currentReport.idUser,
                                                dataKlasifikasi: currentReport
                                                    .dataKlasifikasi,
                                                statusWorking:
                                                    currentReport.statusWorking,
                                                photoComplete1: currentReport
                                                    .photoComplete1,
                                                photoComplete2: currentReport
                                                    .photoComplete2,
                                                photoProcess1:
                                                    currentReport.photoProcess1,
                                                photoProcess2:
                                                    currentReport.photoProcess2,
                                                star: currentReport.star,
                                                comment: currentReport.comment,
                                              ),
                                            );
                                    } else if (reportController
                                            .listReport.length <=
                                        9) {
                                      return SizedBox();
                                    } else {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: (30 / Sizer.slicingWidth) *
                                                SizeConfig.widthMultiplier,
                                            height: (30 / Sizer.slicingHeight) *
                                                SizeConfig.heightMultiplier,
                                            child: CircularProgressIndicator
                                                .adaptive(),
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
      margin: EdgeInsets.symmetric(
          vertical: (16 / Sizer.slicingHeight) * SizeConfig.heightMultiplier),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: SizeConfig.height(2)),
              Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[200],
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10)),
                    width: SizeConfig.width(70),
                    height: SizeConfig.width(70),
                    // margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  )),
            ],
          ),
          // shimmer title
          SizedBox(
            width: SizeConfig.width(16),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: SizeConfig.height(1)),
              Row(
                children: [
                  Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[200],
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10)),
                        width: SizeConfig.width(100),
                        height: SizeConfig.height(12),
                      )),
                  SizedBox(
                    width: SizeConfig.width(34),
                  ),
                  Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[200],
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10)),
                        width: SizeConfig.width(78),
                        height: SizeConfig.height(12),
                      )),
                ],
              ),
              SizedBox(
                height: SizeConfig.height(4),
              ),
              Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[200],
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10)),
                    width: SizeConfig.width(150),
                    height: SizeConfig.height(12),
                  )),
              SizedBox(
                height: SizeConfig.height(4),
              ),
              Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[200],
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10)),
                    width: SizeConfig.width(75),
                    height: SizeConfig.height(12),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
