import 'package:aplikasi_rw/modules/estate_manager/screens/create_account_employee.dart';
import 'package:aplikasi_rw/modules/home/widgets/menu.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MenuFolderCreateAccout extends StatefulWidget {
  const MenuFolderCreateAccout({Key key}) : super(key: key);

  @override
  State<MenuFolderCreateAccout> createState() => _MenuFolderCreateAccoutState();
}

class _MenuFolderCreateAccoutState extends State<MenuFolderCreateAccout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Akun'),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            children: [
              AutoSizeText(
                'Pilih bagian yang akan di tambah personil di lapangan.',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Color(0xff616161),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                maxFontSize: 15,
              ),
              SizedBox(
                height: 16.h,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Menu(
                        icon:
                            'assets/img/estate_manager_menu/perawatan-lanskap.jpg',
                        text: 'Perawatan Lanskap',
                        onTap: () {
                          Get.to(
                              () => CreateAccountEmployee(
                                    division: 'Landscape',
                                    title:
                                        'Tambah personil di bagian perawatan lanskap.',
                                    job: '1',
                                  ),
                              transition: Transition.cupertino);
                        },
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Menu(
                        icon:
                            'assets/img/estate_manager_menu/mekanikel_elektrikel.jpg',
                        text: 'Mekanikel & Elektrikel',
                        onTap: () {
                          Get.to(
                              () => CreateAccountEmployee(
                                    division: 'ME',
                                    title:
                                        'Tambah personil di bagian mekanikel dan elektrikel.',
                                    job: '2',
                                  ),
                              transition: Transition.cupertino);
                        },
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Menu(
                        icon:
                            'assets/img/estate_manager_menu/building_controll.jpg',
                        text: 'Building Controll',
                        onTap: () {
                          Get.to(
                              () => CreateAccountEmployee(
                                    division: 'Building controll dan perizinan',
                                    title:
                                        'Tambah personil di bagian building controll.',
                                    job: '3',
                                  ),
                              transition: Transition.cupertino);
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    children: [
                      Menu(
                        icon:
                            'assets/img/estate_manager_menu/permasalahan-keamanan.jpg',
                        text: 'Masalah Keamanan',
                        onTap: () {
                          Get.to(
                              () => CreateAccountEmployee(
                                    division: 'Kemanan / Security',
                                    title: 'Tambah personil di bagian kemanan',
                                    job: '3',
                                  ),
                              transition: Transition.cupertino);
                        },
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
