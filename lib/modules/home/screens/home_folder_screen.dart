import 'package:aplikasi_rw/modules/home/screens/citizen_screen.dart';
import 'package:aplikasi_rw/modules/home/widgets/app_bar_citizen.dart';
import 'package:aplikasi_rw/modules/home/widgets/header_screen.dart';
import 'package:aplikasi_rw/modules/home/widgets/menu.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';

class HomeScreenFolder extends StatefulWidget {
  const HomeScreenFolder({Key key}) : super(key: key);

  @override
  State<HomeScreenFolder> createState() => _HomeScreenFolderState();
}

class _HomeScreenFolderState extends State<HomeScreenFolder> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          children: [
            HeaderScreen(),
            SizedBox(
              height: 24.h,
            ),
            Divider(
              thickness: 1,
            ),
            SizedBox(
              height: 24.h,
            ),
            Container(
              height: 224.h,
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Menu(
                        icon: 'assets/img/menu-pengelola.jpg',
                        text: 'Pengelola',
                        onTap: () {},
                      ),
                      SizedBox(
                        width: 16.w,
                      ),
                      Menu(
                        icon: 'assets/img/menu-warga.jpg',
                        text: 'Warga',
                        onTap: () => Get.to(() => CitizenScreen()),
                      ),
                      SizedBox(
                        width: 16.w,
                      ),
                      Menu(
                        icon: 'assets/img/menu-em.jpg',
                        text: 'Estate Manager',
                      ),
                      SizedBox(
                        width: 16.w,
                      ),
                      Menu(
                        icon: 'assets/img/menu-estate-kordinator.jpg',
                        text: 'Estate Koordinator',
                        onTap: () {},
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Row(
                    children: [
                      Menu(
                        icon: 'assets/img/menu-kontraktor.jpg',
                        text: 'Kontraktor',
                        onTap: () {},
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 70.h,
            ),
            // Container(
            //   height: 224.h,
            //   margin: EdgeInsets.symmetric(horizontal: 16.w),
            //   child: GridView.count(
            //     physics: NeverScrollableScrollPhysics(),
            //     crossAxisCount: 4,
            //     childAspectRatio: MediaQuery.of(context).size.width /
            //         (MediaQuery.of(context).size.height / 1.4),
            //     crossAxisSpacing: 16.w,
            //     // mainAxisSpacing: 16.h,
            //     children: [
            //       Column(
            //         children: [
            //           Container(
            //             width: 70.w,
            //             height: 72.h,
            //             decoration: BoxDecoration(
            //               image: DecorationImage(
            //                 image:
            //                     AssetImage('assets/img/menu-pengelola.jpg'),
            //               ),
            //             ),
            //           ),
            //           Text('asdsad')
            //         ],
            //       ),
            //       Container(
            //         width: 70.w,
            //         height: 72.h,
            //         decoration: BoxDecoration(
            //           image: DecorationImage(
            //             image: AssetImage('assets/img/menu-warga.jpg'),
            //           ),
            //         ),
            //       ),
            //       Container(
            //         width: 70.w,
            //         height: 72.h,
            //         decoration: BoxDecoration(
            //           image: DecorationImage(
            //             image: AssetImage('assets/img/menu-em.jpg'),
            //           ),
            //         ),
            //       ),
            //       Container(
            //         width: 70.w,
            //         height: 72.h,
            //         decoration: BoxDecoration(
            //             image: DecorationImage(
            //                 image: AssetImage(
            //                     'assets/img/menu-estate-kordinator.jpg'))),
            //       ),
            //       Container(
            //         width: 70.w,
            //         height: 72.h,
            //         decoration: BoxDecoration(
            //           image: DecorationImage(
            //             image: AssetImage('assets/img/menu-kontraktor.jpg'),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // )
          ],
        )),
      ),
    );
  }
}
