import 'dart:async';
import 'dart:io';
import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/modules/authentication/controllers/access_controller.dart';
import 'package:aplikasi_rw/modules/estate_manager/screens/dashboard.dart';
import 'package:aplikasi_rw/modules/home/controller/notification_controller.dart';
import 'package:aplikasi_rw/modules/home/data/ShowCaseData.dart';
import 'package:aplikasi_rw/modules/home/models/card_news.dart';
import 'package:aplikasi_rw/modules/home/screens/notification_screen.dart';
import 'package:aplikasi_rw/modules/home/services/news_service.dart';
import 'package:aplikasi_rw/modules/home/widgets/header_screen.dart';
import 'package:aplikasi_rw/modules/home/widgets/menu.dart';
import 'package:aplikasi_rw/modules/informasi_umum/informasi_umum_screen.dart';
import 'package:aplikasi_rw/modules/informasi_warga/screens/informasi_warga_screen.dart';
import 'package:aplikasi_rw/modules/payment_ipl/screens/history/payment_ipl_history.dart';
import 'package:aplikasi_rw/modules/report_screen/screens/report_screen_2.dart';
import 'package:aplikasi_rw/modules/report_screen/screens/sub_menu_report.dart';
import 'package:aplikasi_rw/modules/social_media/screens/social_media_screen.dart';
import 'package:aplikasi_rw/modules/theme/sizer.dart';
import 'package:aplikasi_rw/modules/util_widgets/init_permission.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
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
import 'package:showcaseview/showcaseview.dart';

import '../../../server-app.dart';
import '../../informasi_warga/screens/read_informasi_screen.dart';

class PengurusScreen extends StatefulWidget {
  const PengurusScreen({Key key}) : super(key: key);

  @override
  State<PengurusScreen> createState() => _PengurusScreenState();
}

class _PengurusScreenState extends State<PengurusScreen> {
  final userLoginController = Get.put(UserLoginController());
  final accesController = Get.put(AccessController());
  NotificationController controller = Get.put(NotificationController());
  final AssetImage image = AssetImage('assets/img/logo_rw.png');
  final ShowCaseData dataShowCase = ShowCaseData();

  // init permission
  InitPermissionApp initPermissionApp;

