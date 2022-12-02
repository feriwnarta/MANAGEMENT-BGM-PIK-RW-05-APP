import 'package:aplikasi_rw/bloc/bills_reguler_screen_bloc.dart';
import 'package:aplikasi_rw/bloc/bills_tab_bloc.dart';
import 'package:aplikasi_rw/bloc/carousel_bloc.dart';
import 'package:aplikasi_rw/bloc/comment_bloc.dart';
import 'package:aplikasi_rw/bloc/google_map_bloc.dart';
import 'package:aplikasi_rw/bloc/like_status_bloc.dart';
import 'package:aplikasi_rw/bloc/payment_bloc.dart';
import 'package:aplikasi_rw/bloc/shimmer_loading_bloc.dart';
import 'package:aplikasi_rw/controller/home_screen_controller.dart';
import 'package:aplikasi_rw/controller/indexscreen_home_controller.dart';
import 'package:aplikasi_rw/controller/report_user_controller.dart';
import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/model/bills_history_model.dart';
import 'package:aplikasi_rw/screen/bills_screen/bills_screen.dart';
import 'package:aplikasi_rw/screen/home_screen/home_screen.dart';
import 'package:aplikasi_rw/screen/report_screen2/report_screen_2.dart';
import 'package:aplikasi_rw/screen/splash_screen/SplashView.dart';
import 'package:aplikasi_rw/screen/user_screen/change_data_user.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/services/check_session.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'bloc/count_comment_bloc.dart';
import 'dart:io';
import 'lifecyle_manager.dart';
import './screen/management_screen/management_screen.dart';
// import 'package:sizer/sizer.dart' as s;

void main() async {
  // runApp(DevicePreview(enabled: !kReleaseMode, builder: (context) => MyApp()));
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // FirebaseMessaging m = FirebaseMessaging.instance;
  // m.configure(
  //   onMessage: (message) async {
  //     print('onn messagasdasde $message');
  //   },
  //   onLaunch: (message) async {
  //     print('onn laasdasdasdunc');
  //   },
  //   onResume: (message) async {
  //     print('onn resasdasdasdume');
  //   },
  // );
  // FirebaseMessaging.onMessage.listen((event) {

  // })

  // m.getToken().then((token) => print(token));

  // m.requestNotificationPermissions(
  //     const IosNotificationSettings(sound: true, badge: true, alert: true));

  ByteData data =
      await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());
  runApp(MyApp());

  // runApp(
  //   ShowCaseWidget(
  //     autoPlay: false,
  //     autoPlayLockEnable: false,
  //     builder: Builder(
  //       builder: (context) => MyApp(),
  //     ),
  //     onStart: (index, key) {
  //       print('onStart: $index, $key');
  //     },
  //     onComplete: (index, key) {
  //       print('onComplete: $index, $key');
  //     },
  //   ),
  // );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  final CheckSession checkSession = CheckSession();
  String initalState = '/';
  final controller = Get.put(UserLoginController());

  @override
  initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // *date format indonesia
    initializeDateFormatting('id_ID', null);

    return MultiBlocProvider(
      providers: [
        BlocProvider<CarouselBloc>(
          create: (context) => CarouselBloc(0),
        ),
        BlocProvider<BillTabColorBloc>(
          create: (context) => BillTabColorBloc(TabState()),
        ),
        BlocProvider<BillRegulerBloc>(
          create: (context) =>
              BillRegulerBloc(BillsHistoryModel.getBillsHistory()),
        ),
        BlocProvider<PaymentBloc>(
          create: (context) => PaymentBloc(true),
        ),
        BlocProvider<ShimmerLoadingBloc>(
          create: (context) => ShimmerLoadingBloc(true),
        ),
        BlocProvider<CommentBloc>(
          create: (context) =>
              CommentBloc(CommentBlocUnitialized())..add(CommentBlocEvent()),
        ),
        BlocProvider<CommentCountBloc>(
          create: (context) =>
              CommentCountBloc(CommentCountBlocState(countComment: '0')),
        ),
        BlocProvider<LikeStatusBloc>(
          create: (context) => LikeStatusBloc(LikeStatusState(
              colorButton: Colors.black, isLike: false, numberLike: '0')),
        ),
        BlocProvider<GoogleMapBloc>(
          create: (context) => GoogleMapBloc(GoogleMapState()),
        ),
      ],
      child: ScreenUtilInit(
        designSize: Size(360, 800),
        // allowFontScaling: false,
        minTextAdapt: true,
        builder: (context, child) => AppLifecycleManager(
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            home: SplashView(),
            theme: ThemeData(
                fontFamily: 'open sans',
                scaffoldBackgroundColor:
                    Colors.white), // set background color theme
          ),
        ),
      ),
    );
  }
}

