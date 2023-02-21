import 'dart:async';
import 'dart:io';
import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/modules/authentication/controllers/access_controller.dart';
import 'package:aplikasi_rw/modules/home/controller/notification_controller.dart';
import 'package:aplikasi_rw/modules/home/screens/notification_screen.dart';
import 'package:aplikasi_rw/modules/home/services/news_service.dart';
import 'package:aplikasi_rw/modules/home/widgets/menu.dart';
import 'package:aplikasi_rw/modules/informasi_warga/screens/informasi_warga_screen.dart';
import 'package:aplikasi_rw/modules/payment_ipl/screens/history/payment_ipl_history.dart';
import 'package:aplikasi_rw/modules/report_screen/screens/report_screen_2.dart';
import 'package:aplikasi_rw/modules/report_screen/screens/sub_menu_report.dart';
import 'package:aplikasi_rw/modules/social_media/screens/social_media_screen.dart';
import 'package:aplikasi_rw/modules/theme/sizer.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';

import '../../../server-app.dart';
import '../../informasi_warga/screens/read_informasi_screen.dart';
import '../models/card_news.dart';
import '../widgets/header_screen.dart';

class CitizenScreen extends StatefulWidget {
  const CitizenScreen({Key key}) : super(key: key);

  @override
  State<CitizenScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<CitizenScreen> {
  final userLoginController = Get.put(UserLoginController());
  final accesController = Get.put(AccessController());
  NotificationController controller = Get.put(NotificationController());

  final AssetImage image = AssetImage('assets/img/logo_rw.png');

  @override
  void initState() {
    super.initState();

    if (Platform.isIOS) {
      controller.timer.value = Timer.periodic(
        Duration(seconds: 5),
        (_) {
          controller.getCountNotif();
        },
      );
    }
  }

  @override
  void didChangeDependencies() {
    precacheImage(image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final logger = Logger();
    logger.i(userLoginController.accessCordinator.value);

    ScreenUtil.init(context,
        designSize: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height));

    return Scaffold(
      appBar: (Platform.isIOS)
          ? AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(
                color: Color(0xff2094F3),
              ),
              titleSpacing: 10,
              title: Row(
                children: [
                  AutoSizeText(
                    'BGM RW 05',
                    style: Theme.of(context).textTheme.headline3,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    width:
                        (38 / Sizer.slicingWidth) * SizeConfig.widthMultiplier,
                  ),
                  Image(
                    width:
                        (34 / Sizer.slicingWidth) * SizeConfig.widthMultiplier,
                    height: (40 / Sizer.slicingHeight) *
                        SizeConfig.heightMultiplier,
                    image: image,
                    fit: BoxFit.cover,
                    repeat: ImageRepeat.noRepeat,
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(
                      right: (25 / Sizer.slicingWidth) *
                          SizeConfig.widthMultiplier),
                  child: Obx(
                    () => InkWell(
                      splashColor: Colors.white,
                      borderRadius: BorderRadius.circular(200),
                      radius: (15 / SizeConfig.heightMultiplier) *
                          SizeConfig.heightMultiplier,
                      onTap: () {
                        Get.to(
                          () => NotificationScreen(),
                          transition: Transition.rightToLeft,
                        );
                      },
                      child: Badge(
                        badgeColor: Colors.red,
                        padding: EdgeInsets.all(3),
                        badgeContent: Text(
                          '${controller.count.value}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: (11 / SizeConfig.textMultiplier) *
                                  SizeConfig.textMultiplier),
                        ),
                        position: BadgePosition.topEnd(top: 0, end: -10),
                        child: SvgPicture.asset(
                          'assets/img/image-svg/bell.svg',
                          color: Color(0xff404040),
                        ),
                        animationType: BadgeAnimationType.fade,
                      ),
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
                      height: (32 / Sizer.slicingHeight) *
                          SizeConfig.heightMultiplier,
                    ),
              (Platform.isIOS)
                  ? Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: (16 / SizeConfig.heightMultiplier) *
                                  SizeConfig.heightMultiplier),
                          child: Row(
                            children: [
                              SizedBox(
                                height: (48 / SizeConfig.heightMultiplier) *
                                    SizeConfig.heightMultiplier,
                                width: (48 / SizeConfig.widthMultiplier) *
                                    SizeConfig.widthMultiplier,
                                child: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        '${ServerApp.url}${userLoginController.urlProfile.value}')),
                              ),
                              SizedBox(
                                width: (14 / SizeConfig.widthMultiplier) *
                                    SizeConfig.widthMultiplier,
                              ),
                              SizedBox(
                                width: (257 / SizeConfig.widthMultiplier) *
                                    SizeConfig.widthMultiplier,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      '${userLoginController.name.value}',
                                      style: TextStyle(
                                        fontSize:
                                            (16 / SizeConfig.textMultiplier) *
                                                SizeConfig.textMultiplier,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    AutoSizeText(
                                      'Akasia golf',
                                      style: TextStyle(
                                        fontSize:
                                            (14 / SizeConfig.textMultiplier) *
                                                SizeConfig.textMultiplier,
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
                          height: (24 / SizeConfig.heightMultiplier) *
                              SizeConfig.heightMultiplier,
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        SizedBox(
                          height: (24 / SizeConfig.heightMultiplier) *
                              SizeConfig.heightMultiplier,
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
                                        return GestureDetector(
                                          onTap: () => Get.to(
                                              () => ReadInformation(),
                                              transition:
                                                  Transition.rightToLeft,
                                              arguments: [e.content]),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            margin:
                                                EdgeInsets.only(right: 16.w),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  '${ServerApp.url}${e.url}',
                                            ),
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
                height:
                    (24 / Sizer.slicingHeight) * SizeConfig.heightMultiplier,
              ),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height:
                    (24 / Sizer.slicingHeight) * SizeConfig.heightMultiplier,
              ),
              Obx(
                () => Container(
                  margin: EdgeInsets.symmetric(
                    horizontal:
                        (16 / Sizer.slicingWidth) * SizeConfig.widthMultiplier,
                  ),
                  child: Column(
                    children: [
                      Wrap(
                        alignment: WrapAlignment.start,
                        runSpacing: (16 / Sizer.slicingHeight) *
                            SizeConfig.heightMultiplier,
                        spacing: (16 / Sizer.slicingWidth) *
                            SizeConfig.widthMultiplier,
                        children: [
                          (accesController.statusPeduliLingkungan.value)
                              ? Menu(
                                  icon: 'assets/img/citizen_menu/ipl.jpg',
                                  text: 'Peduli lingkungan',
                                  onTap: () => Get.to(
                                      () => SubMenuReport(
                                            typeStatusPeduliLingkungan: 'warga',
                                          ),
                                      transition: Transition.rightToLeft),
                                )
                              : Menu(
                                  icon: 'assets/img/citizen_menu/ipl.jpg',
                                  text: 'Peduli lingkungan',
                                  onTap: () => EasyLoading.showInfo(
                                      'Fitur ini hanya bisa diakses oleh warga'),
                                ),
                          (accesController.statusPeduliLingkungan.value)
                              ? Menu(
                                  icon:
                                      'assets/img/citizen_menu/status-peduli-lingkungan.jpg',
                                  text: 'Status peduli lingkungan',
                                  onTap: () => Get.to(() => ReportScreen2(),
                                      transition: Transition.rightToLeft),
                                )
                              : Menu(
                                  icon:
                                      'assets/img/citizen_menu/status-peduli-lingkungan.jpg',
                                  text: 'Status peduli lingkungan',
                                  onTap: () => EasyLoading.showInfo(
                                      'Fitur ini hanya bisa diakses oleh warga'),
                                ),
                          (accesController.statusIpl.value)
                              ? Menu(
                                  icon: 'assets/img/citizen_menu/ipl.jpg',
                                  text: 'Status IPL\n',
                                  onTap: () => Get.to(
                                    () => PaymentIplHistory(),
                                    transition: Transition.rightToLeft,
                                  ),
                                )
                              : Menu(
                                  icon: 'assets/img/citizen_menu/ipl.jpg',
                                  text: 'Status IPL\n',
                                  onTap: () => EasyLoading.showInfo(
                                      'Fitur ini hanya bisa diakses oleh warga'),
                                ),
                          (accesController.informasiWarga.value)
                              ? Menu(
                                  icon:
                                      'assets/img/citizen_menu/informasi-warga.jpg',
                                  text: 'Informasi Warga',
                                  onTap: () => Get.to(
                                    () => InformasiWargaScreen(),
                                    transition: Transition.rightToLeft,
                                  ),
                                )
                              : Menu(
                                  icon:
                                      'assets/img/citizen_menu/informasi-warga.jpg',
                                  text: 'Informasi Warga',
                                  onTap: () => EasyLoading.showInfo(
                                      'Fitur ini hanya bisa diakses oleh warga')),
                          (accesController.informasiUmum.value)
                              ? Menu(
                                  icon:
                                      'assets/img/citizen_menu/informasi-umum.jpg',
                                  text: 'Informasi Umum',
                                  onTap: () {},
                                )
                              : Menu(
                                  icon:
                                      'assets/img/citizen_menu/informasi-umum.jpg',
                                  text: 'Informasi Umum',
                                  onTap: () => EasyLoading.showInfo(
                                      'Fitur ini hanya bisa diakses oleh warga'),
                                ),
                          (accesController.sosialMedia.value)
                              ? Menu(
                                  icon: 'assets/img/citizen_menu/media.jpg',
                                  text: 'Sosial Media',
                                  onTap: () => Get.to(() => SocialMedia(),
                                      transition: Transition.rightToLeft),
                                )
                              : Menu(
                                  icon: 'assets/img/citizen_menu/media.jpg',
                                  text: 'Sosial Media',
                                  onTap: () => EasyLoading.showInfo(
                                      'Fitur ini hanya bisa diakses oleh warga'),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height:
                    (70 / Sizer.slicingHeight) * SizeConfig.heightMultiplier,
              )
            ],
          ),
        ),
      ),
    );
  }
}
