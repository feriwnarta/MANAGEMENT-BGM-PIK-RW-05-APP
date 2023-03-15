import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/modules/profiles/services/statistic_services.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';

class StatistikPeduliScreen extends StatelessWidget {
  StatistikPeduliScreen({Key key}) : super(key: key);

  final userLogin = Get.put(UserLoginController());

  final AssetImage image1 = AssetImage(
    'assets/img/checklist.png',
  );

  final AssetImage image2 = AssetImage('assets/img/coordination.png');

  final AssetImage image3 = AssetImage('assets/img/bro.png');

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));
    precacheImage(image1, context);
    precacheImage(image2, context);
    precacheImage(image3, context);

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle,
        title: Text(
          'Statistik Peduli Lingkungan',
        ),
        titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<Map<String, dynamic>>(
            future: StatisticServices.getStatistic(),
            builder: (context, snapshot) => (snapshot.hasData)
                ? Obx(
                    () => Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: SizeConfig.width(16)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: SizeConfig.height(16),
                          ),
                          Text(
                            'Hi, ${userLogin.name.value}',
                            style: TextStyle(
                              fontSize: SizeConfig.text(16),
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: SizeConfig.height(4),
                          ),
                          Text(
                            'Kamu bisa menjadi bagian penting untuk ikut membangun dan menjaga lingkungan warga di Bukit Golf Mediterania, PIK. Yuk menjadi warga peduli lingkungan, laporan kamu akan membuat PIK semakin baik.',
                            style: TextStyle(
                              fontSize: SizeConfig.text(12),
                              fontWeight: FontWeight.w500,
                              color: Color(0xff757575),
                            ),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: SizeConfig.height(32),
                          ),
                          Center(
                            child: SizedBox(
                              width: SizeConfig.width(300),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image(
                                      height: SizeConfig.image(24),
                                      width: SizeConfig.image(24),
                                      image: image1),
                                  SizedBox(
                                    height: SizeConfig.height(4),
                                  ),
                                  Text(
                                    'Kamu sudah membuat kepedulian lingkungan sebanyak',
                                    style: TextStyle(
                                      fontSize: SizeConfig.text(10),
                                      color: Color(0xff616161),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    height: 4.h,
                                  ),
                                  Text(
                                    '${snapshot.data['total_peduli_lingkungan']} Laporan Peduli Lingkungan',
                                    style: TextStyle(
                                      fontSize: SizeConfig.text(14),
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
                            height: SizeConfig.height(24),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Card(
                                color: Color(0xffF5F5F5),
                                elevation: 2,
                                child: Container(
                                  width: SizeConfig.width(156),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: SizeConfig.height(16),
                                      ),
                                      Image(
                                        width: SizeConfig.image(24),
                                        height: SizeConfig.image(24),
                                        image: image2,
                                      ),
                                      SizedBox(
                                        height: SizeConfig.height(8),
                                      ),
                                      Container(
                                        child: Text(
                                          'Peduli Lingkungan Umum',
                                          style: TextStyle(
                                            fontSize: SizeConfig.text(12),
                                            color: Color(0xff616161),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(
                                        height: SizeConfig.height(8),
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: SizeConfig.width(12)),
                                        child: Text(
                                          '${snapshot.data['peduli_lingkungan_umum']}',
                                          style: TextStyle(
                                            fontSize: SizeConfig.text(16),
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(
                                        height: SizeConfig.height(16),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                elevation: 2,
                                color: Color(0xffFDF4E4),
                                child: Container(
                                  width: SizeConfig.width(156),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: SizeConfig.height(16),
                                      ),
                                      Image(
                                        width: SizeConfig.image(24),
                                        height: SizeConfig.image(24),
                                        image: AssetImage(
                                            'assets/img/coordination_2.png'),
                                      ),
                                      SizedBox(
                                        height: SizeConfig.height(8),
                                      ),
                                      Container(
                                        // margin: EdgeInsets.symmetric(horizontal: 12.w),
                                        child: Text(
                                          'Peduli Lingkungan Pribadi',
                                          style: TextStyle(
                                            fontSize: SizeConfig.text(12),
                                            color: Color(0xff616161),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(
                                        height: SizeConfig.height(8),
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                          horizontal: SizeConfig.width(8),
                                        ),
                                        child: Text(
                                          '${snapshot.data['peduli_lingkungan_pribadi']}',
                                          style: TextStyle(
                                            fontSize: SizeConfig.text(16),
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(
                                        height: SizeConfig.height(16),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: SizeConfig.height(32),
                          ),
                          Center(
                            child: Image(
                              fit: BoxFit.contain,
                              width: SizeConfig.image(282),
                              height: SizeConfig.image(248),
                              image: image3,
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.height(20),
                          ),
                          // Center(
                          //   child: SizedBox(
                          //     width: SizeConfig.width(266),
                          //     child: Text(
                          //       'Yuk sebagai warga yang baik ikut berpartisipasi dalam memelihara lingkungan komplek perumahan kita agar lingkungan selalu bersih, nyaman, aman.',
                          //       style: TextStyle(
                          //         fontSize: SizeConfig.text(10),
                          //         color: Color(0xff757575),
                          //       ),
                          //       textAlign: TextAlign.center,
                          //       maxLines: 4,
                          //       overflow: TextOverflow.ellipsis,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: LinearProgressIndicator(),
                  ),
          ),
        ),
      ),
    );
  }
}
