import 'dart:async';
import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/modules/admin/screens/tulis_informasi_screen.dart';
import 'package:aplikasi_rw/modules/authentication/controllers/access_controller.dart';
import 'package:aplikasi_rw/modules/estate_manager/screens/dashboard.dart';
import 'package:aplikasi_rw/modules/estate_manager/screens/menu_folder_create_account.dart';
import 'package:aplikasi_rw/modules/home/controller/notification_controller.dart';
import 'package:aplikasi_rw/modules/home/data/ShowCaseData.dart';
import 'package:aplikasi_rw/modules/home/models/card_news.dart';
import 'package:aplikasi_rw/modules/home/screens/notification_screen.dart';
import 'package:aplikasi_rw/modules/home/screens/show_case_widget.dart';
import 'package:aplikasi_rw/modules/home/services/news_service.dart';
import 'package:aplikasi_rw/modules/home/widgets/menu.dart';
import 'package:aplikasi_rw/modules/informasi_umum/informasi_umum_screen.dart';
import 'package:aplikasi_rw/modules/informasi_warga/screens/informasi_warga_screen.dart';
import 'package:aplikasi_rw/modules/payment_ipl/screens/history/payment_ipl_history.dart';
import 'package:aplikasi_rw/modules/report_screen/screens/report_screen_2.dart';
import 'package:aplikasi_rw/modules/report_screen/screens/sub_menu_report.dart';
import 'package:aplikasi_rw/modules/social_media/screens/social_media_screen.dart';
import 'package:aplikasi_rw/modules/theme/sizer.dart';
import 'package:aplikasi_rw/modules/util_widgets/init_permission.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../server-app.dart';
import '../../informasi_warga/screens/read_informasi_screen.dart';

class MasterScreen extends StatefulWidget {
  const MasterScreen({Key key}) : super(key: key);

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  final userLoginController = Get.put(UserLoginController());
  final accesController = Get.put(AccessController());
  NotificationController controller = Get.put(NotificationController());
  final AssetImage image = AssetImage('assets/img/logo_rw.png');

  final ShowCaseData dataShowCase = ShowCaseData();

  final GlobalKey dashboard = GlobalKey();
  final GlobalKey statusPeduliPengurus = GlobalKey();
  final GlobalKey tambahAkun = GlobalKey();
  final GlobalKey tulisInformasi = GlobalKey();
  final GlobalKey peduliLingkunganKey = GlobalKey();
  final GlobalKey statusPeduliLingkuganKey = GlobalKey();
  final GlobalKey statusIplKey = GlobalKey();
  final GlobalKey informasiWarga = GlobalKey();
  final GlobalKey informasiUmum = GlobalKey();
  final GlobalKey sosialMedia = GlobalKey();
  final GlobalKey dashboardKey = GlobalKey();

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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initPermissionApp.initPermissionApp(context);

      var value = await UserSecureStorage.readKey(key: 'runOnFirst');

      if (value == null) {
        await ShowCaseWidget.of(context).startShowCase(
          [
            dashboardKey,
            statusPeduliPengurus,
            peduliLingkunganKey,
            statusPeduliLingkuganKey,
            statusIplKey,
            informasiWarga,
            informasiUmum,
            sosialMedia,
            tambahAkun,
            tulisInformasi,
          ],
        );
      }

