import 'dart:async';
import 'package:aplikasi_rw/modules/cordinator/controller/cordinator_controller.dart';
import 'package:aplikasi_rw/modules/cordinator/widgets/card_cordinator.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../controller/user_login_controller.dart';
import '../../../../server-app.dart';

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
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: GetX<CordinatorController>(
        init: CordinatorController(),
        builder: (controller) {
          if (controller.isLoading.value) {
            return Center(
              child: SizedBox(
                  height: 30, width: 30, child: CircularProgressIndicator()),
            );
          } else {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                children: [
                  AutoSizeText(
                    'Jumlah laporan yang masuk di lingkungan RW 05.',
                    style: TextStyle(fontSize: 16.sp),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 16.h,
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
                              padding: EdgeInsets.only(top: 20.h),
                              child: Text('Tidak ada laporan yang masuk'),
                            ))
                          : (index < controller.listReport.length)
                              ? Padding(
                                  padding: EdgeInsets.only(bottom: 16.h),
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
                                    longitude:
                                        controller.listReport[index].longitude,
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
                                        height: 30.h,
                                        width: 30.h,
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
      title: 'Pilih cordinator',
      radius: 5,
      titleStyle: TextStyle(
        fontSize: 14.sp,
      ),
      content: Container(
        height: 200.h,
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
                          fontSize: 12.sp,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: '\t (${item['name_pic']})',
                            style: TextStyle(
                              fontSize: 12.sp,
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
                      size: 20,
                    ),
                    onTap: () {
                      launchUrl(
                        Uri(
                          scheme: 'tel',
                          path: '${item['no_telp']}',
                        ),
                      );
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
      onTap: () async {},
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
