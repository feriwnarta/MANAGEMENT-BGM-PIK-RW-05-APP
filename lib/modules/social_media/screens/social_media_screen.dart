import 'package:aplikasi_rw/controller/status_user_controller.dart';
import 'package:aplikasi_rw/utils/view_image.dart';
import 'package:aplikasi_rw/modules/social_media/screens/create_status.dart';
import 'package:aplikasi_rw/services/like_status_services.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sosial Media',
              style: TextStyle(
                fontSize: 19.sp,
              ),
            ),
            Text(
              'Unggahan warga BGM PIK RW 05',
              style: TextStyle(
                fontSize: 10.sp,
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await contol.refreshStatus();
          },
          child: SingleChildScrollView(
            controller: scrollController,
            child: GetX<StatusUserController>(
              init: StatusUserController(),
              initState: (state) => contol.getDataFromDb(),
              builder: (controller) => ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: (controller.isMaxReached.value)
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
                        urlStatusImage: (controller
                                    .listStatus[index].urlStatusImage.isEmpty ||
                                controller.listStatus[index].urlStatusImage
                                    .isCaseInsensitiveContainsAny('no_image'))
                            ? ''
                            : controller.listStatus[index].urlStatusImage,
                        numberOfComments:
                            controller.listStatus[index].commentCount,
                        uploadTime: controller.listStatus[index].uploadTime,
                        numberOfLikes:
                            int.parse(controller.listStatus[index].likeCount),
                        idStatus: controller.listStatus[index].idStatus,
                        idUser: '${controllerLogin.idUser}',
                      );
                    } else if (controller.listStatus.length == 0) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                          child: Text(
                            'Tidak ada status',
                            style: TextStyle(
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      );
                    } else if (controller.listStatus.length > index) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      );
                    } else if (index == controller.listStatus.length) {
                      return SizedBox();
                    } else {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      );
                    }
                  }),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return CreateStatus();
            },
          );
        },
        child: SvgPicture.asset('assets/img/image-svg/pencil.svg'),
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
      this.numberOfLikes})
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

  int numberOfLikes;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 328.w,
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 8.h,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                          '${ServerApp.url}$fotoProfile'),
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 296.w,
                        child: AutoSizeText(
                          '$username',
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 12.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width: 296.w,
                        child: AutoSizeText(
                          '$uploadTime',
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 10.sp,
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
              SizedBox(
                height: 8.h,
              ),
              Container(
                width: 296.w,
                margin: EdgeInsets.only(left: 32.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReadMoreText(
                      '$caption',
                      trimLines: 3,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: ' Baca selengkapnya',
                      trimExpandedText: ' Baca lebih sedikit',
                      lessStyle: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      moreStyle: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Color(0xff404040),
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    (urlStatusImage.isNotEmpty && urlStatusImage != null)
                        ? GestureDetector(
                            onTap: () => Get.to(
                              () => ViewImage(urlImage: '$urlStatusImage'),
                            ),
                            child: Container(
                              width: 296.w,
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
                      height: 8.h,
                    ),
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
                              width: 67.w,
                              height: 20.h,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                      'assets/img/image-svg/comment-icon.svg'),
                                  SizedBox(
                                    width: 4.w,
                                  ),
                                  (numberOfComments == '0')
                                      ? Text(
                                          'Komentar',
                                          style: TextStyle(
                                              fontSize: 10.sp,
                                              color: Color(0xff404040)),
                                        )
                                      : Text(
                                          '$numberOfComments',
                                          style: TextStyle(
                                              fontSize: 10.sp,
                                              color: Color(0xff404040)),
                                        )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 24.w,
                        ),
                        LikeButton(
                          size: 14.h,
                          isLiked: isLike.value,
                          circleColor: CircleColor(
                              start: Color(0xff00ddff), end: Color(0xff0099cc)),
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
                          countBuilder: (int count, bool isLiked, String text) {
                            var color = isLiked
                                ? Colors.deepPurpleAccent
                                : Color(0xff404040);
                            Widget result;
                            if (count == 0) {
                              result = Text(
                                "Suka",
                                style: TextStyle(color: color, fontSize: 10.sp),
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
                              String result = await LikeStatusService.addLike(
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
                  ],
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: 12.h,
              )
            ],
          ),
        ),
      ],
    );
  }
}