  @override
  void initState() {
    super.initState();

    controller.timer.value = Timer.periodic(
      Duration(seconds: 5),
      (_) {
        controller.getCountNotif();
      },
    );

    initPermissionApp = InitPermissionApp();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async => await initPermissionApp.initPermissionApp(context),
    );
  }

  @override
  void didChangeDependencies() {
    precacheImage(image, context);
    super.didChangeDependencies();
  }

  void initShowCase(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ShowCaseWidget.of(context).startShowCase(
        [
          dataShowCase.news,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final logger = Logger();
    logger.i(userLoginController.accessCordinator.value);

    ScreenUtil.init(context,
        designSize: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height));

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Color(0xff2094F3),
        ),
        leadingWidth: SizeConfig.width(200),
        leading: Row(
          children: [
            SizedBox(
              width: SizeConfig.width(16),
            ),
            Text(
              'BGM RW 05',
              style: TextStyle(
                fontSize: (19 / Sizer.slicingText) * SizeConfig.textMultiplier,
                color: Colors.blue,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        title: Image(
          width: (34 / Sizer.slicingWidth) * SizeConfig.widthMultiplier,
          height: (40 / Sizer.slicingHeight) * SizeConfig.heightMultiplier,
          image: image,
          fit: BoxFit.cover,
          repeat: ImageRepeat.noRepeat,
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(
                right: (25 / Sizer.slicingWidth) * SizeConfig.widthMultiplier),
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
                  showBadge: (controller.count.value == '0') ? false : true,
                  badgeContent: Text(
                    '${controller.count.value}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: (11 / SizeConfig.textMultiplier) *
                            SizeConfig.textMultiplier),
                  ),
                  position: BadgePosition.topEnd(top: 8, end: -8),
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              (Platform.isAndroid)
                  ? HeaderScreen(
                      isEmOrCord: true,
                    )
                  : SizedBox(
                      height: (32 / Sizer.slicingHeight) *
                          SizeConfig.heightMultiplier,
                    ),
              (Platform.isIOS) ? headerScreenIos() : SizedBox(),
              // SizedBox(
              //   height:
              //       (24 / Sizer.slicingHeight) * SizeConfig.heightMultiplier,
              // ),
              // Divider(
              //   thickness: 1,
              // ),
              // SizedBox(
              //   height:
              //       (24 / Sizer.slicingHeight) * SizeConfig.heightMultiplier,
              // ),
              Obx(
                () => Column(
                  children: [
                    listOfMenu(),
                  ],
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

  Wrap listOfMenu() {
    return Wrap(
      alignment: WrapAlignment.start,
      runSpacing: (16 / Sizer.slicingHeight) * SizeConfig.heightMultiplier,
      spacing: (13 / Sizer.slicingWidth) * SizeConfig.widthMultiplier,
      children: [
        Menu(
          icon: 'assets/img/estate_manager_menu/dashboard-em.jpg',
          onTap: () {
            Get.to(
              () => DashboardEm(),
              transition: Transition.rightToLeft,
            );
          },
          text: 'Dashboard',
        ),
        Menu(
          icon: 'assets/img/estate_manager_menu/status_peduli_lingkungan.jpg',
          onTap: () {
            Get.to(
              () => SubMenuReport(
                typeStatusPeduliLingkungan: 'pengelola',
              ),
              transition: Transition.rightToLeft,
            );
          },
          text: 'Status Peduli Lingkungan',
        ),
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
                icon: 'assets/img/citizen_menu/status-peduli-lingkungan.jpg',
                text: 'Status peduli lingkungan',
                onTap: () => Get.to(() => ReportScreen2(),
                    transition: Transition.rightToLeft),
              )
            : Menu(
                icon: 'assets/img/citizen_menu/status-peduli-lingkungan.jpg',
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
                icon: 'assets/img/citizen_menu/informasi-warga.jpg',
                text: 'Informasi Warga',
                onTap: () => Get.to(
                  () => InformasiWargaScreen(),
                  transition: Transition.rightToLeft,
                ),
              )
            : Menu(
                icon: 'assets/img/citizen_menu/informasi-warga.jpg',
                text: 'Informasi Warga',
                onTap: () => EasyLoading.showInfo(
                    'Fitur ini hanya bisa diakses oleh warga')),
        (accesController.informasiUmum.value)
            ? Menu(
                icon: 'assets/img/citizen_menu/informasi-umum.jpg',
                text: 'Informasi Umum',
                onTap: () {
                  Get.to(InformasiUmum(), transition: Transition.cupertino);
                },
              )
            : Menu(
                icon: 'assets/img/citizen_menu/informasi-umum.jpg',
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
    );
  }

  Column headerScreenIos() {
    return Column(
      children: [
        Container(
          height: (48 / Sizer.slicingHeight) * SizeConfig.heightMultiplier,
          margin: EdgeInsets.symmetric(
              horizontal:
                  (16 / Sizer.slicingWidth) * SizeConfig.widthMultiplier),
          child: Row(
            children: [
              SizedBox(
                height: SizeConfig.image(48),
                width: SizeConfig.image(48),
                child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                        '${ServerApp.url}${userLoginController.urlProfile.value}')),
              ),
              SizedBox(
                width: (14 / Sizer.slicingWidth) * SizeConfig.widthMultiplier,
              ),
              SizedBox(
                width: (257 / Sizer.slicingWidth) * SizeConfig.widthMultiplier,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${userLoginController.name.value}',
                      style: TextStyle(
                        fontSize: (16 / Sizer.slicingText) *
                            SizeConfig.textMultiplier,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    (userLoginController.status.value
                            .isCaseInsensitiveContainsAny('WARGA'))
                        ? Text(
                            '${userLoginController.cluster.value} ${userLoginController.houseNumber.value}',
                            style: TextStyle(
                              fontSize: (14 / Sizer.slicingText) *
                                  SizeConfig.textMultiplier,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff616161),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        : Text(
                            '${userLoginController.status.value}',
                            style: TextStyle(
                              fontSize: (14 / Sizer.slicingText) *
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
          height: (24 / Sizer.slicingHeight) * SizeConfig.heightMultiplier,
        ),
        Divider(
          thickness: 1,
        ),
        SizedBox(
          height: (24 / Sizer.slicingHeight) * SizeConfig.heightMultiplier,
        ),
      ],
    );
  }

  SizedBox carouselNews() {
    return SizedBox(
      child: FutureBuilder<List<CardNews>>(
        future: NewsServices.getNews(),
        builder: (context, snapshot) =>
            (snapshot.hasData) ? carouselContent(snapshot) : carouselShimmer(),
      ),
    );
  }

  CarouselSlider carouselContent(AsyncSnapshot<List<CardNews>> snapshot) {
    return CarouselSlider(
      options: CarouselOptions(
        height: SizeConfig.height(188),
        // aspectRatio: 16 / 2,
        enableInfiniteScroll: false,
        enlargeCenterPage: false,
        viewportFraction: 0.8,
      ),
      items: snapshot.data.map((e) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () => Get.to(() => ReadInformation(),
                  transition: Transition.rightToLeft, arguments: [e.content]),
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(
                  right: (16 / Sizer.slicingWidth) * SizeConfig.widthMultiplier,
                ),
                child: CachedNetworkImage(
                  imageUrl: '${ServerApp.url}${e.url}',
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  CarouselSlider carouselShimmer() {
    return CarouselSlider(
      options: CarouselOptions(
        height: (188 / Sizer.slicingHeight) * SizeConfig.heightMultiplier,
        enableInfiniteScroll: false,
        enlargeCenterPage: false,
        viewportFraction: 0.8,
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
                    borderRadius: BorderRadius.circular(10)),
                width: MediaQuery.of(context).size.width,
                height:
                    (188 / Sizer.slicingHeight) * SizeConfig.heightMultiplier,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
