import 'package:aplikasi_rw/controller/status_user_controller.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:aplikasi_rw/utils/view_image.dart';
import 'package:aplikasi_rw/modules/social_media/screens/create_status.dart';
import 'package:aplikasi_rw/services/like_status_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 1));
            await contol.refreshStatus();
          },
          child: GetX<StatusUserController>(
            init: StatusUserController(),
            initState: (state) => contol.getDataFromDb(),
            builder: (controller) => RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(Duration(seconds: 1));
                await contol.refreshStatus();
              },
              child: ListView.builder(
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
                    } else if (controller.listStatus.length > index) {
                      return Container(
                        margin: EdgeInsets.symmetric(
                            vertical: SizeConfig.height(12)),
                        child: Center(
                          child: SizedBox(
                            width: SizeConfig.width(30),
                            height: SizeConfig.height(30),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      );
                    } else if (index == controller.listStatus.length) {
                      return SizedBox();
                    } else {
                      return Container(
                        margin: EdgeInsets.symmetric(
                            vertical: SizeConfig.height(10)),
                        child: Center(
                          child: SizedBox(
                            width: SizeConfig.width(30),
                            height: SizeConfig.height(30),
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
