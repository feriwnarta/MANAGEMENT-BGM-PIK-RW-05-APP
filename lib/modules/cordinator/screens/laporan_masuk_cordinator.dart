import 'dart:async';
import 'package:aplikasi_rw/modules/contractor/screens/complaint/detail_report_screen.dart';
import 'package:aplikasi_rw/modules/contractor/screens/complaint/finish_report_screen.dart';
import 'package:aplikasi_rw/modules/contractor/screens/complaint/process_report.dart';
import 'package:aplikasi_rw/modules/contractor/widgets/detail_report_finished.dart';
import 'package:aplikasi_rw/modules/cordinator/controller/cordinator_controller.dart';
import 'package:aplikasi_rw/modules/cordinator/widgets/card_cordinator.dart';
import 'package:aplikasi_rw/services/cordinator/process_report_services.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:aplikasi_rw/utils/string_utils.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../controller/user_login_controller.dart';
import '../../../../server-app.dart';

//ignore: must_be_immutable
class LaporanMasukCordinator extends StatefulWidget {
  LaporanMasukCordinator({Key key, this.name, this.status}) : super(key: key);

  String name, status;

  @override
  _CardReportState createState() => _CardReportState();
}

class _CardReportState extends State<LaporanMasukCordinator>
    with AutomaticKeepAliveClientMixin {
  Timer timer;

  // final ScrollController scrollController = ScrollController();
  final contractorController = Get.put(CordinatorController());
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
    Get.delete<CordinatorController>();
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
    ScreenUtil.init(context, designSize: const Size(360, 800));
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan Masuk'),
      ),
      body: SingleChildScrollView(
        child: GetX<CordinatorController>(
          init: CordinatorController(),
          builder: (controller) {
            if (controller.isLoading.value) {
              return Center(
                child: SizedBox(
                    height: SizeConfig.height(30),
                    width: SizeConfig.width(30),
                    child: CircularProgressIndicator()),
              );
            } else {
              return Container(
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.width(16),
                    vertical: SizeConfig.height(16)),
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
                                    child: CardListCordinator(
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
                                      phone: controller
                                          .listReport[index].managerContractor,
                                    ),
                                  )
                                : (index == controller.listReport.length)
                                    ? SizedBox()
                                    : Center(
                                        child: SizedBox(
                                          height: SizeConfig.height(30),
                                          width: SizeConfig.height(30),
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
class CardListCordinator extends StatelessWidget {
  CardListCordinator(
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
      this.management,
      this.phone})
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
      management;

  List<Map<String, dynamic>> phone;

  final userLogin = UserLoginController();
  Map<String, dynamic> result;
  final logger = Logger();

  void onCardTap() async {
    Get.defaultDialog(
      title: 'Pilih Manager Kontraktor',
      radius: 5,
      titleStyle: TextStyle(
        fontSize: SizeConfig.text(14),
      ),
      content: Container(
        height: SizeConfig.height(200),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: phone
                .map<Widget>(
                  (item) => ListTile(
                    title: RichText(
                      text: TextSpan(
                        text: '${item['no_telp']}',
                        style: TextStyle(
                          fontSize: SizeConfig.text(12),
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: '\t (${item['name_pic']})',
                            style: TextStyle(
                              fontSize: SizeConfig.text(12),
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    trailing: Icon(
                      Icons.phone,
                      size: SizeConfig.height(20),
                    ),
                    onTap: () async {
                      String noTelp = StringUtils.replaceCountryNumberPhone(
                          item['no_telp']);

                      var whatsappAndroid =
                          Uri.parse("whatsapp://send?phone=$noTelp");

                      if (await canLaunchUrl(whatsappAndroid)) {
                        await launchUrl(whatsappAndroid);
                      } else {
                        EasyLoading.showInfo(
                            'Aplikasi whatsapp tidak terinstal di perangkat anda');
                      }
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
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
                isContractor: false,
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
                // time: processTime,
                title: title,
                url: url,
                isCon: false,
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
                isCon: false,
              ),
              transition: Transition.cupertino,
            );
          }
        }
      },
      child: CardCordinator(
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
