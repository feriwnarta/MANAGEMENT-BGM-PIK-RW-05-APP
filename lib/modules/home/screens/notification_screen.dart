import 'dart:async';

import 'package:aplikasi_rw/modules/home/controller/notification_controller.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:readmore/readmore.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  var controller = Get.put(NotificationController());

  Timer timer;

  @override
  initState() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      controller.getNotif();
    });

    super.initState();
  }

  @override
  dispose() {
    if (timer != null && timer.isActive) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));

    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SingleChildScrollView(
        child: Obx(
          () =>
              (controller.listNotif != null && controller.listNotif.length == 0)
                  ? LinearProgressIndicator()
                  : Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 16.w,
                      ),
                      width: double.infinity,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 16.h,
                          ),
                          Column(
                            children: controller.listNotif
                                .map<Widget>(
                                  (e) => NotifiBody(
                                    content: e.content,
                                    time: e.time,
                                    title: e.title,
                                    urlProfile: e.urlImage,
                                  ),
                                )
                                .toList(),
                          )
                        ],
                      ),
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
                      '${ServerApp.url}/$urlProfile'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: Column(
                  children: [
                    SizedBox(
                      width: 296.w,
                      child: AutoSizeText(
                        '$title',
                        style: TextStyle(fontSize: 12.sp),
                        maxLines: 1,
                        minFontSize: 10,
                      ),
                    ),
                    SizedBox(
                      width: 296.w,
                      child: AutoSizeText(
                        '$time',
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
                        '$content',
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
