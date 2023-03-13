import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/modules/authentication/controllers/access_controller.dart';
import 'package:aplikasi_rw/modules/profiles/screens/change_data_user.dart';
import 'package:aplikasi_rw/modules/profiles/screens/statistik_peduli_screens.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
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
  final accessController = Get.put(AccessController());

  final AssetImage image = AssetImage('assets/img/logo_rw.png');

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));
    precacheImage(image, context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: SizeConfig.width(100),
        leading: Row(
          children: [
            SizedBox(
              width: SizeConfig.width(16),
            ),
            Text(
              'Profil',
              style: TextStyle(
                fontSize: SizeConfig.text(19),
                color: Color(0xff2094F3),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
        centerTitle: true,
        title: Image(
          width: SizeConfig.width(34),
          height: SizeConfig.height(40),
          image: image,
          fit: BoxFit.cover,
          repeat: ImageRepeat.noRepeat,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Container(
          margin: EdgeInsets.symmetric(horizontal: SizeConfig.width(16)),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: SizeConfig.height(32),
                ),
                SizedBox(
                  width: SizeConfig.width(328),
                  child: Row(
                    children: [
                      SizedBox(
                        height: SizeConfig.height(64),
                        width: SizeConfig.width(64),
                        child: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                '${ServerApp.url}${userLoginController.urlProfile.value}')),
                      ),
                      SizedBox(
                        width: SizeConfig.width(22),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: SizeConfig.width(241),
                            child: Text(
                              '${userLoginController.name.value}',
                              style: TextStyle(
                                fontSize: SizeConfig.text(19),
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.height(4),
                          ),
                          (userLoginController.cluster.value.isNotEmpty &&
                                  userLoginController
                                      .houseNumber.value.isNotEmpty)
                              ? SizedBox(
                                  width: SizeConfig.width(241),
                                  child: Text(
                                    '${userLoginController.cluster.value} No ${userLoginController.houseNumber.value}',
                                    style: TextStyle(
                                      fontSize: SizeConfig.text(10),
                                      color: Color(0xff404040),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              : SizedBox(),
                          SizedBox(
                            height: SizeConfig.height(4),
                          ),
                          SizedBox(
                            width: SizeConfig.width(241),
                            child: Text(
                              '${userLoginController.email.value}',
                              style: TextStyle(
                                fontSize: SizeConfig.text(10),
                                color: Color(0xff404040),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.height(4),
                          ),
                          SizedBox(
                            width: SizeConfig.width(241),
                            child: Text(
                              '${userLoginController.noTelp.value}',
                              style: TextStyle(
                                fontSize: SizeConfig.text(10),
                                color: Color(0xff404040),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.height(4),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Color(0xffFDF4E4),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.width(4),
                              vertical: SizeConfig.height(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image(
                                  width: SizeConfig.width(20),
                                  fit: BoxFit.cover,
                                  image: AssetImage('assets/img/isuser.png'),
                                ),
                                SizedBox(
                                  width: SizeConfig.width(4),
                                ),
                                (userLoginController.status.value
                                        .isCaseInsensitiveContainsAny('WARGA'))
                                    ? Text(
                                        'Warga ${userLoginController.rw.value}',
                                        style: TextStyle(
                                          fontSize: SizeConfig.text(10),
                                          color: Color(0xff404040),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    : Text(
                                        '${userLoginController.status.value}',
                                        style: TextStyle(
                                          fontSize: SizeConfig.text(10),
                                          color: Color(0xff404040),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
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
                  height: SizeConfig.height(40),
                ),
                Text(
                  'Akun',
                  style: TextStyle(
                      fontSize: SizeConfig.text(16),
                      fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: SizeConfig.height(16),
                ),
                (accessController.statistikPeduliLindungi.value)
                    ? Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: SvgPicture.asset(
                              'assets/img/image-svg/statistik_peduli_lingkungan.svg',
                            ),
                            dense: true,
                            minLeadingWidth: 4.w,
                            title: Text(
                              'Statistik peduli lingkungan',
                              style: TextStyle(
                                fontSize: SizeConfig.text(12),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Icon(Icons.chevron_right_rounded),
                            onTap: () => Get.to(() => StatistikPeduliScreen(),
                                transition: Transition.rightToLeft),
                          ),
                          SizedBox(
                            height: SizeConfig.height(8),
                          ),
                          Divider(
                            thickness: 2,
                          ),
                        ],
                      )
                    : SizedBox(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: SvgPicture.asset(
                    'assets/img/image-svg/pengaturan-profil.svg',
                  ),
                  dense: true,
                  minLeadingWidth: SizeConfig.width(4),
                  title: Text(
                    'Pengaturan profil',
                    style: TextStyle(
                      fontSize: SizeConfig.text(12),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Icon(Icons.chevron_right_rounded),
                  onTap: () => Get.to(() => ChangeDataUser(),
                      transition: Transition.rightToLeft),
                ),
                SizedBox(
                  height: SizeConfig.height(178),
                ),
                SizedBox(
                  width: SizeConfig.width(328),
                  height: SizeConfig.height(40),
                  child: OutlinedButton(
                      onPressed: () async {
                        await UserSecureStorage.deleteIdUser();
                        await UserSecureStorage.deleteStatus();
                        userLoginController.logout();
                        Get.delete<AccessController>();
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
                          fontSize: SizeConfig.text(16),
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