//ignore: must_be_immutable
class MainApp extends StatefulWidget {
  RxString idUser;
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  // int _index = 0;
  var colorTabBar = Color(0xff2196F3);
  // ReportBloc _reportBloc;
  // list screen untuk menu
  List<Widget> screens;
  final controller = Get.put(UserLoginController());
  final homeController = Get.put(HomeScreenController());
  final reportController = Get.put(ReportUserController());
  final indexScreen = Get.put(IndexScreenHomeController());

  @override
  Widget build(BuildContext context) {
    screens = [
      HomeScreen(
        scaffoldKey: scaffoldKey,
      ),
      ReportScreen2(),
      // BillScreen(),
      Container()
      // PaymentScreen()
    ];

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      key: scaffoldKey,
      // membuat sidebar dan drawer
      endDrawer: drawerSideBar(),
      body: Obx(
        () => IndexedStack(children: screens, index: indexScreen.index.value),
      ),

      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)]),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            iconSize: 12.sp,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.black54,
            currentIndex: indexScreen.index.value,
            onTap: (index) {
              // setState(() {
              //   _index = index;
              //   if (index == 1) {
              //     reportController.refresReport();
              //   }
              // });
              indexScreen.index.value = index;
              if (indexScreen.index.value == 1) {
                reportController.refresReport();
                reportController.update();
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/img/image-svg/home-icon.svg',
                    color: Color(0xff757575)),
                activeIcon:
                    SvgPicture.asset('assets/img/image-svg/home-icon.svg'),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/img/image-svg/keluhan-icon.svg',
                    color: Color(0xff757575),
                  ),
                  activeIcon: SvgPicture.asset(
                    'assets/img/image-svg/keluhan-icon.svg',
                    color: Color(0xff2094F3),
                  ),
                  label: 'Keluhan'),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/img/image-svg/riwayatipl-icon.svg',
                    color: Color(0xff757575),
                  ),
                  activeIcon: SvgPicture.asset(
                    'assets/img/image-svg/riwayatipl-icon.svg',
                    color: Color(0xff2094F3),
                  ),
                  label: 'Riwayat IPL'),
            ],
          ),
        ),
      ),
    );
  }

  Drawer drawerSideBar() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Align(
              alignment: Alignment.topLeft,
              child: Obx(() {
                print('DRAWERRR :::${controller.username}');
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: CachedNetworkImageProvider(
                        '${ServerApp.url}${controller.urlProfile.value}',
                      ),
                    ),
                    SizedBox(
                      height: 15.sh,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        '${controller.username.value}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              color: Colors.grey,
            ),
            title: Text(
              'Profil',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                    builder: (context) => ChangeDataUser(),
                  ))
                  .then((value) => setState(() {}));
            },
          ),
          Obx(
            () => Visibility(
              visible: controller.accessManagement.value,
              child: ListTile(
                leading: Icon(
                  Icons.compare_arrows_rounded,
                  color: Colors.grey,
                ),
                title: Text(
                  'Management',
                  style: TextStyle(color: Colors.grey),
                ),
                onTap: () {
                  Get.offAll(ManagementScreen());
                },
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.grey),
            title: Text(
              'Keluar',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () async {
              await UserSecureStorage.deleteIdUser();
              await UserSecureStorage.deleteStatus();
              controller.logout();
              Get.offAll(SplashView());
            },
          ),
        ],
      ),
    );
  }
}
