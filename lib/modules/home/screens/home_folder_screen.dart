import 'package:aplikasi_rw/modules/contractor/screens/cordinator_home_folder_screen.dart';
import 'package:aplikasi_rw/modules/cordinator/screens/home_folder_cordinator.dart';
import 'package:aplikasi_rw/modules/estate_manager/screens/menu_folder_screens_em.dart';
import 'package:aplikasi_rw/modules/home/screens/citizen_screen.dart';
import 'package:aplikasi_rw/modules/home/widgets/header_screen.dart';
import 'package:aplikasi_rw/modules/home/widgets/menu.dart';
import 'package:aplikasi_rw/modules/manager_contractor/screens/home_folder_manager_contractor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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
            HeaderScreen(
              isEmOrCord: false,
            ),
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
              // height: 224.h,
              margin: EdgeInsets.symmetric(horizontal: 12.w),
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
                        onTap: () => Get.to(() => CitizenScreen(),
                            transition: Transition.rightToLeft),
                      ),
                      SizedBox(
                        width: 16.w,
                      ),
                      Menu(
                        icon: 'assets/img/menu-em.jpg',
                        text: 'Estate Manager',
                        onTap: () => Get.to(
                          () => MenuFolderEm(),
                          transition: Transition.rightToLeft,
                        ),
                      ),
                      SizedBox(
                        width: 16.w,
                      ),
                      Menu(
                        icon: 'assets/img/menu-estate-kordinator.jpg',
                        text: 'Estate Koordinator',
                        onTap: () {
                          Get.to(
                            () => MenuFolderCordinator(),
                            transition: Transition.rightToLeft,
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Row(
                    children: [
                      Menu(
                        icon: 'assets/img/manager-kontraktor.jpg',
                        text: 'Manager Kontraktor',
                        onTap: () {
                          Get.to(
                            () => MenuFolderManagerContractor(),
                            transition: Transition.rightToLeft,
                          );
                        },
                      ),
                      SizedBox(
                        width: 16.w,
                      ),
                      Menu(
                        icon: 'assets/img/menu-kontraktor.jpg',
                        text: 'Kepala Kontraktor',
                        onTap: () {
                          Get.to(
                            () => MenuFolderContractor(),
                            transition: Transition.rightToLeft,
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 70.h,
            ),
          ],
        )),
      ),
    );
  }
}
