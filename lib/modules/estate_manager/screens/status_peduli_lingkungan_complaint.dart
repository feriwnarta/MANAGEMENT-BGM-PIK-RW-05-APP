import 'dart:async';

import 'package:aplikasi_rw/modules/contractor/controller/contractor_controller.dart';
import 'package:aplikasi_rw/modules/contractor/screens/complaint/detail_report_screen.dart';
import 'package:aplikasi_rw/modules/contractor/screens/complaint/finish_report_screen.dart';
import 'package:aplikasi_rw/modules/contractor/widgets/detail_report_finished.dart';
import 'package:aplikasi_rw/modules/estate_manager/services/status_peduli_lingkungan_services.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:aplikasi_rw/utils/view_image.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../contractor/screens/complaint/process_report.dart';
import '../controllers/estate_manager_list_peduli_controller.dart';

class StatusPeduliLingkunganComplaint extends StatefulWidget {
  const StatusPeduliLingkunganComplaint({Key key}) : super(key: key);

  @override
  State<StatusPeduliLingkunganComplaint> createState() =>
      _ListStatusPeduliLingkunganState();
}

class _ListStatusPeduliLingkunganState
    extends State<StatusPeduliLingkunganComplaint> {
  Rx<RadioStatusPeduli> groupSelected =
      RadioStatusPeduli(groupValue: 'Semua', value: 'Semua').obs;

  Future future;

  final logger = Logger();

  ListStatusPeduliEmController controllerEm =
      Get.put(ListStatusPeduliEmController());

  Timer timer;

  @override
  void initState() {
    super.initState();
    future = StatusPeduliEmServices.listMasterCategory();
    controllerEm.getDataFromDb(status: groupSelected.value.groupValue);
  }

  @override
  void dispose() {
    if (timer != null) {
      if (timer.isActive) {
        timer.cancel();
      }
    }

    Get.delete<ListStatusPeduliEmController>();
    super.dispose();
  }

  final ScrollController scrollController = ScrollController();

  void onScroll() {
    if (scrollController.position.haveDimensions) {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        controllerEm.getDataFromDb(status: groupSelected.value.groupValue);
      }
    }
  }

  @override
  void didChangeDependencies() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      controllerEm.realTime(status: groupSelected.value.groupValue);
    });
    scrollController.addListener(onScroll);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));
    return Scaffold(
      appBar: AppBar(
        title: Text('Status Peduli Lingkungan'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: scrollController,
          child: FutureBuilder<List<RadioStatusPeduli>>(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.width(16),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: SizeConfig.height(16),
                        ),
                        Text(
                          'Laporan masuk dan belum mendapat penanganan segera hubungi koordinator yang terkait.',
                          style: TextStyle(
                            fontSize: SizeConfig.text(16),
                          ),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: SizeConfig.height(20),
                        ),
                        SizedBox(
                          height: SizeConfig.height(35),
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            addAutomaticKeepAlives: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => Row(
                              children: [
                                Obx(
                                  () => Transform.scale(
                                    scale: 0.8,
                                    child: Radio<String>(
                                      value: snapshot.data[index].value,
                                      groupValue:
                                          groupSelected.value.groupValue,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      onChanged: (value) async {
                                        groupSelected.value = RadioStatusPeduli(
                                            groupValue: value);
                                        await controllerEm.changeDataRequest(
                                            status:
                                                groupSelected.value.groupValue);
                                      },
                                      visualDensity: const VisualDensity(
                                        horizontal:
                                            VisualDensity.minimumDensity,
                                        vertical: VisualDensity.minimumDensity,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: SizeConfig.width(8),
                                ),
                                Text(
                                  '${snapshot.data[index].title}',
                                  style:
                                      TextStyle(fontSize: SizeConfig.text(14)),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  width: SizeConfig.width(16),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.height(20),
                        ),
                        Obx(
                          () => (controllerEm.isLoading.value)
                              ? CircularProgressIndicator()
                              : ListView.builder(
                                  itemCount: (controllerEm.isMaxReached.value)
                                      ? controllerEm.listStatusPeduli.length
                                      : controllerEm.listStatusPeduli.length +
                                          1,
                                  shrinkWrap: true,
                                  addAutomaticKeepAlives: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) => (controllerEm
                                              .listStatusPeduli.length >
                                          index)
                                      ? Column(
                                          children: [
                                            CardStatusPeduliLingkunganEm(
                                              address: controllerEm
                                                  .listStatusPeduli[index]
                                                  .address,
                                              status: controllerEm
                                                  .listStatusPeduli[index]
                                                  .status,
                                              title: controllerEm
                                                  .listStatusPeduli[index]
                                                  .title,
                                              waktu: controllerEm
                                                  .listStatusPeduli[index]
                                                  .waktu,
                                              image: controllerEm
                                                  .listStatusPeduli[index]
                                                  .image,
                                              lat: controllerEm
                                                  .listStatusPeduli[index].lat,
                                              long: controllerEm
                                                  .listStatusPeduli[index].long,
                                              idReport: controllerEm
                                                  .listStatusPeduli[index]
                                                  .idReport,
                                              cordinatorPhone: controllerEm
                                                  .listStatusPeduli[index]
                                                  .cordinatorPhone,
                                            ),
                                            SizedBox(
                                              height: 24.h,
                                            ),
                                          ],
                                        )
                                      : (controllerEm.listStatusPeduli.length <
                                              10)
                                          ? (controllerEm.listStatusPeduli
                                                      .length ==
                                                  0)
                                              ? Center(
                                                  child: Text(
                                                    'Tidak ada laporan yang masuk',
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                )
                                              : SizedBox()
                                          : Center(
                                              child: SizedBox(
                                                  width: 30,
                                                  height: 30,
                                                  child:
                                                      CircularProgressIndicator
                                                          .adaptive()),
                                            ),
                                ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return LinearProgressIndicator();
                }
              }),
        ),
      ),
    );
  }
}

class CardStatusPeduliLingkunganEm extends StatelessWidget {
  CardStatusPeduliLingkunganEm({
    Key key,
    this.title,
    this.status,
    this.image,
    this.address,
    this.lat,
    this.long,
    this.waktu,
    this.idReport,
    this.cordinatorPhone,
  }) : super(key: key);

  final String title, status, image, address, lat, long, waktu, idReport;
  final List<Map<String, dynamic>> cordinatorPhone;

  final logger = Logger();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        EasyLoading.show(status: 'loading');

        var rs =
            await StatusPeduliEmServices.getDataReportCard(idReport: idReport);

        /**
         * cek dulu tidak null dan tidak voleh kosong
         */

        EasyLoading.dismiss();

        if (rs['status'] == 'Menunggu' || rs['status'] == 'Diterima') {
          Get.to(
            () => DetailReportScreen(
              description: rs['description'],
              idReport: rs['id_report'],
              latitude: rs['latitude'],
              location: rs['address'],
              longitude: rs['longitude'],
              time: rs['time'],
              title: rs['description'],
              url: '${ServerApp.url}${rs['url']}',
              isContractor: false,
            ),
            transition: Transition.cupertino,
          );
        } else if (rs['status'] == 'Diproses') {
          Get.to(
            () => FinishReportScreen(
              description: rs['description'],
              idReport: rs['id_report'],
              latitude: rs['latitude'],
              longitude: rs['longitude'],
              time: rs['process_time'],
              title: rs['description'],
              url: '${ServerApp.url}${rs['url']}',
              isCon: false,
            ),
            transition: Transition.cupertino,
          );
        } else {
          Get.to(
            () => DetailLaporanSelesai(idReport: idReport),
            transition: Transition.cupertino,
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.width(16),
          vertical: SizeConfig.height(16),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), //shadow color
              spreadRadius: 0.5, // spread radius
              blurRadius: 2, // shadow blur radius
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: SizeConfig.width(148),
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                    style: TextStyle(
                      fontSize: SizeConfig.text(19),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  width: SizeConfig.width(103),
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.width(8),
                    vertical: SizeConfig.height(2),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: (status.isCaseInsensitiveContainsAny('Menunggu'))
                          ? Color(
                              0xffFF6A6A,
                            )
                          : status.isCaseInsensitiveContainsAny('Diterima')
                              ? Color(0xff90C5F0)
                              : status.isCaseInsensitiveContainsAny('Diproses')
                                  ? Color(0xffFCC870)
                                  : (status.isCaseInsensitiveContainsAny(
                                          'Selesai'))
                                      ? Color(0xff5AFD79)
                                      : Color(
                                          0xffFF6A6A,
                                        ),
                    ),
                    color: (status.isCaseInsensitiveContainsAny('Menunggu'))
                        ? Color(
                            0xffFFC9C9,
                          )
                        : status.isCaseInsensitiveContainsAny('Diterima')
                            ? Color(0xffF2F9FF)
                            : status.isCaseInsensitiveContainsAny('Diproses')
                                ? Color(0xffFFEBC9)
                                : status.isCaseInsensitiveContainsAny('Selesai')
                                    ? Color(0xffD6FFDD)
                                    : Color(0xffFFC9C9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      status,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: SizeConfig.text(12),
                        fontWeight: FontWeight.w500,
                        color: (status.isCaseInsensitiveContainsAny('Menunggu'))
                            ? Color(
                                0xffF32020,
                              )
                            : status.isCaseInsensitiveContainsAny('Diterima')
                                ? Color(0xff2094F3)
                                : status.isCaseInsensitiveContainsAny(
                                        'Diproses')
                                    ? Color(0xffF3A520)
                                    : (status.isCaseInsensitiveContainsAny(
                                            'Selesai'))
                                        ? Color(0xff20F348)
                                        : Color(
                                            0xffF32020,
                                          ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: SizeConfig.height(16),
            ),
            Divider(
              thickness: 1,
            ),
            SizedBox(
              height: SizeConfig.height(16),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Get.to(
                    () => ViewImage(urlImage: '${ServerApp.url}/$image'),
                  ),
                  child: Container(
                    width: SizeConfig.width(70),
                    height: SizeConfig.height(70),
                    child: CachedNetworkImage(
                      imageUrl: '${ServerApp.url}/$image',
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.low,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
                SizedBox(
                  width: SizeConfig.width(16),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                              'assets/img/estate_manager_menu/location-marker-em.svg'),
                          SizedBox(
                            width: SizeConfig.width(8),
                          ),
                          Expanded(
                            child: Text(
                              address,
                              maxLines: 5,
                              style: TextStyle(
                                fontSize: SizeConfig.text(14),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.height(8),
                      ),
                      Material(
                        child: InkWell(
                          splashColor: Colors.grey[200],
                          onTap: () {
                            ProcessReportScreen.navigateTo(
                                double.parse(lat), double.parse(long));
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                'assets/img/image-svg/Icon-map.svg',
                                width: SizeConfig.width(16),
                                height: SizeConfig.height(16),
                              ),
                              SizedBox(width: SizeConfig.width(8)),
                              Text(
                                'Lihat peta lokasi',
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: SizeConfig.text(10),
                                  color: Color(0xff2094F3),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.height(8),
            ),
            Text.rich(
              TextSpan(
                text: 'Waktu laporan : ',
                style: TextStyle(
                  fontSize: SizeConfig.text(10),
                  fontWeight: FontWeight.w400,
                ),
                children: [
                  TextSpan(
                    text: waktu,
                    style: TextStyle(
                      fontSize: SizeConfig.text(12),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: SizeConfig.height(16),
            ),
            SizedBox(
              width: SizeConfig.width(177),
              height: SizeConfig.height(32),
              child: ElevatedButton(
                onPressed: () {
                  Get.defaultDialog(
                    title: 'Pilih cordinator',
                    radius: 5,
                    titleStyle: TextStyle(
                      fontSize: SizeConfig.text(14),
                    ),
                    content: Container(
                      height: SizeConfig.height(200),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: cordinatorPhone
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
                                          text: '\t (${item['name']})',
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
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(
                    Icons.phone,
                    size: SizeConfig.height(16),
                  ),
                  SizedBox(
                    width: SizeConfig.width(4),
                  ),
                  Text(
                    'Hubungi Kordinator',
                    style: TextStyle(
                      fontSize: SizeConfig.text(14),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
