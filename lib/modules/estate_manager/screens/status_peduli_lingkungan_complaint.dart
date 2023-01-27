import 'dart:async';

import 'package:aplikasi_rw/modules/contractor/controller/contractor_controller.dart';
import 'package:aplikasi_rw/modules/estate_manager/services/status_peduli_lingkungan_services.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/view_image.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Status Peduli Lingkungan'),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: SingleChildScrollView(
          controller: scrollController,
          child: FutureBuilder<List<RadioStatusPeduli>>(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 16.w,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 16.h,
                        ),
                        AutoSizeText(
                          'Laporan masuk dan belum mendapat penanganan segera hubungi koordinator yang terkait.',
                          style: TextStyle(
                            fontSize: 16.sp,
                          ),
                          maxLines: 5,
                          minFontSize: 10,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        SizedBox(
                          height: 35.h,
                          child: ListView.builder(
                            itemCount: snapshot.data.length,
                            addAutomaticKeepAlives: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => Row(
                              children: [
                                Obx(
                                  () => Radio<String>(
                                    value: snapshot.data[index].value,
                                    groupValue: groupSelected.value.groupValue,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    onChanged: (value) async {
                                      groupSelected.value =
                                          RadioStatusPeduli(groupValue: value);
                                      await controllerEm.changeDataRequest(
                                          status:
                                              groupSelected.value.groupValue);
                                    },
                                    visualDensity: const VisualDensity(
                                      horizontal: VisualDensity.minimumDensity,
                                      vertical: VisualDensity.minimumDensity,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                AutoSizeText(
                                  '${snapshot.data[index].title}',
                                  style: TextStyle(fontSize: 14.sp),
                                  maxLines: 2,
                                  minFontSize: 11,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  width: 16.w,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
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
  const CardStatusPeduliLingkunganEm({
    Key key,
    this.title,
    this.status,
    this.image,
    this.address,
    this.lat,
    this.long,
    this.waktu,
    this.cordinatorPhone,
  }) : super(key: key);

  final String title, status, image, address, lat, long, waktu;
  final List<Map<String, dynamic>> cordinatorPhone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
                width: 148.w,
                child: AutoSizeText(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                  style: TextStyle(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                width: 103.w,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
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
                  child: AutoSizeText(
                    status,
                    overflow: TextOverflow.ellipsis,
                    minFontSize: 10,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: (status.isCaseInsensitiveContainsAny('Menunggu'))
                          ? Color(
                              0xffF32020,
                            )
                          : status.isCaseInsensitiveContainsAny('Diterima')
                              ? Color(0xff2094F3)
                              : status.isCaseInsensitiveContainsAny('Diproses')
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
            height: 16.h,
          ),
          Divider(
            thickness: 1,
          ),
          SizedBox(
            height: 16.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Get.to(
                  () => ViewImage(urlImage: '${ServerApp.url}/$image'),
                ),
                child: Container(
                  width: 70.w,
                  height: 70.h,
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
                width: 16.w,
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
                          width: 8.w,
                        ),
                        Expanded(
                          child: AutoSizeText(
                            address,
                            maxLines: 5,
                            style: TextStyle(
                              fontSize: 14.sp,
                            ),
                            minFontSize: 10,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8.h,
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
                            ),
                            SizedBox(width: 4.w),
                            AutoSizeText(
                              'Lihat peta lokasi',
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 10.sp,
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
            height: 8.h,
          ),
          AutoSizeText.rich(
            TextSpan(
              text: 'Waktu laporan : ',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
              ),
              children: [
                TextSpan(
                  text: waktu,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          ElevatedButton(
            onPressed: () {
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
                      children: cordinatorPhone
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
                                      text:
                                          '\t (${item['name_estate_cordinator']})',
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
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            child: Text(
              'Hubungi Kordinator',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
