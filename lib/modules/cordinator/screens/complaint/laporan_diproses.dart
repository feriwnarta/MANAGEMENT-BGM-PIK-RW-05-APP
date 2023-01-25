import 'dart:async';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../controller/report_cordinator_process.dart';
import '../../../../server-app.dart';
import 'laporan_masuk.dart';

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
    timer = Timer.periodic(Duration(seconds: 1), (second) {
      controllerReportProcess.realtimeData();
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan Diproses'),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: GetX<ReportCordinatorProcess>(
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
                  itemBuilder: (context, index) => (controller
                              .listReport.length ==
                          0)
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 20.h),
                            child: Text('Tidak ada laporan yang diproses'),
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
                              status: '',
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
