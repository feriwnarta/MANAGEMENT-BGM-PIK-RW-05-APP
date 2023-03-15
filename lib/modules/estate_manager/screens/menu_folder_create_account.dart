import 'package:aplikasi_rw/modules/estate_manager/screens/create_account_employee.dart';
import 'package:aplikasi_rw/modules/home/widgets/menu.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:flutter/material.dart';
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
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.width(16),
            vertical: SizeConfig.height(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih bagian yang akan di tambah personil di lapangan.',
                style: TextStyle(
                  fontSize: SizeConfig.text(16),
                  color: Color(0xff616161),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
              SizedBox(
                height: SizeConfig.height(16),
              ),
              Wrap(
                spacing: SizeConfig.width(16),
                runSpacing: SizeConfig.height(16),
                alignment: WrapAlignment.start,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
