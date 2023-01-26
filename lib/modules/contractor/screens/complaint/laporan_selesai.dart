import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controller/report_cordinator_finish.dart';
import '../../../../server-app.dart';
import 'laporan_masuk.dart';

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
    timer = Timer.periodic(Duration(seconds: 1), (second) {
      controller.realtimeData();
    });
    controller.scrollcontroller.addListener(onScroll);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan Selesai'),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: GetX<ReportCordinatorFinish>(
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
                  itemBuilder: (context, index) => (controller
                              .listReport.length ==
                          0)
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 20.h),
                            child: Text(
                              'Tidak ada laporan yang selesai dikerjakan',
                            ),
                          ),
                        )
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
                              status: null,
                            )
                          : (index == controller.listReport.length)
                              ? SizedBox()
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
