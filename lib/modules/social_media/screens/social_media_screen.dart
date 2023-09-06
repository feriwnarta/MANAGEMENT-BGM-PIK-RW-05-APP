import 'dart:convert';

import 'package:aplikasi_rw/controller/status_user_controller.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:aplikasi_rw/utils/view_image.dart';
import 'package:aplikasi_rw/modules/social_media/screens/create_status.dart';
import 'package:aplikasi_rw/services/like_status_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:logger/logger.dart';
import 'package:readmore/readmore.dart';

import '../../../controller/user_login_controller.dart';
import '../../../server-app.dart';
import '../../home/screens/comment_screen.dart';

class SocialMedia extends StatefulWidget {
  const SocialMedia({
    Key key,
  }) : super(key: key);

  @override
  State<SocialMedia> createState() => _SocialMediaState();
}

class _SocialMediaState extends State<SocialMedia> {
  final contol = Get.put(StatusUserController());
  final controllerLogin = Get.put(UserLoginController());
  final ScrollController scrollController = ScrollController();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  void onScroll() {
    if (scrollController.position.haveDimensions) {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        contol.getDataFromDb();
      }
    }
  }

  @override
  void didChangeDependencies() {
    scrollController.addListener(onScroll);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sosial Media',
              style: TextStyle(
                fontSize: SizeConfig.text(19),
              ),
            ),
            Text(
              'Unggahan warga BGM PIK RW 05',
              style: TextStyle(
                fontSize: SizeConfig.text(10),
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: GetX<StatusUserController>(
          init: StatusUserController(),
          initState: (state) => contol.getDataFromDb(),
          builder: (controller) => RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 1));
              await contol.refreshStatus();
            },
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: controller.isMaxReached.value
                  ? controller.listStatus.length
                  : (controller.listStatus.length <= 10)
                      ? controller.listStatus.length + 1
                      : controller.listStatus.length + 2,
              itemBuilder: (context, index) {
                if (index < controller.listStatus.length) {
                  return CardSocialMedia(
                    isLike: controller.listStatus[index].isLike == 1
                        ? true.obs
                        : false.obs,
                    username: controller.listStatus[index].userName,
                    caption: controller.listStatus[index].caption,
                    fotoProfile: controller.listStatus[index].urlProfile,
                    urlStatusImage:
                        (controller.listStatus[index].urlStatusImage.isEmpty ||
                                controller.listStatus[index].urlStatusImage
                                    .isCaseInsensitiveContainsAny('no_image'))
                            ? ''
                            : controller.listStatus[index].urlStatusImage,
                    numberOfComments: controller.listStatus[index].commentCount,
                    uploadTime: controller.listStatus[index].uploadTime,
                    numberOfLikes:
                        int.parse(controller.listStatus[index].likeCount),
                    idStatus: controller.listStatus[index].idStatus,
                    idUser: '${controllerLogin.idUser}',
                    refreshIndicatorKey: _refreshIndicatorKey,
                  );
                } else if (controller.listStatus.length > index) {
                  return Container(
                    margin:
                        EdgeInsets.symmetric(vertical: SizeConfig.height(12)),
                    child: Center(
                      child: SizedBox(
                        width: SizeConfig.width(30),
                        height: SizeConfig.height(30),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(CreateStatus(), transition: Transition.downToUp);
        },
        child: SvgPicture.asset(
          'assets/img/image-svg/pencil.svg',
          width: SizeConfig.width(20),
          height: SizeConfig.height(20),
        ),
      ),
    );
  }
}

//ignore: must_be_immutable
class CardSocialMedia extends StatelessWidget {
  CardSocialMedia(
      {Key key,
      this.caption,
      this.fotoProfile,
      this.idStatus,
      this.idUser,
      this.isLike,
      this.numberOfComments,
      this.uploadTime,
      this.urlStatusImage,
      this.username,
      this.numberOfLikes,
      this.refreshIndicatorKey})
      : super(key: key);

  RxBool isLike = false.obs;
  final String username,
      caption,
      fotoProfile,
      urlStatusImage,
      numberOfComments,
      uploadTime,
      idStatus,
      idUser;

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;

