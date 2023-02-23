import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MethodVerification extends StatelessWidget {
  MethodVerification(
      {Key key, this.cardMethodVerification, this.email, this.noTelp})
      : super(key: key);

  final Function cardMethodVerification;
  final String noTelp, email;

  final AssetImage image = AssetImage('assets/img/logo_rw.png');

  @override
  Widget build(BuildContext context) {
    precacheImage(image, context);

    ScreenUtil.init(context, designSize: const Size(360, 800));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: SizeConfig.height(32),
        ),
        Image(
          image: image,
          width: SizeConfig.width(80),
          height: SizeConfig.height(94),
        ),
        SizedBox(
          height: SizeConfig.height(36),
        ),
        Text('Pilih Metode Verifikasi',
            style: TextStyle(
              fontSize: SizeConfig.text(18),
              fontWeight: FontWeight.w700,
            )),
        SizedBox(height: SizeConfig.height(8)),
        SizedBox(
          width: SizeConfig.width(236),
          child: Text(
            'Pilih salah satu metode dibawah ini untuk mendapatkan kode verifikasi',
            style: TextStyle(
              fontSize: SizeConfig.text(12),
              color: Color(0xff9E9E9E),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: SizeConfig.height(24)),
        cardMethodVerification(
            subtitle: noTelp,
            icon: 'assets/img/image-svg/sms.svg',
            title: 'SMS ke',
            methodChose: 'SMS',
            email: email,
            noTelp: noTelp),
        SizedBox(height: SizeConfig.height(8)),
        cardMethodVerification(
            subtitle: noTelp,
            icon: 'assets/img/image-svg/whatsapp-verif.svg',
            title: 'Whatsapp ke',
            methodChose: 'WHATSAPP',
            email: email,
            noTelp: noTelp),
        SizedBox(height: SizeConfig.height(8)),
        cardMethodVerification(
            subtitle: email,
            icon: 'assets/img/image-svg/mail.svg',
            title: 'Email ke',
            methodChose: 'EMAIL',
            email: email,
            noTelp: noTelp),
        SizedBox(height: SizeConfig.height(106)),
      ],
    );
  }
}
