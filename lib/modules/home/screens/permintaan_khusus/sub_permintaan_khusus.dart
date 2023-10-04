import 'package:aplikasi_rw/modules/home/screens/permintaan_khusus/category_permintaan.dart';
import 'package:aplikasi_rw/modules/home/screens/permintaan_khusus/riwayat_permintaan.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubPermintaanKhusus extends StatelessWidget {
  SubPermintaanKhusus({Key key}) : super(key: key);

  final RxBool isCategory = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Permintaan Khusus',
        style: TextStyle(fontSize: SizeConfig.text(19)),
      )),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.width(16),
            vertical: SizeConfig.height(16),
          ),
          child: Obx(
            () => Column(
              children: [
                GestureDetector(
                  onTap: () {
                    isCategory.value = true;
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.width(6),
                      vertical: SizeConfig.height(12),
                    ),
                    decoration: (isCategory.value)
                        ? BoxDecoration(
                            border: Border.all(color: Color(0xff2094F3)),
                            borderRadius: BorderRadius.circular(10),
                          )
                        : null,
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/img/citizen_menu/kategori-permintaan.png",
                          width: SizeConfig.image(48),
                          height: SizeConfig.image(48),
                        ),
                        SizedBox(
                          width: SizeConfig.width(16),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kategori Permintaan',
                                style: TextStyle(
                                  fontSize: SizeConfig.text(14),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.height(4),
                              ),
                              Text(
                                  "Berbagai macam permintaan yang dapat Anda pilih. Setiap kategori merupakan pintu gerbang menuju beragam layanan dan pengalaman yang kami tawarkan.",
                                  style: TextStyle(
                                    fontSize: SizeConfig.text(12),
                                    color: Color(0xff616161),
                                    fontWeight: FontWeight.w400,
                                  ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.height(16),
                ),
                GestureDetector(
                  onTap: () {
                    isCategory.value = false;
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.width(6),
                      vertical: SizeConfig.height(12),
                    ),
                    decoration: (!isCategory.value)
                        ? BoxDecoration(
                            border: Border.all(color: Color(0xff2094F3)),
                            borderRadius: BorderRadius.circular(10),
                          )
                        : null,
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/img/citizen_menu/riwayat-permintaan.png",
                          width: SizeConfig.image(48),
                          height: SizeConfig.image(48),
                        ),
                        SizedBox(
                          width: SizeConfig.width(16),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Riwayat Permintaan',
                                style: TextStyle(
                                  fontSize: SizeConfig.text(14),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.height(4),
                              ),
                              Text(
                                  "Di sini adalah riwayat lengkap permintaan Anda pada layanan kami. Anda dapat melihat segala proses dari mulai permintaan dibuat, di kerjakan oleh tim kami dan menyelesaikan permintaan anda dengan baik.",
                                  style: TextStyle(
                                    fontSize: SizeConfig.text(12),
                                    color: Color(0xff616161),
                                    fontWeight: FontWeight.w400,
                                  ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.height(292),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onPressed: () {
                      // panggil view kategori
                      if (isCategory.value) {
                        Get.to(
                          CategoryPermintaan(),
                          transition: Transition.rightToLeft,
                        );
                        return;
                      }

                      Get.to(
                        RiwayatPermintaan(),
                        transition: Transition.rightToLeft,
                      );
                    },
                    child: Text('Selanjutnya'),
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
