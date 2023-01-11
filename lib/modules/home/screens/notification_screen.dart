import 'package:aplikasi_rw/server-app.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readmore/readmore.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));

    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 16.w,
          ),
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(
                height: 16.h,
              ),
              NotifiBody(),
            ],
          ),
        ),
      ),
    );
  }
}

class NotifiBody extends StatelessWidget {
  const NotifiBody({
    Key key,
    this.content,
    this.time,
    this.title,
    this.urlProfile,
  }) : super(key: key);

  final String urlProfile, title, time, content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24.w,
                height: 24.h,
                child: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                      '${ServerApp.url}/imageuser/48b495679c59b614a64768263129ba5c9553efbc.jpg'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: Column(
                  children: [
                    SizedBox(
                      width: 296.w,
                      child: AutoSizeText(
                        'Donnita Q menanggapi postinganmu',
                        style: TextStyle(fontSize: 12.sp),
                        maxLines: 1,
                        minFontSize: 10,
                      ),
                    ),
                    SizedBox(
                      width: 296.w,
                      child: AutoSizeText(
                        '10 Menit Yang lalu',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Color(0xff9E9E9E),
                        ),
                        maxLines: 1,
                        minFontSize: 10,
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    SizedBox(
                      width: 296.w,
                      child: ReadMoreText(
                        'Di Cafe Cahaya Senja enak untuk nongkrong dan makanan nya recomended :) Di Cafe Cahaya Senja enak untuk nongkrong dan makanan nya recomended :) Di Cafe Cahaya Senja enak untuk nongkrong dan makanan nya recomended :)  Di Cafe Cahaya Senja enak untuk nongkrong dan makanan nya recomended :)',
                        trimLines: 3,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: ' Baca selengkapnya',
                        trimExpandedText: ' Baca lebih sedikit',
                        lessStyle:
                            TextStyle(fontSize: 10.sp, color: Colors.blue),
                        moreStyle: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.blue,
                        ),
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Color(0xff616161),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 8.h,
          ),
          Divider(
            thickness: 2,
          ),
        ],
      ),
    );
  }
}
