import 'package:aplikasi_rw/modules/estate_manager/controllers/estate_manager_controller.dart';
import 'package:aplikasi_rw/modules/estate_manager/services/status_peduli_lingkungan_services.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

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

  ListStatusPeduliEmController controllerEm =
      Get.put(ListStatusPeduliEmController());

  @override
  void initState() {
    super.initState();
    future = StatusPeduliEmServices.listMasterCategory();
    controllerEm.getDataFromDb(status: groupSelected.value.groupValue);
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
                                    onChanged: (value) {
                                      groupSelected.value =
                                          RadioStatusPeduli(groupValue: value);
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
                                  itemCount:
                                      controllerEm.listStatusPeduli.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) => Padding(
                                    padding: EdgeInsets.only(bottom: 24.h),
                                    child: CardStatusPeduliLingkunganEm(
                                      address: controllerEm
                                          .listStatusPeduli[index].address,
                                      status: controllerEm
                                          .listStatusPeduli[index].status,
                                      title: 'asdsad',
                                      waktu: 'asdsad',
                                    ),
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
  final List<String> cordinatorPhone;

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
                    color: Color(
                      0xffEECEB0,
                    ),
                  ),
                  color: Color(0xffFFF9F2),
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
              Container(
                width: 70.w,
                height: 70.h,
                color: Colors.grey,
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
                        onTap: () {},
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
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: RichText(
                        text: TextSpan(
                          text: 'Iskandar',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: '\t (085714342528)',
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
                    )
                  ],
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
