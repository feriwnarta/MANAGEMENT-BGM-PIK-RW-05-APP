import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:flutter/material.dart';
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
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: SizeConfig.width(16)),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: SizeConfig.height(40),
                ),
                Image(
                  width: SizeConfig.width(54),
                  height: SizeConfig.height(64),
                  fit: BoxFit.cover,
                  image: image,
                ),
                SizedBox(
                  height: SizeConfig.height(16),
                ),
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) => (snapshot.hasData)
                      ? Text(
                          'Versi ${snapshot.data.version}',
                          maxLines: 2,
                          style: TextStyle(fontSize: SizeConfig.text(16)),
                          overflow: TextOverflow.ellipsis,
                        )
                      : CircularProgressIndicator.adaptive(),
                ),
                SizedBox(
                  height: SizeConfig.height(28),
                ),
                Text(
                  'BGM PIK merupakan Platform Aplikasi yang menyediakan layanan dan informasi, baik yang disediakan oleh Pengelola komplek perumahan Bukit Golf Mediterania Pantai Indah Kapuk maupun oleh warga.',
                  maxLines: 10,
                  style: TextStyle(
                    fontSize: SizeConfig.text(14),
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
