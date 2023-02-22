import 'dart:io';

import 'package:aplikasi_rw/controller/status_user_controller.dart';
import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/modules/social_media/controllers/social_media_controllers.dart';
import 'package:aplikasi_rw/modules/social_media/screens/list-image.dart';
import 'package:aplikasi_rw/services/status_user_services.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:aplikasi_rw/utils/view_image_file.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../server-app.dart';

class CreateStatus extends StatefulWidget {
  const CreateStatus({Key key}) : super(key: key);

  @override
  State<CreateStatus> createState() => _CreateStatusState();
}

class _CreateStatusState extends State<CreateStatus> {
  RxString location = ''.obs;
  SocialMediaControllers socialMediaControllers =
      Get.put(SocialMediaControllers());
  UserLoginController userLoginController =
      Get.put(UserLoginController(), permanent: true);
  final contol = Get.put(StatusUserController());

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: SizeConfig.height(18)),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: SizeConfig.width(16))
                      .copyWith(top: SizeConfig.height(16)),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Get.back();
                                  Get.delete<SocialMediaControllers>();
                                },
                                child: Text(
                                  'Batal',
                                  style: TextStyle(
                                      fontSize: SizeConfig.text(14),
                                      color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                width: SizeConfig.width(70),
                                height: SizeConfig.height(24),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    EasyLoading.show(status: 'mengirim');
                                    var result = await StatusUserServices
                                        .sendDataStatus(
                                            caption: socialMediaControllers
                                                .controller.text,
                                            foto_profile: userLoginController
                                                .urlProfile.value,
                                            idUser: userLoginController
                                                .idUser.value,
                                            imgPath: (socialMediaControllers
                                                    .imagePath.isEmpty)
                                                ? 'no_image'
                                                : socialMediaControllers
                                                    .imagePath.value,
                                            location: socialMediaControllers
                                                .location.value,
                                            username: userLoginController
                                                .username.value);
                                    final logger = Logger();
                                    logger.i(result);
                                    if (result != null &&
                                        result.isCaseInsensitiveContainsAny(
                                            'succes')) {
                                      contol.refreshStatus();
                                      EasyLoading.dismiss();
                                      Get.delete<SocialMediaControllers>();
                                      Get.back();
                                    } else {
                                      EasyLoading.dismiss();
                                      EasyLoading.showError(
                                          'Gagal mengirim status');
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      100,
                                    ),
                                  )),
                                  child: Text(
                                    'Posting',
                                    style: TextStyle(
                                      fontSize: SizeConfig.text(10),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: SizeConfig.height(24),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                height: SizeConfig.height(24),
                                width: SizeConfig.width(24),
                                child: CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        '${ServerApp.url}${userLoginController.urlProfile.value}')),
                              ),
                              SizedBox(
                                width: SizeConfig.width(4),
                              ),
                              Expanded(
                                child: Text(
                                  '${userLoginController.name.value} post',
                                  style:
                                      TextStyle(fontSize: SizeConfig.text(12)),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: SizeConfig.height(8),
                          ),
                          TextField(
                            maxLines: 15,
                            minLines: 1,
                            autofocus: true,
                            controller: socialMediaControllers.controller,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Tulis sebuah postingan',
                              hintStyle: TextStyle(
                                fontSize: SizeConfig.text(14),
                                color: Color(0xff9E9E9E),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.width(28),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.height(4),
                          ),
                          Obx(
                            () => (socialMediaControllers.imagePath.isNotEmpty)
                                ? GestureDetector(
                                    onTap: () => Get.to(
                                        () => ViewImageFile(
                                            path:
                                                '${socialMediaControllers.imagePath.value}'),
                                        transition: Transition.rightToLeft),
                                    child: AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: SizeConfig.width(28)),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            child: Image(
                                              fit: BoxFit.cover,
                                              image: FileImage(
                                                File(
                                                    '${socialMediaControllers.imagePath.value}'),
                                              ),
                                            ),
                                          )),
                                    ),
                                  )
                                : SizedBox(),
                          ),
                          SizedBox(
                            height: SizeConfig.height(4),
                          ),
                          Obx(
                            () => (socialMediaControllers.location.isNotEmpty)
                                ? Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: SizeConfig.width(28)),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/img/image-svg/location-marker.svg',
                                          color: Colors.blue,
                                        ),
                                        SizedBox(
                                          width: SizeConfig.width(4),
                                        ),
                                        SizedBox(
                                          width: SizeConfig.width(255),
                                          child: AutoSizeText(
                                            '${socialMediaControllers.location.value}',
                                            maxLines: 4,
                                            style: TextStyle(
                                                fontSize: 10.sp,
                                                color: Colors.blue),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                          )
                        ],
                      ),
                      Container(
                        height: SizeConfig.height(64),
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.7 -
                                MediaQuery.of(context).viewInsets.bottom * 0.5),
                        child: SimpleExamplePage(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
