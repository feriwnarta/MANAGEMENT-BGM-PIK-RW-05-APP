import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/modules/profiles/screens/change_data_user.dart';
import 'package:aplikasi_rw/modules/profiles/screens/statistik_peduli_screens.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../server-app.dart';
import '../../../utils/UserSecureStorage.dart';

class UserProfileScreen extends StatelessWidget {
  UserProfileScreen({Key key}) : super(key: key);

  final userLoginController = Get.put(UserLoginController());

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 16.h,
                ),
                Row(
                  children: [
                    AutoSizeText(
                      'Profil',
                      style: TextStyle(
                        fontSize: 19.sp,
                        color: Color(0xff2094F3),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    SizedBox(
                      width: 99.w,
                    ),
                    Image(
                      width: 34.w,
                      height: 40.h,
                      image: AssetImage('assets/img/logo_rw.png'),
                      fit: BoxFit.cover,
                      repeat: ImageRepeat.noRepeat,
                    ),
                  ],
                ),
                SizedBox(
                  height: 32.h,
                ),
                SizedBox(
                  width: 328.w,
                  child: Row(
                    children: [
                      SizedBox(
                        height: 64.h,
                        width: 64.w,
                        child: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                '${ServerApp.url}${userLoginController.urlProfile.value}')),
                      ),
                      SizedBox(
                        width: 22.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 241.w,
                            child: AutoSizeText(
                              '${userLoginController.name.value}',
                              style: TextStyle(
                                fontSize: 19.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          (userLoginController.cluster.value.isNotEmpty &&
                                  userLoginController
                                      .houseNumber.value.isNotEmpty)
                              ? SizedBox(
                                  width: 241.w,
                                  child: AutoSizeText(
                                    '${userLoginController.cluster.value} No ${userLoginController.houseNumber.value}',
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: Color(0xff404040),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              : SizedBox(),
                          SizedBox(
                            height: 4.h,
                          ),
                          SizedBox(
                            width: 241.w,
                            child: AutoSizeText(
                              '${userLoginController.email.value}',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Color(0xff404040),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          SizedBox(
                            width: 241.w,
                            child: AutoSizeText(
                              '${userLoginController.noTelp.value}',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Color(0xff404040),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            width: 85.w,
                            height: 28.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Color(0xffFDF4E4),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(
                                  height: 20.h,
                                  width: 20.w,
                                  fit: BoxFit.cover,
                                  image: AssetImage('assets/img/isuser.png'),
                                ),
                                SizedBox(
                                  child: AutoSizeText(
                                    'Warga ${userLoginController.rw.value}',
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: Color(0xff404040),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                AutoSizeText(
                  'Akun',
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 16.h,
                ),
                ListTile(
                  leading: SvgPicture.asset(
                    'assets/img/image-svg/statistik_peduli_lingkungan.svg',
                  ),
                  dense: true,
                  minLeadingWidth: 4.w,
                  title: AutoSizeText(
                    'Statistik peduli lingkungan',
                    style: TextStyle(
                      fontSize: 12.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Icon(Icons.chevron_right_rounded),
                  onTap: () => Get.to(() => StatistikPeduliScreen(),
                      transition: Transition.rightToLeft),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Divider(
                  thickness: 2,
                ),
                ListTile(
                  leading: SvgPicture.asset(
                    'assets/img/image-svg/pengaturan-profil.svg',
                  ),
                  dense: true,
                  minLeadingWidth: 4.w,
                  title: AutoSizeText(
                    'Pengaturan profil',
                    style: TextStyle(
                      fontSize: 12.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Icon(Icons.chevron_right_rounded),
                  onTap: () => Get.to(() => ChangeDataUser(),
                      transition: Transition.rightToLeft),
                ),
                SizedBox(
                  height: 208.h,
                ),
                SizedBox(
                  width: 328.w,
                  child: OutlinedButton(
                      onPressed: () async {
                        await UserSecureStorage.deleteIdUser();
                        await UserSecureStorage.deleteStatus();
                        userLoginController.logout();
                        Get.offAllNamed(RouteName.home);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Color(0xffED1C24),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Text(
                        'Keluar',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Color(0xffED1C24),
                        ),
                      )),
                )
              ],
            ),
          ),
        )),
      ),
    );
  }
}