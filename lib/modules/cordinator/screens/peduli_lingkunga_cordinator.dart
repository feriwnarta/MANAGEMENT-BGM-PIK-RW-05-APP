import 'package:aplikasi_rw/modules/cordinator/screens/laporan_diproses_cordinator.dart';
import 'package:aplikasi_rw/modules/cordinator/screens/laporan_masuk_cordinator.dart';
import 'package:aplikasi_rw/modules/cordinator/screens/laporan_selesai_cordinator.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PeduliLingkunganCordinator extends StatefulWidget {
  const PeduliLingkunganCordinator({Key key}) : super(key: key);

  @override
  State<PeduliLingkunganCordinator> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<PeduliLingkunganCordinator> {
  final AssetImage imageLaporanMasuk = AssetImage(
    'assets/img/cordinator/laporan-masuk.jpg',
  );

  final AssetImage imageLaporanDiproses = AssetImage(
    'assets/img/cordinator/laporan-diproses.jpg',
  );

  final AssetImage imageLaporanSelesai = AssetImage(
    'assets/img/cordinator/laporan-selesai.jpg',
  );

  @override
  void didChangeDependencies() {
    precacheImage(imageLaporanMasuk, context);
    precacheImage(imageLaporanDiproses, context);
    precacheImage(imageLaporanSelesai, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));
    return Scaffold(
      appBar: AppBar(
        title: Text('Peduli Lingkungan Umum'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.width(16),
            vertical: SizeConfig.height(16),
          ),
          child: Column(
            children: [
              Text(
                'Kepedulian lingkungan yang di tujukan untuk area lingkungan umum yang ada di Bukit Golf Mediterania RW 05.',
                style: TextStyle(
                  fontSize: SizeConfig.text(16),
                  color: Color(0xff616161),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
              ),
              SizedBox(
                height: SizeConfig.height(32),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(
                        () => LaporanMasukCordinator(
                          status: 'bukan finish',
                        ),
                        transition: Transition.rightToLeft,
                      );
                    },
                    highlightColor: Colors.grey.withOpacity(0.1),
                    child: SizedBox(
                      width: SizeConfig.width(70),
                      child: Column(
                        children: [
                          Image(
                            height: SizeConfig.height(72),
                            image: imageLaporanMasuk,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            height: SizeConfig.height(8),
                          ),
                          Text(
                            'Laporan Masuk',
                            style: TextStyle(
                              fontSize: SizeConfig.text(12),
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.width(16),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(
                        () => LaporanDiprosesCordinator(),
                        transition: Transition.cupertino,
                      );
                    },
                    child: SizedBox(
                      width: SizeConfig.width(70),
                      child: Column(
                        children: [
                          Image(
                            height: SizeConfig.height(72),
                            image: imageLaporanDiproses,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            height: SizeConfig.height(8),
                          ),
                          Text(
                            'Laporan Diproses',
                            style: TextStyle(
                              fontSize: SizeConfig.text(12),
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.width(16),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(
                        () => LaporanSelesaiCordinator(status: 'SELESAI'),
                        transition: Transition.cupertino,
                      );
                    },
                    child: SizedBox(
                      width: SizeConfig.width(70),
                      child: Column(
                        children: [
                          Image(
                            height: SizeConfig.height(72),
                            image: imageLaporanSelesai,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            height: SizeConfig.height(8),
                          ),
                          Text(
                            'Laporan Selesai',
                            style: TextStyle(
                              fontSize: SizeConfig.text(12),
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
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
