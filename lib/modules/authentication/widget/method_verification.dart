import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MethodVerification extends StatelessWidget {
  const MethodVerification(
      {Key key, this.cardMethodVerification, this.email, this.noTelp})
      : super(key: key);

  final Function cardMethodVerification;
  final String noTelp, email;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 32.h,
        ),
        Image(
          image: AssetImage('assets/img/logo_rw.png'),
          width: 80.w,
          height: 94.h,
        ),
        SizedBox(
          height: 36.h,
        ),
        Text('Pilih Metode Verifikasi',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            )),
        SizedBox(height: 8.h),
        SizedBox(
          width: 236.w,
          child: Text(
            'Pilih salah satu metode dibawah ini untuk mendapatkan kode verifikasi',
            style: TextStyle(
              fontSize: 12.sp,
              color: Color(0xff9E9E9E),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 24.h),
        cardMethodVerification(
            subtitle: noTelp,
            icon: 'assets/img/image-svg/sms.svg',
            title: 'SMS ke',
            methodChose: 'SMS',
            email: email,
            noTelp: noTelp),
        SizedBox(height: 8.h),
        cardMethodVerification(
            subtitle: noTelp,
            icon: 'assets/img/image-svg/whatsapp-verif.svg',
            title: 'Whatsapp ke',
            methodChose: 'WHATSAPP',
            email: email,
            noTelp: noTelp),
        SizedBox(height: 8.h),
        cardMethodVerification(
            subtitle: email,
            icon: 'assets/img/image-svg/email-verif.svg',
            title: 'Email ke',
            methodChose: 'EMAIL',
            email: email,
            noTelp: noTelp),
        SizedBox(height: 106.h)
      ],
    );
  }
}