      await UserSecureStorage.setKeyValue(key: 'runOnFirst', value: 'true');
    });
  }

  @override
  void didChangeDependencies() {
    precacheImage(image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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
                fontSize: SizeConfig.text(19),
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
              headerScreen(),
              listOfMenu(),
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
        ShowCaseWrapper(
          gKey: dashboardKey,
          title: 'Dashboard',
          description:
              'Dengan fitur dashboard pengurus dapat melihat jumlah laporan selesai, dikerjakan, dan sedang diproses beserta grafik yang dipresentasikan',
          child: Menu(
            icon: 'assets/img/estate_manager_menu/dashboard-em.jpg',
            onTap: () {
              Get.to(
                () => DashboardEm(),
                transition: Transition.rightToLeft,
              );
            },
            text: 'Dashboard',
          ),
        ),
        ShowCaseWrapper(
          gKey: statusPeduliPengurus,
          title: 'Status peduli lingkungan pengurus',
          description:
              'Kini, dengan fitur peduli lingkungan pengurus yang terdapat pada aplikasi ini. menampilkan laporan masuk dan belum mendapatkan penanganan kordinator terkait',
          child: Menu(
            icon: 'assets/img/estate_manager_menu/status_peduli_lingkungan.jpg',
            onTap: () {
              Get.to(
                () => SubMenuReport(
                  typeStatusPeduliLingkungan: 'pengelola',
                ),
                transition: Transition.rightToLeft,
              );
            },
            text: 'Status Peduli Lingkungan Pengurus',
          ),
        ),
        ShowCaseWrapper(
          gKey: peduliLingkunganKey,
          title: 'Peduli Lingkungan',
          description:
              'Kini, dengan fitur peduli lingkungan yang terdapat pada aplikasi ini, warga perumahan dapat turut serta dalam menjaga kebersihan dan keindahan lingkungan sekitar',
          child: Menu(
            icon: 'assets/img/citizen_menu/ipl.jpg',
            text: 'Peduli lingkungan',
            onTap: () => Get.to(
                () => SubMenuReport(
                      typeStatusPeduliLingkungan: 'warga',
                    ),
                transition: Transition.rightToLeft),
          ),
        ),
        ShowCaseWrapper(
          gKey: statusPeduliLingkuganKey,
          title: 'Status Peduli Linkungan',
          description:
              'Dengan fitur status peduli lingkungan pada aplikasi ini, pengguna dapat dengan mudah melihat daftar laporan warga yang terkait dengan lingkungan sekitar. Pengguna dapat mengecek status laporan,memberikan penilaian pekerja',
          child: Menu(
            icon: 'assets/img/citizen_menu/status-peduli-lingkungan.jpg',
            text: 'Status peduli lingkungan',
            onTap: () => Get.to(() => ReportScreen2(),
                transition: Transition.rightToLeft),
          ),
        ),
        ShowCaseWrapper(
          gKey: statusIplKey,
          title: 'Status Ipl',
          description:
              'Dengan fitur status peduli lingkungan pada aplikasi ini, pengguna dapat dengan mudah melihat daftar laporan warga yang terkait dengan lingkungan sekitar. Pengguna dapat mengecek status laporan,memberikan penilaian pekerja',
          child: Menu(
            icon: 'assets/img/citizen_menu/ipl.jpg',
            text: 'Status IPL\n',
            onTap: () => Get.to(
              () => PaymentIplHistory(),
              transition: Transition.rightToLeft,
            ),
          ),
        ),
        ShowCaseWrapper(
          gKey: informasiWarga,
          title: 'Informasi Warga',
          description:
              'Dengan fitur informasi warga pada aplikasi ini, pengguna dapat menerima informasi terbaru dari pengelola melalui aplikasi. Informasi yang disampaikan dapat berupa pengumuman penting, jadwal acara, atau perubahan kebijakan. Dengan adanya fitur ini, pengguna tidak perlu khawatir ketinggalan informasi terbaru yang terkait dengan kehidupan di lingkungan sekitar mereka.',
          child: Menu(
            icon: 'assets/img/citizen_menu/informasi-warga.jpg',
            text: 'Informasi Warga',
            onTap: () => Get.to(
              () => InformasiWargaScreen(),
              transition: Transition.rightToLeft,
            ),
          ),
        ),
        ShowCaseWrapper(
          gKey: informasiUmum,
          title: 'Informasi Umum',
          description:
              'Terima Informasi Permasalahan Sekitar Perumahan Dengan fitur informasi umum pada aplikasi ini, Anda dapat menerima informasi mengenai permasalahan yang terjadi di sekitar perumahan Anda.',
          child: Menu(
            icon: 'assets/img/citizen_menu/informasi-umum.jpg',
            text: 'Informasi Umum',
            onTap: () {
              Get.to(InformasiUmum(), transition: Transition.cupertino);
            },
          ),
        ),
        ShowCaseWrapper(
          gKey: sosialMedia,
          title: 'Sosial Media',
          description:
              'Dengan fitur sosial media pada aplikasi ini, Anda dapat terhubung dengan tetangga dan warga perumahan lainnya. Memudahkan Anda untuk berkomunikasi dan berbagi informasi mengenai aktivitas atau acara yang diadakan di perumahan. Selain itu, fitur ini juga dapat membantu memperkuat hubungan antara warga perumahan, sehingga menciptakan rasa kebersamaan dan keakraban.',
          child: Menu(
            icon: 'assets/img/citizen_menu/media.jpg',
            text: 'Sosial Media',
            onTap: () =>
                Get.to(() => SocialMedia(), transition: Transition.rightToLeft),
          ),
        ),
        ShowCaseWrapper(
          gKey: tambahAkun,
          title: 'Tambah Akun',
          description:
              'Buat akun untuk pekerja lapangan, sehingga lingkungan perumahan dapat terkontrol dengan penggabungan pekerjaan lapangan dan aplikasi',
          child: Menu(
            icon: 'assets/img/estate_manager_menu/add_account.jpg',
            onTap: () {
              Get.to(
                () => MenuFolderCreateAccout(),
                transition: Transition.rightToLeft,
              );
            },
            text: 'Tambah Akun',
          ),
        ),
        ShowCaseWrapper(
          gKey: tulisInformasi,
          title: 'Tulis Informasi',
          description:
              'Segera buat informasi warga maupun umum, sampaikan kepada warga mengenai informasi terbaru dari pengelola serta permasalahan yang terjadi di sekitar perumahan',
          child: Menu(
            icon: 'assets/img/tulis-informasi.png',
            text: 'Tulis Informasi',
            onTap: () {
              Get.to(
                () => TulisInformasiScreen(),
                transition: Transition.cupertino,
              );
            },
          ),
        ),
      ],
    );
  }

  Column headerScreen() {
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
                  imageUrl: "${ServerApp.url}${e.url}",
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator.adaptive(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Icon(Icons.error),
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
