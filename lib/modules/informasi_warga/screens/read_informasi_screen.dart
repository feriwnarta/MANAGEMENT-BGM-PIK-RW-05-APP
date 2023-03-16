import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:aplikasi_rw/utils/view_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

//ignore: must_be_immutable
class ReadInformation extends StatelessWidget {
  ReadInformation({Key key}) : super(key: key);
  var argumentData = Get.arguments;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));

    print(argumentData);

    return Scaffold(
      appBar: AppBar(
        title: Text('Informasi Warga'),
        titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
        systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.width(16),
              vertical: SizeConfig.height(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => Get.to(
                    ViewImage(
                      urlImage: '${ServerApp.url}${argumentData[2]}',
                    ),
                  ),
                  child: Container(
                    height: SizeConfig.image(188),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                            '${ServerApp.url}${argumentData[2]}'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.height(16),
                ),
                Text(
                  '${argumentData[0]}',
                  style: TextStyle(
                    fontSize: SizeConfig.text(22),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: SizeConfig.height(16),
                ),
                Text(
                  '${argumentData[1]}',
                  style: TextStyle(fontSize: SizeConfig.text(16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
