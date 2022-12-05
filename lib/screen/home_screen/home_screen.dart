import 'dart:async';
import 'package:aplikasi_rw/bloc/carousel_bloc.dart';
import 'package:aplikasi_rw/controller/home_screen_controller.dart';
import 'package:aplikasi_rw/controller/status_user_controller.dart';
import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/controller/write_status_controller.dart';
import 'package:aplikasi_rw/model/card_news.dart';
import 'package:aplikasi_rw/screen/home_screen/news_screen/news_screen.dart';
import 'package:aplikasi_rw/screen/home_screen/status_warga.dart';
import 'package:aplikasi_rw/screen/home_screen/tempat_tulis_status_screen.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  HomeScreen({
    Key key,
    this.scaffoldKey,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  String rt, rw, fotoProfile;
  double mediaSizeHeight;

  final _picker = ImagePicker();
  String imagePath = '';
  PickedFile imageFile;
  CarouselBloc blocColor;
  // TempatTulisStatusBloc blocTulisStatus;
  StatusUserController controllerStatus;
  UserLoginController controllerLogin;
  WriteStatusController writeStatusController;

  ScrollController controller = ScrollController(keepScrollOffset: true);
  final key = GlobalKey();

  final showHamburgerMenuKey = GlobalKey();

  // final GlobalKey _second = GlobalKey();
  // final GlobalKey _first = GlobalKey();

  @override
  initState() {
    super.initState();
    controllerStatus = Get.put(StatusUserController());
    controllerLogin = Get.put(UserLoginController());
    writeStatusController = Get.put(WriteStatusController());

    // showcase
    // WidgetsBinding.instance.addPostFrameCallback(
    //   (_) => ShowCaseWidget.of(context).startShowCase([_first, _second]),
    // );
  }

  // Timer _timer;

  void onScroll() {
    if (controller.position.haveDimensions) {
      if (controller.position.maxScrollExtent == controller.position.pixels) {
        controllerStatus.getDataFromDb();
      }
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    blocColor = BlocProvider.of<CarouselBloc>(context);

    // blocTulisStatus = BlocProvider.of<TempatTulisStatusBloc>(context);
    // blocStatusUser = BlocProvider.of<StatusUserBloc>(context);
    controller.addListener(onScroll);

    // _timer = Timer.periodic(Duration(seconds: 5), (duration) async {
    //   print(duration);
    //   controllerStatus.realtimeData();
    // });
  }

  @override
  void dispose() {
    // if (_timer.isActive) _timer.cancel();
    controller.dispose();
    blocColor.close();
    // blocTulisStatus.close();
    // Get.delete<StatusUserController>();
    // Get.delete<UserLoginController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => loadStatus(),
          child: SingleChildScrollView(
              key: key,
              physics: ClampingScrollPhysics(),
              controller: controller,
              child: GetX<HomeScreenController>(
                init: HomeScreenController(),
                builder: (controller) => Column(
                  children: <Widget>[
                    Stack(children: [
                      headerBackground(context, controller.urlProfile.value,
                          controller.username.value)
                    ]),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 24.h),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            'Berita',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16.sp),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            'Informasi yang di berikan untuk warga BGM PIK 05',
                            style: TextStyle(
                              color: Color(0xff757575),
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        buildCarouselSliderNews(),
                        // SizedBox(
                        //   height: 17,
                        // ),
                        // StreamBuilder<List<CardNews>>(
                        //     stream: NewsServices.getNews(
                        //         '${controllerLogin.idUser}'),
                        //     builder: (context, snapshot) => (snapshot.hasData)
                        //         ? (snapshot.data.length > 0)
                        //             ? Center(
                        //                 child: BlocBuilder<CarouselBloc, int>(
                        //                   builder: (context, index) =>
                        //                       AnimatedSmoothIndicator(
                        //                     activeIndex: index,
                        //                     count: snapshot.data.length,
                        //                     effect: ExpandingDotsEffect(
                        //                         dotWidth: 10,
                        //                         dotHeight: 10,
                        //                         activeDotColor:
                        //                             Colors.lightBlue,
                        //                         dotColor: Colors.grey[350]),
                        //                   ),
                        //                 ),
                        //               )
                        //             : Container()
                        //         : Container())
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15, top: 10),
                          child: Text(
                            "Posting",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            "Unggahan warga BMG PIK 05",
                            style: TextStyle(
                                fontSize: 10.sp, color: Color(0xff757575)),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        ListViewStatusWarga(widget: widget)
                      ],
                    )
                    // status dari warga
                    // Column(children: listStatus),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  StreamBuilder buildCarouselSliderNews() {
    return StreamBuilder<List<CardNews>>(
      stream: NewsServices.getNews('${controllerLogin.idUser}'),
      builder: (context, snapshot) => (snapshot.hasData)
          ? (snapshot.data.length > 0)
              ? CarouselSlider.builder(
                  options: CarouselOptions(
                    // height: 180,
                    height: 183.h,
                    enlargeCenterPage: kDebugMode ? false : true,
                    disableCenter: true,
                    viewportFraction: 0.47,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 4),
                    // onPageChanged: (index, _) => blocColor.add(index),
                  ),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index, realIndex) {
                    return SingleChildScrollView(
                      child: GestureDetector(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 167.78.h,
                              width: 156.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      height: 121.78.h,
                                      width: 156.w,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          // borderRadius: BorderRadius.only(
                                          //     topLeft: Radius.circular(15),
                                          //     topRight: Radius.circular(15)),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                '${ServerApp.url}${snapshot.data[index].urlImageNews}',
                                            fit: BoxFit.cover,
                                            placeholder: (context, _) =>
                                                Container(
                                              color: Colors.grey,
                                            ),
                                            errorWidget: (context, url, _) =>
                                                Container(
                                              color: Colors.grey,
                                              child: Icon(
                                                Icons.error,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ))),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 4.w),
                                    width: 148.w,
                                    child: Text(
                                      snapshot.data[index].caption,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      style: TextStyle(
                                          color: Color(0xff404040),
                                          fontSize: 12.sp),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => NewsScreen(
                                    urlImage:
                                        '${ServerApp.url}${snapshot.data[index].urlImageNews}',
                                    caption: snapshot.data[index].caption,
                                    content: snapshot.data[index].content,
                                    writerAndTime:
                                        snapshot.data[index].writerAndTime,
                                  )));
                        },
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    'No News',
                    style: TextStyle(fontSize: 11.0.sp),
                  ),
                )
          : SizedBox(
              height: 121.78.h,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                // padding: EdgeInsets.only(right: 2.0.w),
                physics: ScrollPhysics(),
                itemBuilder: (context, index) => Container(
                  // height: 20.h,
                  width: 156.w,
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[200],
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10)),
                        width: double.infinity,
                        height: 50,
                      )),
                ),
              ),
            ),
    );
  }

  Container headerBackground(
      BuildContext context, String fotoProfile, String username) {
    return Container(
        child: Column(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 1.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'BGM RW O5',
                style: TextStyle(fontSize: 19.sp, color: Color(0xff2094F3)),
              ),
              Padding(
                padding: EdgeInsets.only(right: 50.w),
                child: Image(
                  width: 34.w,
                  height: 40.h,
                  image: AssetImage('assets/img/logo_rw.png'),
                  fit: BoxFit.cover,
                  repeat: ImageRepeat.noRepeat,
                ),
              ),
              IconButton(
                  icon: SvgPicture.asset(
                      'assets/img/image-svg/hamburger-menu.svg'),
                  onPressed: () =>
                      widget.scaffoldKey.currentState.openEndDrawer()),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        Divider(thickness: 2),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Row(
                  children: [
                    SizedBox(
                      width: 16.w,
                    ),
                    Text(
                      '${controllerLogin.username.value}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )),
          ],
        ),
        SizedBox(
          height: 16.h,
        ),
        cardStatus(context, fotoProfile, username),
      ],
    ));
  }

  Align cardStatus(BuildContext context, String fotoProfile, String username) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: 144.h,
        width: 340.w,
        child: Card(
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                    colors: [Color(0xff2297F4), Color(0xff3ABBFD)])),
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  /**
                     * bagian dalam card status yang isinya dapat berubah
                     * mulai dari avatar, nama user, dan rw user
                     */
                  SizedBox(
                    height: 16.h,
                  ),
                  Row(
                    children: [
                      GetX<HomeScreenController>(
                        init: HomeScreenController(),
                        builder: (controller) => Row(
                          children: [
                            SizedBox(
                              width: 15.w,
                            ),
                            SizedBox(
                              height: 40.h,
                              width: 40.w,
                              child: CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                      '${ServerApp.url}${controllerLogin.urlProfile}')),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        width: 16.w,
                      ),
                      // container ini berisi tempat menulis status
                      // gesture detector jika tulis status diklik
                      GestureDetector(
                        onTap: () {
                          // showModalBottomStatus(
                          //     context, fotoProfile, username);
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TempatTulisStatus(),
                          ));
                        },
                        child: Container(
                          height: 40.h,
                          width: 242.w,
                          child: Center(
                            child: Text(
                              'Apa yang anda sedang pikirkan ?',
                              style: TextStyle(
                                  color: Colors.grey,
                                  // fontSize: MediaQuery.of(context).size.width *
                                  //     0.035
                                  fontSize: 10.0.sp),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40)),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Divider(
                    color: Colors.white,
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                            onPressed: () {
                              getImage(ImageSource.camera).then((value) {
                                if (writeStatusController.isVisibility.value)
                                  Get.to(() => TempatTulisStatus());
                              });
                            },
                            icon: Icon(
                              FontAwesomeIcons.camera,
                              color: Colors.white,
                              size: 12.w,
                            ),
                            label: Text(
                              'Kamera',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.sp),
                            )),
                        SizedBox(
                          width: 24.w,
                        ),
                        VerticalDivider(
                          color: Colors.white,
                          width: 10.0.w,
                          thickness: 1,
                          indent: 15,
                          endIndent: 10,
                        ),
                        SizedBox(
                          width: 24.w,
                        ),
                        TextButton.icon(
                            onPressed: () {
                              getImage(ImageSource.gallery).then((value) {
                                if (writeStatusController.isVisibility.value)
                                  Get.to(() => TempatTulisStatus());
                              });
                            },
                            icon: Icon(
                              FontAwesomeIcons.solidImage,
                              color: Colors.white,
                              size: 12.w,
                            ),
                            label: Text(
                              'Galeri',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.sp),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future showModalBottomStatus(
      BuildContext context, String fotoProfile, String username) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (builder) => TempatTulisStatus());
  }

  Future getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      writeStatusController = Get.put(WriteStatusController());
      final logger = Logger();
      writeStatusController.addImage(true.obs, pickedFile.path.obs);
      writeStatusController.update();
      logger.i(writeStatusController.isVisibility.value);
      logger.i(writeStatusController.pickedFile.value);
    }
  }

  Future loadStatus() async {
    // await Future.delayed(Duration(seconds: 1));
    await controllerStatus.refreshStatus();
  }

  @override
  bool get wantKeepAlive => true;
}

