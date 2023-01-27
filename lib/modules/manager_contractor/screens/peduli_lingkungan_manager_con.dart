import 'package:aplikasi_rw/modules/contractor/screens/complaint/laporan_selesai.dart';
import 'package:aplikasi_rw/modules/manager_contractor/screens/laporan_masuk_manager_con.dart';
import 'package:aplikasi_rw/modules/manager_contractor/screens/laporan_proses_manager_con.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PeduliLingkunganManagerCon extends StatefulWidget {
  const PeduliLingkunganManagerCon({Key key}) : super(key: key);

  @override
  State<PeduliLingkunganManagerCon> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<PeduliLingkunganManagerCon> {
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
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          child: Column(
            children: [
              AutoSizeText(
                'Kepedulian lingkungan yang di tujukan untuk area lingkungan umum yang ada di Bukit Golf Mediterania RW 05.',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Color(0xff616161),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
              ),
              SizedBox(
                height: 32.h,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(
                        () => LaporanMasukManagerCon(
                          status: 'bukan finish',
                        ),
                        transition: Transition.rightToLeft,
                      );
                    },
                    highlightColor: Colors.grey.withOpacity(0.1),
                    child: SizedBox(
                      width: 70.w,
                      child: Column(
                        children: [
                          Image(
                            height: 72.h,
                            image: imageLaporanMasuk,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          AutoSizeText(
                            'Laporan Masuk',
                            style: TextStyle(
                              fontSize: 12.sp,
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(
                        () => LaporanDiprosesManagerCon(),
                        transition: Transition.cupertino,
                      );
                    },
                    child: SizedBox(
                      width: 70.w,
                      child: Column(
                        children: [
                          Image(
                            height: 72.h,
                            image: imageLaporanDiproses,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          AutoSizeText(
                            'Laporan Diproses',
                            style: TextStyle(
                              fontSize: 12.sp,
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                  InkWell(
                    onTap: () {},
                    child: SizedBox(
                      width: 70.w,
                      child: Column(
                        children: [
                          Image(
                            height: 72.h,
                            image: imageLaporanSelesai,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          AutoSizeText(
                            'Laporan Selesai',
                            style: TextStyle(
                              fontSize: 12.sp,
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
