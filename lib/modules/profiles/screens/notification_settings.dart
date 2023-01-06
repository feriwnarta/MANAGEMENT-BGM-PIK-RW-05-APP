import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';

class NotificationSettings extends StatelessWidget {
  NotificationSettings({Key key}) : super(key: key);

  RxBool laporanDiterima = false.obs;
  RxBool laporanDikerjakan = false.obs;
  RxBool laporanSelesai = false.obs;
  RxBool komentar = false.obs;
  RxBool suka = false.obs;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifikasi',
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 16.h,
                  ),
                  AutoSizeText(
                    'Peduli Lingkungan',
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                    maxLines: 1,
                    minFontSize: 12,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(
                        'Laporan diterima',
                        style: TextStyle(fontSize: 12.sp),
                        maxLines: 1,
                        minFontSize: 10,
                        stepGranularity: 10,
                      ),
                      Switch(
                        value: laporanDiterima.value,
                        onChanged: (value) => laporanDiterima.value = value,
                        activeColor: Colors.blue,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(
                        'Laporan dikerjakan',
                        style: TextStyle(fontSize: 12.sp),
                        maxLines: 1,
                        minFontSize: 10,
                        stepGranularity: 10,
                      ),
                      Switch(
                        value: laporanDikerjakan.value,
                        onChanged: (value) => laporanDikerjakan.value = value,
                        activeColor: Colors.blue,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(
                        'Laporan selesai',
                        style: TextStyle(
                          fontSize: 12.sp,
                        ),
                        maxLines: 1,
                        minFontSize: 10,
                        stepGranularity: 10,
                      ),
                      Switch(
                        value: laporanSelesai.value,
                        onChanged: (value) => laporanSelesai.value = value,
                        activeColor: Colors.blue,
                      ),
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
                  AutoSizeText(
                    'Suka dan komentar di postingan',
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                    maxLines: 1,
                    minFontSize: 12,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(
                        'Komentar',
                        style: TextStyle(fontSize: 12.sp),
                        maxLines: 1,
                        minFontSize: 10,
                        stepGranularity: 10,
                      ),
                      Switch(
                        value: komentar.value,
                        onChanged: (value) => komentar.value = value,
                        activeColor: Colors.blue,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(
                        'Suka',
                        style: TextStyle(fontSize: 12.sp),
                        maxLines: 1,
                        minFontSize: 10,
                        stepGranularity: 10,
                      ),
                      Switch(
                        value: suka.value,
                        onChanged: (value) => suka.value = value,
                        activeColor: Colors.blue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