class ListViewStatusWarga extends StatelessWidget {
  ListViewStatusWarga({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final HomeScreen widget;
  final contol = Get.put(StatusUserController());
  final controllerLogin = Get.put(UserLoginController());

  @override
  Widget build(BuildContext context) {
    return GetX<StatusUserController>(
        init: StatusUserController(),
        initState: (state) => contol.getDataFromDb(),
        builder: (controller) {
          if (controller.isLoading.value) {
            // _refreshIndicatorKey.currentState.show();
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(),
                ),
              ),
            );
            // return Container();
          } else {
            return ListView.builder(
              physics: ClampingScrollPhysics(),
              addAutomaticKeepAlives: true,
              shrinkWrap: true,
              itemCount: (controller.isMaxReached.value)
                  ? controller.listStatus.length
                  : controller.listStatus.length + 1,
              itemBuilder: (context, index) =>
                  (index < controller.listStatus.length)
                      ? StatusWarga(
                          userName: controller.listStatus[index].userName,
                          caption: controller.listStatus[index].caption,
                          fotoProfile: controller.listStatus[index].urlProfile,
                          urlStatusImage:
                              controller.listStatus[index].urlStatusImage,
                          numberOfComments:
                              controller.listStatus[index].commentCount,
                          uploadTime: controller.listStatus[index].uploadTime,
                          numberOfLikes: controller.listStatus[index].likeCount,
                          idStatus: controller.listStatus[index].idStatus,
                          idUser: '${controllerLogin.idUser}',
                          isLike: controller.listStatus[index].isLike,
                        )
                      : (index == controller.listStatus.length)
                          ? Center(child: Text('no status'))
                          : Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Center(
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
            );
          }
        });
  }
}
