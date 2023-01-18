import 'dart:io';
import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/modules/home/services/news_service.dart';
import 'package:aplikasi_rw/modules/home/widgets/menu.dart';
import 'package:aplikasi_rw/modules/informasi_warga/screens/informasi_warga_screen.dart';
import 'package:aplikasi_rw/modules/payment_ipl/screens/history/payment_ipl_history.dart';
import 'package:aplikasi_rw/modules/report_screen/screens/report_screen_2.dart';
import 'package:aplikasi_rw/modules/report_screen/screens/sub_menu_report.dart';
import 'package:aplikasi_rw/modules/social_media/screens/social_media_screen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';

import '../../../server-app.dart';
import '../models/card_news.dart';
import '../widgets/header_screen.dart';

class CitizenScreen extends StatefulWidget {
  const CitizenScreen({Key key}) : super(key: key);

  @override
  State<CitizenScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<CitizenScreen> {
  final userLoginController = Get.put(UserLoginController());

  final AssetImage image = AssetImage('assets/img/logo_rw.png');

  @override
  void didChangeDependencies() {
    precacheImage(image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final logger = Logger();
    logger.i(userLoginController.accessCordinator.value);

    ScreenUtil.init(context, designSize: const Size(360, 800));

    return Scaffold(
      appBar: (Platform.isIOS)
          ? AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(
                color: Color(0xff2094F3),
              ),
              titleSpacing: 1,
              title: Row(
                children: [
                  AutoSizeText(
                    'BGM RW 05',
                    style: TextStyle(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff2094F3),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Image(
                    width: 34.w,
                    height: 40.h,
                    image: image,
                    fit: BoxFit.cover,
                    repeat: ImageRepeat.noRepeat,
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: InkWell(
                    splashColor: Colors.white,
                    borderRadius: BorderRadius.circular(200),
                    radius: 15.h,
                    onTap: () {},
                    child: Badge(
                      badgeColor: Colors.red,
                      // showBadge: () ? true : false,
                      badgeContent: Text(
                        '0',
                        style: TextStyle(color: Colors.white),
                      ),
                      position: BadgePosition.topEnd(top: -2, end: -10),
                      child: SvgPicture.asset(
                        'assets/img/image-svg/bell.svg',
                        color: Color(0xff404040),
                      ),
                      animationType: BadgeAnimationType.scale,
                    ),
                  ),
                ),
              ],
            )
          : PreferredSize(
              child: Container(),
              preferredSize: Size.fromHeight(0),
            ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              (Platform.isAndroid)
                  ? HeaderScreen(
                      isEmOrCord: false,
                    )
                  : SizedBox(
                      height: 32.h,
                    ),
              (Platform.isIOS)
                  ? Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16.h),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 48.h,
                                width: 48.w,
                                child: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        '${ServerApp.url}imageuser/default_profile/blank_profile_picture.jpg')),
                              ),
                              SizedBox(
                                width: 14.w,
                              ),
                              SizedBox(
                                width: 257.w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      '${userLoginController.username.value}',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    AutoSizeText(
                                      'Akasia golf',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff616161),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 24.h,
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        SizedBox(
                          height: 24.h,
                        ),
                        FutureBuilder<List<CardNews>>(
                          future: NewsServices.getNews(),
                          builder: (context, snapshot) => (snapshot.hasData)
                              ? CarouselSlider(
                                  options: CarouselOptions(
                                    height: 188.h,
                                    // aspectRatio: 16 / 2,
                                    enableInfiniteScroll: false,
                                    enlargeCenterPage: false,
                                    viewportFraction: 0.85,
                                  ),
                                  items: snapshot.data.map((e) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.only(right: 16.w),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                '${ServerApp.url}${e.url}',
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                                )
                              : CarouselSlider(
                                  options: CarouselOptions(
                                    height: 188.h,
                                    enableInfiniteScroll: false,
                                    enlargeCenterPage: false,
                                    viewportFraction: 0.9,
                                  ),
                                  items: [
                                    1,
                                    2,
                                    3,
                                  ].map((i) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return Shimmer.fromColors(
                                          baseColor: Colors.grey[300],
                                          highlightColor: Colors.grey[200],
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 188.h,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                          ),
                                        );
                                      },
                                    );
                                  }).toList(),
                                ),
                        ),
                      ],
                    )
                  : SizedBox(),
              SizedBox(
                height: 24.h,
              ),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: 24.h,
              ),
              Container(
                height: 236.h,
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Menu(
                          icon: 'assets/img/citizen_menu/ipl.jpg',
                          text: 'Peduli lingkungan',
                          onTap: () => Get.to(
                              () => SubMenuReport(
                                    typeStatusPeduliLingkungan: 'warga',
                                  ),
                              transition: Transition.rightToLeft),
                        ),
                        SizedBox(
                          width: 14.w,
                        ),
                        Menu(
                          icon:
                              'assets/img/citizen_menu/status-peduli-lingkungan.jpg',
                          text: 'Status peduli lingkungan',
                          onTap: () => Get.to(() => ReportScreen2(),
                              transition: Transition.rightToLeft),
                        ),
                        SizedBox(
                          width: 14.w,
                        ),
                        Menu(
                          icon: 'assets/img/citizen_menu/ipl.jpg',
                          text: 'Status IPL\n',
                          onTap: () => Get.to(
                            () => PaymentIplHistory(),
                            transition: Transition.rightToLeft,
                          ),
                        ),
                        SizedBox(
                          width: 14.w,
                        ),
                        Menu(
                          icon: 'assets/img/citizen_menu/informasi-warga.jpg',
                          text: 'Informasi Warga',
                          onTap: () => Get.to(
                            () => InformasiWargaScreen(),
                            transition: Transition.rightToLeft,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Row(
                      children: [
                        Menu(
                          icon: 'assets/img/citizen_menu/informasi-umum.jpg',
                          text: 'Informasi Umum',
                          onTap: () {},
                        ),
                        SizedBox(
                          width: 14.w,
                        ),
                        Menu(
                          icon: 'assets/img/citizen_menu/media.jpg',
                          text: 'Sosial Media',
                          onTap: () => Get.to(() => SocialMedia(),
                              transition: Transition.rightToLeft),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 70.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}
