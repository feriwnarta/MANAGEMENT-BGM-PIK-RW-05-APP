import 'package:aplikasi_rw/modules/admin/screens/informasi_umum/informasi_umum_screen.dart';
import 'package:aplikasi_rw/modules/admin/screens/informasi_warga/informasi_warga_screen.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TulisInformasiScreen extends StatelessWidget {
  const TulisInformasiScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tulis Informasi'),
        systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(
                vertical: SizeConfig.height(16),
                horizontal: SizeConfig.width(16)),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Get.to(() => InformasiWarga());
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.width(6),
                        vertical: SizeConfig.height(12)),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image(
                              width: SizeConfig.width(70),
                              height: SizeConfig.height(72),
                              image: AssetImage(
                                  'assets/img/admin/informasi-warga.jpg'),
                            ),
                            SizedBox(
                              width: SizeConfig.width(16),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Informasi Warga',
                                    style: TextStyle(
                                      fontSize: SizeConfig.text(14),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.height(4),
                                  ),
                                  Text(
                                    'Informasi untuk warga yang berisikan tentang kependudukan seperti pembuatan KTP, KK, Akta Lahir, Surat Pindah dan lainnya.',
                                    style: TextStyle(
                                      fontSize: SizeConfig.text(12),
                                      color: Color(0xff616161),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.height(16),
                ),
                InkWell(
                  onTap: () {
                    Get.to(InformasiUmum(), transition: Transition.cupertino);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.width(6),
                        vertical: SizeConfig.height(12)),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image(
                              width: SizeConfig.width(70),
                              height: SizeConfig.height(72),
                              image: AssetImage(
                                  'assets/img/admin/informasi-umum.jpg'),
                            ),
                            SizedBox(
                              width: SizeConfig.width(16),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Informasi Umum',
                                    style: TextStyle(
                                      fontSize: SizeConfig.text(14),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.height(4),
                                  ),
                                  Text(
                                    'Informasi untuk warga yang berisikan tentang informasi umum yang ada di wilayah PIK dan Jakarta seperti informasi lalu lintas, informasi tempat hiburan dan lainnya.',
                                    style: TextStyle(
                                      fontSize: SizeConfig.text(12),
                                      color: Color(0xff616161),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
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
