import 'package:aplikasi_rw/modules/profiles/screens/about_apps.dart';
import 'package:aplikasi_rw/modules/profiles/screens/notification_settings.dart';
import 'package:aplikasi_rw/modules/profiles/screens/privacy_policy.dart';
import 'package:aplikasi_rw/modules/profiles/screens/security_screen.dart';
import 'package:aplikasi_rw/modules/profiles/screens/terms_and_conditions.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({Key key}) : super(key: key);

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  final AssetImage image = AssetImage('assets/img/logo_rw.png');

  @override
  void didChangeDependencies() {
    precacheImage(image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: SizeConfig.width(200),
        leading: Row(
          children: [
            SizedBox(
              width: SizeConfig.width(16),
            ),
            Text(
              'Pengaturan',
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
            child: Column(
              children: [
                SizedBox(
                  height: SizeConfig.height(68),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  leading: SvgPicture.asset(
                    'assets/img/image-svg/lock-closed.svg',
                    width: SizeConfig.image(16),
                    height: SizeConfig.image(16),
                  ),
                  minLeadingWidth: 0,
                  title: Text(
                    'Keamanan',
                    style: TextStyle(
                      fontSize: SizeConfig.text(12),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                  trailing: Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Get.to(() => SecurityScreen(),
                        transition: Transition.rightToLeft);
                  },
                ),
                Divider(
                  thickness: 1,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  leading: SvgPicture.asset(
                    'assets/img/image-svg/bells-settings.svg',
                    width: SizeConfig.image(16),
                    height: SizeConfig.image(16),
                  ),
                  title: Text(
                    'Notifikasi',
                    style: TextStyle(
                      fontSize: SizeConfig.text(12),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                  minLeadingWidth: 0,
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    Get.to(() => NotificationSettings(),
                        transition: Transition.rightToLeft);
                  },
                ),
                Divider(
                  thickness: 1,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  leading: SvgPicture.asset(
                    'assets/img/image-svg/information-circle2.svg',
                    color: Colors.black,
                    width: SizeConfig.image(16),
                    height: SizeConfig.image(16),
                  ),
                  title: Text(
                    'Tentang Aplikasi BGM PIK',
                    style: TextStyle(
                      fontSize: SizeConfig.text(12),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                  minLeadingWidth: 0,
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    Get.to(
                      () => AboutApps(),
                      transition: Transition.rightToLeft,
                    );
                  },
                ),
                Divider(
                  thickness: 1,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  leading: SvgPicture.asset(
                    'assets/img/image-svg/flag2.svg',
                    color: Colors.black,
                    width: SizeConfig.image(16),
                    height: SizeConfig.image(16),
                  ),
                  minLeadingWidth: 0,
                  title: Text(
                    'Syarat dan Ketentuan',
                    style: TextStyle(
                      fontSize: SizeConfig.text(12),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () => Get.to(
                    () => TermAndCondition(),
                    transition: Transition.rightToLeft,
                  ),
                ),
                Divider(
                  thickness: 1,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  leading: SvgPicture.asset(
                    'assets/img/image-svg/shield-exclamation2.svg',
                    color: Colors.black,
                    width: SizeConfig.image(16),
                    height: SizeConfig.image(16),
                  ),
                  title: Text(
                    'Kebijakan Privasi',
                    style: TextStyle(
                      fontSize: SizeConfig.text(12),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                  minLeadingWidth: 0,
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    Get.to(() => PrivacyPolicy(),
                        transition: Transition.rightToLeft);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
