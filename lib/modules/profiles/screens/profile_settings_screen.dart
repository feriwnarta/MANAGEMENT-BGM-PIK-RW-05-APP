import 'package:aplikasi_rw/modules/profiles/screens/notification_settings.dart';
import 'package:aplikasi_rw/modules/profiles/screens/security_screen.dart';
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
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                SizedBox(
                  height: 22.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      'Pengaturan',
                      style: TextStyle(fontSize: 19.sp),
                      maxLines: 1,
                      minFontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      width: 41.w,
                    ),
                    Image(
                      width: 34.w,
                      height: 40.h,
                      image: AssetImage('assets/img/logo_rw.png'),
                      fit: BoxFit.cover,
                      repeat: ImageRepeat.noRepeat,
                    )
                  ],
                ),
                SizedBox(
                  height: 68.h,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  leading:
                      SvgPicture.asset('assets/img/image-svg/lock-closed.svg'),
                  title: AutoSizeText(
                    'Keamanan',
                    style: TextStyle(
                      fontSize: 12.sp,
                    ),
                    minFontSize: 12,
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
                      'assets/img/image-svg/bells-settings.svg'),
                  title: AutoSizeText(
                    'Notifikasi',
                    style: TextStyle(
                      fontSize: 12.sp,
                    ),
                    minFontSize: 12,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
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
                  ),
                  title: AutoSizeText(
                    'Tentang Aplikasi BGM PIK',
                    style: TextStyle(
                      fontSize: 12.sp,
                    ),
                    minFontSize: 12,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {},
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
                  ),
                  title: AutoSizeText(
                    'Syarat dan Ketentuan',
                    style: TextStyle(
                      fontSize: 12.sp,
                    ),
                    minFontSize: 12,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                  trailing: Icon(Icons.chevron_right),
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
                  ),
                  title: AutoSizeText(
                    'Kebijakan Privasi',
                    style: TextStyle(
                      fontSize: 12.sp,
                    ),
                    minFontSize: 12,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
