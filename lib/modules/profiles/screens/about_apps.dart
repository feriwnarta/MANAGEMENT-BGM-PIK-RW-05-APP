import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutApps extends StatefulWidget {
  const AboutApps({Key key}) : super(key: key);

  @override
  State<AboutApps> createState() => _AboutAppsState();
}

class _AboutAppsState extends State<AboutApps> {
  final AssetImage image = AssetImage('assets/img/logo_rw.png');

  @override
  void didChangeDependencies() async {
    precacheImage(image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));

    return Scaffold(
      appBar: AppBar(
        title: Text('Tentang Aplikasi BGM PIK'),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 40.h,
                ),
                Image(
                  width: 54.w,
                  height: 64.h,
                  fit: BoxFit.cover,
                  image: image,
                ),
                SizedBox(
                  height: 16.h,
                ),
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) => (snapshot.hasData)
                      ? AutoSizeText(
                          'Versi ${snapshot.data.version}',
                          maxLines: 2,
                          style: TextStyle(fontSize: 16.sp),
                          minFontSize: 10,
                          overflow: TextOverflow.ellipsis,
                        )
                      : CircularProgressIndicator.adaptive(),
                ),
                SizedBox(
                  height: 28.h,
                ),
                AutoSizeText(
                  'BGM PIK merupakan Platform Aplikasi yang menyediakan layanan dan informasi, baik yang disediakan oleh Pengelola komplek perumahan Bukit Golf Mediterania Pantai Indah Kapuk maupun oleh warga.',
                  maxLines: 10,
                  minFontSize: 10,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Color(0xff404040),
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
