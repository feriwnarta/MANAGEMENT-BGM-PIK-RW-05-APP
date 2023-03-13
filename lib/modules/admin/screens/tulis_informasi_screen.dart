import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TulisInformasiScreen extends StatelessWidget {
  const TulisInformasiScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: Size(360, 800),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Tulis Informasi'),
        systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          vertical: 16.h,
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 12.h),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image(
                        width: 70.w,
                        height: 72.h,
                        image:
                            AssetImage('assets/img/admin/informasi-warga.jpg'),
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
                              height: 4.h,
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
            SizedBox(
              height: 16.h,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 12.h),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image(
                        width: 70.w,
                        height: 72.h,
                        image:
                            AssetImage('assets/img/admin/informasi-umum.jpg'),
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
                              height: 4.h,
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
          ],
        ),
      ),
    );
  }
}
