import 'dart:io';

import 'package:aplikasi_rw/modules/admin/controllers/AdminController.dart';
import 'package:aplikasi_rw/modules/admin/services/admin_services.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:aplikasi_rw/utils/view_image_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class BuatInformasiUmumDetail extends StatelessWidget {
  BuatInformasiUmumDetail({Key key}) : super(key: key);

  final adminController = Get.put(AdminController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tulis Informasi Umum'),
        systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.width(16),
              vertical: SizeConfig.height(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: TextButton.styleFrom(
                        elevation: 0,
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: SizeConfig.text(14),
                          color: Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        EasyLoading.show(status: 'mengirim');

                        var result = await AdminServices.saveInformasiUmum(
                            urlImage: adminController.imagePath.value,
                            content: adminController.controllerContent.text,
                            title: adminController.controllerTitle.text);

                        if (result != null || result.isNotEmpty) {
                          if (result.isCaseInsensitiveContainsAny('OK')) {
                            EasyLoading.showSuccess('terkirim');
                            Get
                              ..back()
                              ..back()
                              ..back();

                            adminController.refreshShow2();

                            adminController.reset();

                            // Get.delete<AdminController>();
                          } else {
                            EasyLoading.showError('ada sesuatu yang salah');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Text(
                        'Posting Informasi',
                        style: TextStyle(
                          fontSize: SizeConfig.text(10),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: SizeConfig.height(32),
                ),
                Text(
                  'Thumbnail dan Judul',
                  style: TextStyle(
                      fontSize: SizeConfig.text(14),
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: SizeConfig.height(8),
                ),
                Text(
                  '${adminController.controllerTitle.text}',
                  style: TextStyle(
                    fontSize: SizeConfig.text(16),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: SizeConfig.height(8),
                ),
                Container(
                  width: double.infinity,
                  height: SizeConfig.height(188),
                  margin: EdgeInsets.only(bottom: SizeConfig.height(24)),
                  decoration: BoxDecoration(
                    color: Color(0xffEDEDED),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: (adminController.imagePath.value.isEmpty)
                      ? Center(
                          child: SvgPicture.asset(
                            'assets/img/admin/photograph.svg',
                            fit: BoxFit.cover,
                          ),
                        )
                      : InkWell(
                          onTap: () => Get.to(
                            ViewImageFile(
                              path: adminController.imagePath.value,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                repeat: ImageRepeat.noRepeat,
                                fit: BoxFit.cover,
                                image: FileImage(
                                  File(adminController.imagePath.value),
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
                SizedBox(
                  height: SizeConfig.height(24),
                ),
                Text(
                  'Isi Informasi',
                  style: TextStyle(
                      fontSize: SizeConfig.text(14),
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: SizeConfig.height(8),
                ),
                Text(
                  '${adminController.controllerContent.text}',
                  style: TextStyle(
                    fontSize: SizeConfig.text(14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