  int numberOfLikes;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: SizeConfig.width(328),
          margin: EdgeInsets.symmetric(horizontal: SizeConfig.width(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: SizeConfig.height(8),
              ),
              Container(
                child: Row(
                  children: [
                    SizedBox(
                      width: SizeConfig.width(24),
                      height: SizeConfig.height(24),
                      child: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                            '${ServerApp.url}$fotoProfile'),
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.width(8),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: SizeConfig.width(296),
                          child: Text(
                            '$username',
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: SizeConfig.text(12),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.width(296),
                          child: Text(
                            '$uploadTime',
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: SizeConfig.text(10),
                              color: Color(
                                0xff757575,
                              ),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: SizeConfig.width(296),
                margin: EdgeInsets.only(left: SizeConfig.width(32)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReadMoreText(
                      '$caption',
                      trimLines: 3,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: ' Baca selengkapnya',
                      trimExpandedText: ' Baca lebih sedikit',
                      lessStyle: TextStyle(
                          fontSize: SizeConfig.text(12), color: Colors.grey),
                      moreStyle: TextStyle(
                        fontSize: SizeConfig.text(12),
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: SizeConfig.text(12),
                        color: Color(0xff404040),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.height(8),
                    ),
                    (urlStatusImage.isNotEmpty && urlStatusImage != null)
                        ? GestureDetector(
                            onTap: () => Get.to(
                              () => ViewImage(urlImage: '$urlStatusImage'),
                            ),
                            child: Container(
                              width: SizeConfig.width(296),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: CachedNetworkImage(
                                  imageUrl: '$urlStatusImage',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                    SizedBox(
                      height: SizeConfig.height(8),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  barrierColor: Colors.black.withOpacity(0.4),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                  ),
                                  isScrollControlled: true,
                                  context: context,
                                  // push id comment
                                  builder: (context) => CommentScreen(
                                    idStatus: idStatus,
                                  ),
                                );
                              },
                              child: Material(
                                color: Colors.white,
                                child: SizedBox(
                                  width: SizeConfig.width(67),
                                  height: SizeConfig.height(20),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                          'assets/img/image-svg/comment-icon.svg'),
                                      SizedBox(
                                        width: SizeConfig.width(4),
                                      ),
                                      (numberOfComments == '0')
                                          ? Text(
                                              'Komentar',
                                              style: TextStyle(
                                                  fontSize: SizeConfig.text(10),
                                                  color: Color(0xff404040)),
                                            )
                                          : Text(
                                              '$numberOfComments',
                                              style: TextStyle(
                                                  fontSize: SizeConfig.text(10),
                                                  color: Color(0xff404040)),
                                            )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.width(24),
                            ),
                            LikeButton(
                              size: SizeConfig.height(14),
                              isLiked: isLike.value,
                              circleColor: CircleColor(
                                  start: Color(0xff00ddff),
                                  end: Color(0xff0099cc)),
                              bubblesColor: BubblesColor(
                                dotPrimaryColor: Color(0xff33b5e5),
                                dotSecondaryColor: Color(0xff0099cc),
                              ),
                              likeBuilder: (bool isLiked) {
                                this.isLike.value = isLiked;

                                return SvgPicture.asset(
                                  'assets/img/image-svg/like-icon.svg',
                                  color: isLiked
                                      ? Colors.redAccent
                                      : Color(0xff404040),
                                );
                              },
                              likeCount: numberOfLikes,
                              countBuilder:
                                  (int count, bool isLiked, String text) {
                                var color = isLiked
                                    ? Colors.deepPurpleAccent
                                    : Color(0xff404040);
                                Widget result;
                                if (count == 0) {
                                  result = Text(
                                    "Suka",
                                    style: TextStyle(
                                        color: color,
                                        fontSize: SizeConfig.text(10)),
                                  );
                                } else
                                  result = Text(
                                    text,
                                    style: TextStyle(color: color),
                                  );
                                return result;
                              },
                              bubblesSize: 50,
                              onTap: (isLiked) async {
                                if (this.isLike.value == false) {
                                  String result =
                                      await LikeStatusService.addLike(
                                          idStatus: idStatus, idUser: idUser);
                                  final logger = Logger();
                                  logger.i(result);
                                  if (result == 'success') {
                                    isLike.value = true;
                                    return Future.value(true);
                                  }
                                } else {
                                  String result =
                                      await LikeStatusService.deleteLike(
                                          idStatus: idStatus, idUser: idUser);
                                  if (result == 'OK') {
                                    return Future.value(false);
                                  } else {
                                    return Future.value(true);
                                  }
                                }
                                return Future.value(false);
                              },
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => alertDialog(
                                context, idStatus, refreshIndicatorKey),
                          ),
                          icon: SvgPicture.asset(
                            'assets/img/image-svg/Dots Vertical.svg',
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig.height(12),
              ),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: SizeConfig.height(12),
              )
            ],
          ),
        ),
      ],
    );
  }
}

Widget alertDialog(BuildContext context, String idStatus,
    GlobalKey<RefreshIndicatorState> refreshIndicatorKey) {
  return AlertDialog(
    contentPadding: EdgeInsets.zero,
    content: SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.close,
            color: Color(0xff404040),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.width(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton.icon(
                onPressed: () async {
                  await notInterseted(idStatus, refreshIndicatorKey, context);
                },
                style: TextButton.styleFrom(alignment: Alignment.centerLeft),
                icon: SvgPicture.asset('assets/img/image-svg/eye-off.svg'),
                label: Text(
                  'Tidak Tertarik',
                  style: TextStyle(
                    color: Color(0xff404040),
                    fontSize: SizeConfig.text(14),
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () async {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (context) =>
                        reportDialog(context, idStatus, refreshIndicatorKey),
                  );
                },
                style: TextButton.styleFrom(alignment: Alignment.centerLeft),
                icon: SvgPicture.asset(
                  'assets/img/image-svg/exclamation.svg',
                ),
                label: Text(
                  'Laporkan',
                  style: TextStyle(
                    color: Color(0xff404040),
                    fontSize: SizeConfig.text(14),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    )),
    actions: <Widget>[],
  );
}

Widget successReport(BuildContext context,
    GlobalKey<RefreshIndicatorState> refreshIndicatorKey) {
  return AlertDialog(
    contentPadding: EdgeInsets.zero,
    content: SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.width(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: SizeConfig.height(12),
              ),
              Text(
                'Terima kasih telah memberi tahu kami',
                style: TextStyle(
                  fontSize: SizeConfig.text(15),
                  color: Color(0xff404040),
                ),
              ),
              SizedBox(
                height: SizeConfig.height(8),
              ),
              Text(
                'Kami menggunakan laporan ini untuk :',
                style: TextStyle(
                  fontSize: SizeConfig.text(10),
                  color: Color(0xff616161),
                ),
              ),
              SizedBox(
                height: SizeConfig.height(32),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/img/image-svg/x-circle.svg'),
                  SizedBox(
                    width: SizeConfig.width(8),
                  ),
                  Expanded(
                    child: Text(
                      'Pahami masalah yang dihadapi orang dengan berbagai jenis konten.',
                      style: TextStyle(
                        fontSize: SizeConfig.text(14),
                        color: Color(0xff404040),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: SizeConfig.height(12),
              ),
              Divider(
                color: Color(0xffEDEDED),
                thickness: 2,
              ),
              SizedBox(
                height: SizeConfig.height(8),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/img/image-svg/eye-off.svg'),
                  SizedBox(
                    width: SizeConfig.width(8),
                  ),
                  Expanded(
                    child: Text(
                      'Tampilkan lebih sedikit konten semacam ini di masa mendatang.',
                      style: TextStyle(
                        fontSize: SizeConfig.text(14),
                        color: Color(0xff404040),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: SizeConfig.height(32),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                )),
                child: Text(
                  'Kembali',
                  style: TextStyle(fontSize: SizeConfig.text(14)),
                ),
              ),
            ],
          ),
        )
      ],
    )),
    actions: <Widget>[],
  );
}

Widget reportDialog(
  BuildContext context,
  String idStatus,
  GlobalKey<RefreshIndicatorState> refreshIndicatorKey,
) {
  return AlertDialog(
    contentPadding: EdgeInsets.zero,
    content: SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.close,
                color: Color(0xff404040),
              ),
            ),
            SizedBox(
              width: SizeConfig.width(70),
            ),
            Text(
              'Laporkan',
              style: TextStyle(
                fontSize: SizeConfig.text(16),
                color: Color(0xff404040),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.width(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mengapa Anda melaporkan postingan ini?',
                style: TextStyle(
                    fontSize: SizeConfig.text(12),
                    color: Color(0xff404040),
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: SizeConfig.height(8),
              ),
              Text(
                'Laporan ini bersifat anonim, kecuali jika Anda melaporkan pelanggaran hak kekayaan intelektual.',
                style: TextStyle(
                  fontSize: SizeConfig.text(12),
                  color: Color(0xff404040),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: SizeConfig.height(32),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextButton(
                    onPressed: () async {
                      await reportService(
                          idStatus,
                          'Saya hanya tidak menyukainya',
                          refreshIndicatorKey,
                          context);
                    },
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft),
                    child: Text(
                      'Saya hanya tidak menyukainya',
                      style: TextStyle(
                        fontSize: SizeConfig.text(14),
                        color: Color(0xff404040),
                      ),
                    ),
                  ),
                  Divider(
                    color: Color(0xffEDEDED),
                    thickness: 2,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextButton(
                    onPressed: () async {
                      await reportService(idStatus, 'Ini adalah spam',
                          refreshIndicatorKey, context);
                    },
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft),
                    child: Text(
                      'Ini adalah spam',
                      style: TextStyle(
                        fontSize: SizeConfig.text(14),
                        color: Color(0xff404040),
                      ),
                    ),
                  ),
                  Divider(
                    color: Color(0xffEDEDED),
                    thickness: 2,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextButton(
                    onPressed: () async {
                      await reportService(
                          idStatus,
                          'Ketelanjangan atau aktivitas seksual',
                          refreshIndicatorKey,
                          context);
                    },
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft),
                    child: Text(
                      'Ketelanjangan atau aktivitas seksual',
                      style: TextStyle(
                        fontSize: SizeConfig.text(14),
                        color: Color(0xff404040),
                      ),
                    ),
                  ),
                  Divider(
                    color: Color(0xffEDEDED),
                    thickness: 2,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextButton(
                    onPressed: () async {
                      await reportService(
                          idStatus,
                          'Ujaran atau simbol kebencian',
                          refreshIndicatorKey,
                          context);
                    },
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft),
                    child: Text(
                      'Ujaran atau simbol kebencian',
                      style: TextStyle(
                        fontSize: SizeConfig.text(14),
                        color: Color(0xff404040),
                      ),
                    ),
                  ),
                  Divider(
                    color: Color(0xffEDEDED),
                    thickness: 2,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextButton(
                    onPressed: () async {
                      await reportService(
                          idStatus,
                          'Kekerasan atau organisasi berbahaya',
                          refreshIndicatorKey,
                          context);
                    },
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft),
                    child: Text(
                      'Kekerasan atau organisasi berbahaya',
                      style: TextStyle(
                        fontSize: SizeConfig.text(14),
                        color: Color(0xff404040),
                      ),
                    ),
                  ),
                  Divider(
                    color: Color(0xffEDEDED),
                    thickness: 2,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextButton(
                    onPressed: () async {
                      await reportService(idStatus, 'Informasi palsu',
                          refreshIndicatorKey, context);
                    },
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft),
                    child: Text(
                      'Informasi palsu',
                      style: TextStyle(
                        fontSize: SizeConfig.text(14),
                        color: Color(0xff404040),
                      ),
                    ),
                  ),
                  Divider(
                    color: Color(0xffEDEDED),
                    thickness: 2,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextButton(
                    onPressed: () async {
                      await reportService(
                          idStatus,
                          'Perundungan atau penggelapan',
                          refreshIndicatorKey,
                          context);
                    },
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft),
                    child: Text(
                      'Perundungan atau penggelapan',
                      style: TextStyle(
                        fontSize: SizeConfig.text(14),
                        color: Color(0xff404040),
                      ),
                    ),
                  ),
                  Divider(
                    color: Color(0xffEDEDED),
                    thickness: 2,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextButton(
                    onPressed: () async {
                      await reportService(
                          idStatus,
                          'Pelanggaran hak kekayaan intelektual',
                          refreshIndicatorKey,
                          context);
                    },
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft),
                    child: Text(
                      'Pelanggaran hak kekayaan intelektual',
                      style: TextStyle(
                        fontSize: SizeConfig.text(14),
                        color: Color(0xff404040),
                      ),
                    ),
                  ),
                  Divider(
                    color: Color(0xffEDEDED),
                    thickness: 2,
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    )),
    actions: <Widget>[],
  );
}

Future<void> reportService(
    String idStatus,
    String type,
    GlobalKey<RefreshIndicatorState> refreshIndicatorKey,
    BuildContext context) async {
  // tambahkan tidak tertarik
  Dio dio = await Dio();
  dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

  String url = '${ServerApp.url}src/status/report_status.php';
  String idUser = await UserSecureStorage.getIdUser();
  var data = {'id_status': idStatus, 'id_reporter': idUser, 'type': type};

  EasyLoading.show(status: 'loading');

  var response = await dio.post(url, data: jsonEncode(data));
  // Get.back();
  Navigator.of(context).pop();

  EasyLoading.dismiss();

  if (jsonDecode(response.data) != 'success') {
    EasyLoading.showError('Gagal');
  } else {
    if (refreshIndicatorKey != null) {
      refreshIndicatorKey.currentState.show();
    }

    showDialog(
      context: context,
      builder: (context) => successReport(context, refreshIndicatorKey),
    );
  }
}

Widget notInterestedDialog(BuildContext context) {
  return AlertDialog(
    contentPadding: EdgeInsets.zero,
    content: SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.close,
                color: Color(0xff404040),
              ),
            ),
            Text(
              'Postingan disembunyikan',
              style: TextStyle(
                fontSize: SizeConfig.text(16),
                color: Color(0xff404040),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.width(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kami akan sarankan lebih sedikit postingan seperti ini',
                style: TextStyle(
                  fontSize: SizeConfig.text(10),
                  color: Color(0xff616161),
                ),
              ),
              SizedBox(
                height: SizeConfig.height(32),
              ),
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/img/image-svg/x-circle.svg'),
                      SizedBox(
                        width: SizeConfig.width(8),
                      ),
                      Expanded(
                        child: Text(
                          'Jangan sarankan postingan dari Santo Antoni',
                          style: TextStyle(
                            fontSize: SizeConfig.text(14),
                            color: Color(0xff404040),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.height(12),
                  ),
                  Divider(
                    thickness: 2,
                    color: Color(0xffEDEDED),
                  ),
                ],
              ),
              SizedBox(
                height: SizeConfig.height(8),
              ),
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                          'assets/img/image-svg/shield-exclamation.svg'),
                      SizedBox(
                        width: SizeConfig.width(8),
                      ),
                      Expanded(
                        child: Text(
                          'Jangan sarankan postingan dari Santo Antoni',
                          style: TextStyle(
                            fontSize: SizeConfig.text(14),
                            color: Color(0xff404040),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.height(12),
                  ),
                  Divider(
                    thickness: 2,
                    color: Color(0xffEDEDED),
                  ),
                ],
              ),
              SizedBox(
                height: SizeConfig.height(8),
              ),
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/img/image-svg/emoji-sad.svg'),
                      SizedBox(
                        width: SizeConfig.width(8),
                      ),
                      Expanded(
                        child: Text(
                          'Postingan ini membuat saya tidak nyaman',
                          style: TextStyle(
                            fontSize: SizeConfig.text(14),
                            color: Color(0xff404040),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.height(12),
                  ),
                  Divider(
                    thickness: 2,
                    color: Color(0xffEDEDED),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    )),
    actions: <Widget>[],
  );
}

Future<void> notInterseted(
    String idStatus,
    GlobalKey<RefreshIndicatorState> refreshIndicatorKey,
    BuildContext context) async {
  // tambahkan tidak tertarik
  Dio dio = await Dio();
  dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

  String url = '${ServerApp.url}src/status/not_interested.php';
  String idUser = await UserSecureStorage.getIdUser();
  var data = {
    'id_status': idStatus,
    'report_user_id': idUser,
    'not_interested': '1'
  };

  EasyLoading.show(status: 'loading');

  var response = await dio.post(url, data: jsonEncode(data));

  Navigator.of(context).pop();

  EasyLoading.dismiss();

  if (jsonDecode(response.data) != 'success') {
    EasyLoading.showError('Gagal menambahkan tidak tertarik');
  } else {
    if (refreshIndicatorKey != null) {
      refreshIndicatorKey.currentState.show();
    }

    showDialog(
      context: context,
      builder: (context) => notInterestedDialog(context),
    );
  }
}
