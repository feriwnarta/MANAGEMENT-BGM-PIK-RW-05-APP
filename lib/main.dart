import 'package:aplikasi_rw/controller/home_screen_controller.dart';
import 'package:aplikasi_rw/controller/indexscreen_home_controller.dart';
import 'package:aplikasi_rw/controller/report_user_controller.dart';
import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/modules/home/screens/home_folder_screen.dart';
import 'package:aplikasi_rw/modules/profiles/screens/UserProfileScreens.dart';
import 'package:aplikasi_rw/modules/profiles/screens/profile_settings_screen.dart';
import 'package:aplikasi_rw/routes/app_pages.dart';
import 'package:aplikasi_rw/routes/app_routes.dart';
import 'package:aplikasi_rw/modules/payment_ipl/screens/history/payment_ipl_history.dart';
import 'package:aplikasi_rw/modules/profiles/screens/change_data_user.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/services/check_session.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';
import 'dart:io';
import 'lifecyle_manager.dart';
import 'modules/management/screens/management_screen.dart';
// import 'package:sizer/sizer.dart' as s;
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 10,
          channelKey: 'basic_channel',
          title: '${message.notification.title}',
          body: '${message.notification.body}',
          actionType: ActionType.Default));

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  // runApp(DevicePreview(enabled: !kReleaseMode, builder: (context) => MyApp()));
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      'resource://drawable/launcher_icon',
      [
        NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Colors.white,
          ledColor: Colors.white,
          channelShowBadge: true,
          playSound: true,
        )
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: false);

  final token = await FirebaseMessaging.instance.getToken();
  final logger = Logger();
  logger.e(token);

  FirebaseMessaging m = FirebaseMessaging.instance;

  FirebaseMessaging.onMessage.listen((event) {
    final logger = Logger();
    logger.w(event.messageId);

    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10,
            channelKey: 'basic_channel',
            title: '${event.notification.title}',
            body: '${event.notification.body}',
            actionType: ActionType.Default));
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  m.getToken().then((token) => print(token));

  NotificationSettings settings = await m.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }

  ByteData data =
      await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());

  runApp(MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  // ..customAnimation = CustomAnimation();
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xff1F8EE5),
      statusBarIconBrightness: Brightness.light,
    ));
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

    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => AppLifecycleManager(
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: AppPage.INITIAL_ROUTE,
          getPages: AppPage.pages,
          // home: CreateAccount(),

          theme: ThemeData(
              appBarTheme: AppBarTheme(
                systemOverlayStyle: SystemUiOverlayStyle.dark,
              ),
              fontFamily: 'open sans',
              scaffoldBackgroundColor: Colors.white),
          builder: EasyLoading.init(), // set background color theme
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
      HomeScreenFolder(),
      UserProfileScreen(),
      ProfileSettings(),
    ];

    return Scaffold(
      key: scaffoldKey,
      // membuat sidebar dan drawer
      endDrawer: drawerSideBar(),
      body: Obx(
        () => IndexedStack(children: screens, index: indexScreen.index.value),
      ),

      bottomNavigationBar: Obx(
        () => Container(
          // decoration: BoxDecoration(
          //   boxShadow: [
          //     BoxShadow(color: Colors.grey, blurRadius: 5),
          //   ],
          // ),
          child: BottomNavigationBar(
            backgroundColor: Color(0xff2094F3),
            type: BottomNavigationBarType.fixed,
            iconSize: 12.sp,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white,
            currentIndex: indexScreen.index.value,
            onTap: (index) {
              indexScreen.index.value = index;
              if (indexScreen.index.value == 1) {
                reportController.refresReport();
                reportController.update();
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/img/image-svg/home-deactive.svg',
                ),
                activeIcon: SvgPicture.asset(
                  'assets/img/image-svg/home-active.svg',
                  color: Colors.white,
                ),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/img/image-svg/user-deactive.svg',
                    color: Colors.white,
                  ),
                  activeIcon: SvgPicture.asset(
                    'assets/img/image-svg/user-active.svg',
                    color: Colors.white,
                  ),
                  label: 'Profil'),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/img/image-svg/setting-deactive.svg',
                    color: Colors.white,
                  ),
                  activeIcon: SvgPicture.asset(
                    'assets/img/image-svg/setting-active.svg',
                    color: Colors.white,
                  ),
                  label: 'Pengaturan'),
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
                      height: 15.h,
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
              Get.offAllNamed(RouteName.home);
            },
          ),
        ],
      ),
    );
  }
}
