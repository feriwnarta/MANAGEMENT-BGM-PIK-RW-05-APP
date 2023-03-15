import 'dart:async';
import 'package:aplikasi_rw/modules/cordinator/controller/cordinator_controller.dart';
import 'package:aplikasi_rw/modules/manager_contractor/screens/laporan_masuk_manager_con.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../server-app.dart';

//ignore: must_be_immutable
class LaporanDiprosesCordinator extends StatefulWidget {
  LaporanDiprosesCordinator({Key key, this.name, this.status})
      : super(key: key);

  String name, status;

  @override
  _CardReportProcessState createState() => _CardReportProcessState();
}

class _CardReportProcessState extends State<LaporanDiprosesCordinator>
    with AutomaticKeepAliveClientMixin {
  Timer timer;
  final controllerReportProcess = Get.put(CordinatorController());

  void onScroll() {
    if (controllerReportProcess.scrollcontroller.position.maxScrollExtent ==
        controllerReportProcess.scrollcontroller.position.pixels) {
      controllerReportProcess.getComplaintDiproses();
    }
  }

  @override
  void dispose() {
    print('dispose 2');
    if (timer.isActive) {
      timer.cancel();
    }
    Get.delete<CordinatorController>();
    super.dispose();
  }

  @override
  didChangeDependencies() async {
    super.didChangeDependencies();
    controllerReportProcess.scrollcontroller.addListener(onScroll);
    timer = Timer.periodic(Duration(seconds: 1), (second) {
      controllerReportProcess.realTimeComplaintDiproses();
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.width(16),
              vertical: SizeConfig.height(16)),
          child: Column(
            children: [
              Text(
                'Jumlah laporan yang masuk dan sedang diproses oleh kontraktor lapangan.',
                style: TextStyle(
                  fontSize: SizeConfig.text(16),
                  color: Color(0xff616161),
                ),
                maxLines: 2,
              ),
              SizedBox(
                height: SizeConfig.height(32),
              ),
              GetX<CordinatorController>(
                  init: CordinatorController(),
                  initState: (state) =>
                      controllerReportProcess.getComplaintDiproses(),
                  builder: (controller) {
                    if (controller.isLoading.value) {
                      return Center(
                        child: SizedBox(
                            height: SizeConfig.height(30),
                            width: SizeConfig.width(30),
                            child: CircularProgressIndicator()),
                      );
                    } else {
                      return ListView.builder(
                        controller: controllerReportProcess.scrollcontroller,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: (controller.isMaxReached.value)
                            ? controller.listReport.length + 1
                            : controller.listReport.length + 1,
                        // itemCount: loaded.listReport.length,
                        itemBuilder: (context, index) => (controller
                                    .listReport.length ==
                                0)
                            ? Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: SizeConfig.height(20)),
                                  child: Text(
                                    'Tidak ada laporan yang diproses',
                                    style: TextStyle(
                                        fontSize: SizeConfig.text(16)),
                                  ),
                                ),
                              )
                            : (index < controller.listReport.length)
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: SizeConfig.height(16),
                                    ),
                                    child: CardListReportManagerCon(
                                      description: controller
                                          .listReport[index].description,
                                      location:
                                          controller.listReport[index].address,
                                      time: controller.listReport[index].time,
                                      title: controller.listReport[index].title,
                                      url:
                                          '${ServerApp.url}${controller.listReport[index].urlImage}',
                                      idReport:
                                          controller.listReport[index].idReport,
                                      latitude:
                                          controller.listReport[index].latitude,
                                      longitude: controller
                                          .listReport[index].longitude,
                                      name: widget.name,
                                      statusComplaint: controller
                                          .listReport[index].statusComplaint,
                                      status: '',
                                      phone: controller
                                          .listReport[index].managerContractor,
                                      processTime: controller
                                          .listReport[index].processTime,
                                    ),
                                  )
                                : (index == controller.listReport.length)
                                    ? SizedBox()
                                    : Center(
                                        child: SizedBox(
                                          height: SizeConfig.height(30),
                                          width: SizeConfig.width(30),
                                          child: CircularProgressIndicator(
                                            strokeWidth: 1.5,
                                          ),
                                        ),
                                      ),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
