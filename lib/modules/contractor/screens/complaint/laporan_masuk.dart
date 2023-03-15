import 'dart:async';
import 'package:aplikasi_rw/modules/contractor/controller/contractor_controller.dart';
import 'package:aplikasi_rw/modules/contractor/screens/complaint/finish_report_screen.dart';
import 'package:aplikasi_rw/modules/contractor/screens/complaint/process_report.dart';
import 'package:aplikasi_rw/modules/contractor/widgets/card_worker.dart';
import 'package:aplikasi_rw/modules/contractor/widgets/detail_report_finished.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../../../../controller/user_login_controller.dart';
import '../../../../server-app.dart';
import '../../../../services/cordinator/process_report_services.dart';
import 'detail_report_screen.dart';

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
  final contractorController = Get.put(ContractorController());
  final userLoginController = Get.put(UserLoginController());

  void onScroll() {
    if (contractorController.scrollcontroller.position.maxScrollExtent ==
        contractorController.scrollcontroller.position.pixels) {
      contractorController.getComplaintDiterimaDanProses();
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    if (timer.isActive) {
      timer.cancel();
    }
    Get.delete<ContractorController>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    contractorController.getComplaintDiterimaDanProses();
  }

  final logger = Logger();

  @override
  didChangeDependencies() async {
    super.didChangeDependencies();
    timer = Timer.periodic(Duration(seconds: 1), (second) {
      contractorController.realTimeComplaintDiterimaDanProses();
    });
    contractorController.scrollcontroller.addListener(onScroll);
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
        child: GetX<ContractorController>(
          init: ContractorController(),
          builder: (controller) {
            if (controller.isLoading.value) {
              return Center(
                child: SizedBox(
                    height: 30, width: 30, child: CircularProgressIndicator()),
              );
            } else {
              return Container(
                margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.width(16),
                  vertical: SizeConfig.height(16),
                ),
                child: Column(
                  children: [
                    Text(
                      'Jumlah laporan yang masuk di lingkungan RW 05.',
                      style: TextStyle(fontSize: SizeConfig.text(16)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: SizeConfig.height(16),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        controller: contractorController.scrollcontroller,
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
                                padding:
                                    EdgeInsets.only(top: SizeConfig.height(20)),
                                child: Text(
                                  'Tidak ada laporan yang masuk',
                                  style: TextStyle(
                                    fontSize: SizeConfig.text(16),
                                  ),
                                ),
                              ))
                            : (index < controller.listReport.length)
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        bottom: SizeConfig.height(16)),
                                    child: CardListReport(
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
                                      statusComplaint: controller
                                          .listReport[index].statusComplaint,
                                      name: widget.name,
                                      status: '',
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
                                      )),
                  ],
                ),
              );
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
      this.statusComplaint,
      this.longitude,
      this.processTime,
      this.management})
      : super(key: key);

  String url,
      title,
      description,
      statusComplaint,
      location,
      time,
      latitude,
      longitude,
      idReport,
      name,
      status,
      processTime,
      management;

  final userLogin = UserLoginController();
  Map<String, dynamic> result;

  void onCardTap() async {
    if (status == null) {
      Get.to(
        () => DetailLaporanSelesai(idReport: idReport),
        transition: Transition.cupertino,
      );
    } else {
      EasyLoading.show(status: 'loading');
      result = await ProcessReportServices.checkExistProcess(idReport);
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
            isContractor: true,
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
            time: processTime,
            title: title,
            url: url,
            isCon: true,
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
            isCon: true,
          ),
          transition: Transition.cupertino,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {},
      child: CardWorker(
        address: location,
        image: url,
        lat: latitude,
        long: longitude,
        status: statusComplaint,
        title: title,
        waktu: time,
        onTap: onCardTap,
      ),
    );
  }
}
