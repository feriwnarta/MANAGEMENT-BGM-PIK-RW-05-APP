import 'package:aplikasi_rw/modules/authentication/controllers/access_controller.dart';
import 'package:aplikasi_rw/modules/estate_manager/screens/create_account.dart';
import 'package:aplikasi_rw/modules/estate_manager/screens/dashboard.dart';
import 'package:aplikasi_rw/modules/home/widgets/menu.dart';
import 'package:aplikasi_rw/modules/report_screen/screens/add_complaint.dart';
import 'package:aplikasi_rw/modules/report_screen/screens/sub_menu_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../home/widgets/header_screen.dart';

class MenuFolderEm extends StatefulWidget {
  const MenuFolderEm({Key key}) : super(key: key);

  @override
  State<MenuFolderEm> createState() => _MenuFolderEmState();
}

class _MenuFolderEmState extends State<MenuFolderEm> {
  final accessController = Get.find<AccessController>();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              children: [
                HeaderScreen(
                  isEmOrCord: true,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          (accessController.dashboardEm.value)
                              ? Menu(
                                  icon:
                                      'assets/img/estate_manager_menu/dashboard-em.jpg',
                                  onTap: () {
                                    Get.to(
                                      () => DashboardEm(),
                                      transition: Transition.rightToLeft,
                                    );
                                  },
                                  text: 'Dashboard',
                                )
                              : Menu(
                                  icon:
                                      'assets/img/estate_manager_menu/dashboard-em.jpg',
                                  onTap: () {
                                    EasyLoading.showInfo(
                                        'Fitur ini hanya bisa diakses oleh estate manager',
                                        dismissOnTap: true);
                                  },
                                  text: 'Dashboard',
                                ),
                          SizedBox(
                            width: 16.w,
                          ),
                          (accessController.tambahAkunEm.value)
                              ? Menu(
                                  icon:
                                      'assets/img/estate_manager_menu/add_account.jpg',
                                  onTap: () {
                                    Get.to(
                                      () => CreateAccount(),
                                      transition: Transition.rightToLeft,
                                    );
                                  },
                                  text: 'Tambah Akun',
                                )
                              : Menu(
                                  icon:
                                      'assets/img/estate_manager_menu/add_account.jpg',
                                  onTap: () {
                                    EasyLoading.showInfo(
                                        'Fitur ini hanya bisa diakses oleh estate manager',
                                        dismissOnTap: true);
                                  },
                                  text: 'Tambah Akun',
                                ),
                          SizedBox(
                            width: 16.w,
                          ),
                          (accessController.statusPeduliLingkunganEm.value)
                              ? Menu(
                                  icon:
                                      'assets/img/estate_manager_menu/status_peduli_lingkungan.jpg',
                                  onTap: () {
                                    Get.to(
                                      () => SubMenuReport(
                                        typeStatusPeduliLingkungan: 'em',
                                      ),
                                      transition: Transition.rightToLeft,
                                    );
                                  },
                                  text: 'Status Peduli Lingkungan',
                                )
                              : Menu(
                                  icon:
                                      'assets/img/estate_manager_menu/status_peduli_lingkungan.jpg',
                                  onTap: () {
                                    EasyLoading.showInfo(
                                        'Fitur ini hanya bisa diakses oleh estate manager',
                                        dismissOnTap: true);
                                  },
                                  text: 'Status Peduli Lingkungan',
                                ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
