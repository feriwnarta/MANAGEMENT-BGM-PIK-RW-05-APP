import 'dart:async';
import 'dart:io';
import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/modules/admin/screens/tulis_informasi_screen.dart';
import 'package:aplikasi_rw/modules/authentication/controllers/access_controller.dart';
import 'package:aplikasi_rw/modules/estate_manager/screens/menu_folder_create_account.dart';
import 'package:aplikasi_rw/modules/home/controller/notification_controller.dart';
import 'package:aplikasi_rw/modules/home/data/ShowCaseData.dart';
import 'package:aplikasi_rw/modules/home/models/card_news.dart';
import 'package:aplikasi_rw/modules/home/screens/notification_screen.dart';
import 'package:aplikasi_rw/modules/home/services/news_service.dart';
import 'package:aplikasi_rw/modules/home/widgets/header_screen.dart';
import 'package:aplikasi_rw/modules/home/widgets/menu.dart';
import 'package:aplikasi_rw/modules/theme/sizer.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../server-app.dart';
import '../../informasi_warga/screens/read_informasi_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<AdminScreen> {
  final userLoginController = Get.put(UserLoginController());
  final accesController = Get.put(AccessController());
  NotificationController controller = Get.put(NotificationController());
  final AssetImage image = AssetImage('assets/img/logo_rw.png');
  final ShowCaseData dataShowCase = ShowCaseData();

  @override
  void initState() {
    super.initState();

    controller.timer.value = Timer.periodic(
      Duration(seconds: 5),
      (_) {
        controller.getCountNotif();
      },
    );

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async => await displayDialogPermission(),
    );
  }

  /// tampikan dialog permision
  Future<void> displayDialogPermission() async {
    bool cameraPermission = await Permission.camera.status.isDenied;
    bool locationPermission = await Permission.location.status.isDenied;
    bool storagePermission = await Permission.storage.status.isDenied;

    // dialog akses kamera
    if (cameraPermission) {
      await dialogRequirePermissions(
        title: 'Berikan Akses Kamera',
        content:
            'Untuk menggunakan fitur yang membutuhkan kamera, kami memerlukan izin akses kamera Anda. Apakah Anda ingin memberikan izin akses sekarang?',
        no: () {
          Get.back();
        },
        yes: () async {
          await initPermisionCamera();
          Get.back();
        },
      );
    }

    // dialog akses lokasi
    if (locationPermission) {
      await dialogRequirePermissions(
        title: 'Berikan Akses Lokasi',
        content:
            'Untuk menggunakan fitur yang membutuhkan lokasi, kami memerlukan izin akses lokasi Anda. Apakah Anda ingin memberikan izin akses sekarang?',
        no: () {
          Get.back();
        },
        yes: () async {
          await initPermissionLocation();
          Get.back();
        },
      );
    }

    // dialog akses Media
    if (storagePermission) {
      await dialogRequirePermissions(
        title: 'Berikan Akses Media',
        content:
            'Untuk menggunakan fitur yang membutuhkan akses media, kami memerlukan izin akses media Anda. Apakah Anda ingin memberikan izin akses sekarang?',
        no: () {
          Get.back();
        },
        yes: () async {
          await initPermisionStorage();
          Get.back();
        },
      );
    }
  }

  Future<dynamic> dialogRequirePermissions(
      {String title, String content, Function yes, Function no}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      useSafeArea: true,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              fontSize: SizeConfig.text(16),
            ),
          ),
          content: Text(
            content,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: SizeConfig.text(12), color: Colors.grey),
          ),
          titlePadding: EdgeInsets.symmetric(
            horizontal: SizeConfig.width(16),
            vertical: SizeConfig.height(8),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: SizeConfig.width(16),
            vertical: SizeConfig.height(8),
          ),
          actions: [
            TextButton(
              onPressed: no,
              child: Text(
                'Tidak',
                style: TextStyle(fontSize: SizeConfig.text(14)),
              ),
            ),
            TextButton(
              onPressed: yes,
              child: Text(
                'Ya',
                style: TextStyle(fontSize: SizeConfig.text(14)),
              ),
            ),
          ],
          actionsPadding: EdgeInsets.symmetric(
            horizontal: SizeConfig.width(16),
            vertical: 0,
          ),
        );
      },
    );
  }

  /// inisialisasi ijin akses camera
  Future<bool> initPermisionCamera() async {
    // akses kamera
    bool permissionCamera = await Permission.camera.status.isDenied;

    if (permissionCamera) {
      PermissionStatus statusCamera = await Permission.camera.request();

      if (statusCamera.isGranted) {
        return true;
      }

      return false;
    }

    return false;
  }

  /// inisialisasi ijin akses storage
  Future<bool> initPermisionStorage() async {
    // akses storage
    bool permissionStorage = await Permission.storage.status.isGranted;

    if (!permissionStorage) {
      PermissionStatus accessStorage = await Permission.storage.request();

      if (accessStorage.isGranted) {
        return true;
      }

      return false;
    }

    return false;
  }

  /// inisialisasi ijin akses lokasi
  Future<bool> initPermissionLocation() async {
    // akses storage
    bool permissionLocation = await Permission.location.status.isDenied;

    if (permissionLocation) {
      PermissionStatus accessLocation = await Permission.location.request();

      if (accessLocation.isGranted) {
        return true;
      }

      return false;
    }

    return false;
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
                fontSize: SizeConfig.text(19),
                color: Colors.blue,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        title: Image(
          width: SizeConfig.width(34),
          height: SizeConfig.height(40),
          image: image,
          fit: BoxFit.cover,
          repeat: ImageRepeat.noRepeat,
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: SizeConfig.width(24)),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (Platform.isAndroid)
                  ? HeaderScreen(
                      isEmOrCord: true,
                    )
                  : SizedBox(
                      height: SizeConfig.height(32),
                    ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.width(16),
                ),
                child: listOfMenu(),
              ),
              SizedBox(
                height: SizeConfig.height(70),
              ),
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
          icon: 'assets/img/estate_manager_menu/add_account.jpg',
          onTap: () {
            Get.to(
              () => MenuFolderCreateAccout(),
              transition: Transition.rightToLeft,
            );
          },
          text: 'Tambah Akun',
        ),
        Menu(
          icon: 'assets/img/tulis-informasi.png',
          text: 'Tulis Informasi',
          onTap: () {
            Get.to(
              () => TulisInformasiScreen(),
              transition: Transition.cupertino,
            );
          },
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
                        fontSize: SizeConfig.text(16),
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
                              fontSize: SizeConfig.text(14),
                              fontWeight: FontWeight.w500,
                              color: Color(0xff616161),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        : Text(
                            '${userLoginController.status.value}',
                            style: TextStyle(
                              fontSize: SizeConfig.text(14),
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
          height: SizeConfig.height(24),
        ),
        Divider(
          thickness: 1,
        ),
        SizedBox(
          height: SizeConfig.height(24),
        ),
        carouselNews(),
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
