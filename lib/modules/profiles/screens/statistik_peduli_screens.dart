import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/modules/profiles/services/statistic_services.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';

class StatistikPeduliScreen extends StatelessWidget {
  const StatistikPeduliScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));

    final userLogin = Get.put(UserLoginController());

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: Text(
          'Statistik Peduli Lingkungan',
        ),
        titleTextStyle: TextStyle(fontSize: 19.sp),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<Map<String, dynamic>>(
              future: StatisticServices.getStatistic(),
              builder: (context, snapshot) => (snapshot.hasData)
                  ? Obx(
                      () => Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 16.h,
                            ),
                            AutoSizeText(
                              'Hi, ${userLogin.name.value}',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            AutoSizeText(
                              'Kamu bisa menjadi bagian penting untuk ikut membangun dan menjaga lingkungan warga di Bukit Golf Mediterania, PIK. Yuk menjadi warga peduli lingkungan, laporan kamu akan membuat PIK semakin baik.',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff757575),
                              ),
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 32.h,
                            ),
                            Center(
                              child: SizedBox(
                                width: 300.w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image(
                                        height: 24.h,
                                        width: 24.w,
                                        image: AssetImage(
                                          'assets/img/checklist.png',
                                        )),
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    AutoSizeText(
                                      'Kamu sudah membuat kepedulian lingkungan sebanyak',
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: Color(0xff616161),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    AutoSizeText(
                                      '${snapshot.data['total_peduli_lingkungan']} Laporan Peduli Lingkungan',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 24.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Card(
                                  color: Color(0xffF5F5F5),
                                  elevation: 2,
                                  child: Container(
                                    width: 156.w,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 16.h,
                                        ),
                                        Image(
                                          width: 24.w,
                                          height: 24.h,
                                          image: AssetImage(
                                              'assets/img/coordination.png'),
                                        ),
                                        SizedBox(
                                          height: 8.h,
                                        ),
                                        Container(
                                          child: AutoSizeText(
                                            'Peduli Lingkungan Umum',
                                            minFontSize: 12,
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Color(0xff616161),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8.h,
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 12.w),
                                          child: AutoSizeText(
                                            '${snapshot.data['peduli_lingkungan_umum']}',
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 16.h,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 2,
                                  color: Color(0xffFDF4E4),
                                  child: Container(
                                    width: 156.w,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 16.h,
                                        ),
                                        Image(
                                          width: 24.w,
                                          height: 24.h,
                                          image: AssetImage(
                                              'assets/img/coordination_2.png'),
                                        ),
                                        SizedBox(
                                          height: 8.h,
                                        ),
                                        Container(
                                          // margin: EdgeInsets.symmetric(horizontal: 12.w),
                                          child: AutoSizeText(
                                            'Peduli Lingkungan Pribadi',
                                            minFontSize: 12,
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Color(0xff616161),
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8.h,
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 12.w),
                                          child: AutoSizeText(
                                            '${snapshot.data['peduli_lingkungan_pribadi']}',
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 16.h,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 32.h,
                            ),
                            Center(
                              child: Image(
                                fit: BoxFit.contain,
                                width: 282.w,
                                height: 248.h,
                                image: AssetImage('assets/img/bro.png'),
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Center(
                              child: SizedBox(
                                width: 266.w,
                                child: AutoSizeText(
                                  'Yuk sebagai warga yang baik ikut berpartisipasi dalam memelihara lingkungan komplek perumahan kita agar lingkungan selalu bersih, nyaman, aman.',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Color(0xff757575),
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : CircularProgressIndicator.adaptive()),
        ),
      ),
    );
  }
}
