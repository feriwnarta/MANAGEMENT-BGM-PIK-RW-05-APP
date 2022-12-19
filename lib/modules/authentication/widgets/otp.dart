import 'dart:async';

import 'package:aplikasi_rw/controller/register_controller.dart';
import 'package:aplikasi_rw/controller/resend_otp_countdown_controller.dart';
import 'package:aplikasi_rw/modules/authentication/controllers/auth_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

//ignore: must_be_immutable
class Otp extends StatefulWidget {
  Otp(
      {Key key,
      this.email,
      this.noTelp,
      this.otpKey,
      this.validateOtp,
      this.resendOtp,
      this.context,
      this.controllerIpl,
      this.errorController})
      : super(key: key);

  String email, noTelp, otpKey;

  Function validateOtp, resendOtp;

  TextEditingController controllerIpl;

  StreamController<ErrorAnimationType> errorController;

  BuildContext context;

  @override
  State<Otp> createState() => _OtpState(
      controllerIpl: this.controllerIpl,
      email: this.email,
      errorController: this.errorController,
      noTelp: this.noTelp,
      otpKey: this.otpKey,
      resendOtp: this.resendOtp,
      validateOtp: this.validateOtp,
      context2: this.context);
}

class _OtpState extends State<Otp> {
  _OtpState(
      {this.email,
      this.noTelp,
      this.otpKey,
      this.validateOtp,
      this.resendOtp,
      this.controllerIpl,
      this.errorController,
      this.context2});

  String email, noTelp, otpKey;

  Function validateOtp, resendOtp;

  BuildContext context2;

  TextEditingController controllerIpl;

  StreamController<ErrorAnimationType> errorController;

  final countDownController = Get.put(CountDownController());

  final authController = Get.put(AuthController());

  final controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 56.h,
        ),
        SvgPicture.asset('assets/img/image-svg/otp.svg'),
        SizedBox(
          height: 16.h,
        ),
        Column(
          children: [
            Text(
              'OTP Verifikasi',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 8.h,
            ),
            SizedBox(
              width: 300.w,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Masukan OTP yang dikirim ke ',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                  children: <TextSpan>[
                    TextSpan(
                        text: (controller.methodVerifChose.value
                                .isCaseInsensitiveContainsAny('EMAIL'))
                            ? '$email'
                            : (controller.methodVerifChose.value
                                    .isCaseInsensitiveContainsAny('SMS'))
                                ? 'SMS $noTelp'
                                : 'WhatsApp $noTelp',
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black)),
                  ],
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 18.h),
        Obx(() {
          if (controller.isEmpty.value) {
            return Text(
              'OTP yang kamu masukan kosong',
              style: TextStyle(fontSize: 11.sp, color: Colors.red),
            );
          } else if (controller.isWrong.value) {
            return Text(
              'OTP yang kamu masukan salah. silahkan coba lagi.',
              style: TextStyle(fontSize: 11.sp, color: Colors.red),
            );
          } else {
            return Text(
              'OTP yang kamu masukan salah. silahkan coba lagi.',
              style: TextStyle(fontSize: 11.sp, color: Colors.white),
            );
          }
        }),
        SizedBox(height: 16.h),
        SizedBox(
          width: 237.w,
          child: PinCodeTextField(
            appContext: context,
            length: 6,
            obscureText: false,
            animationType: AnimationType.scale,
            keyboardType: TextInputType.number,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.underline,
              fieldHeight: 38.h,
              fieldWidth: 19.w,
              inactiveColor: Color(0xff9E9E9E),
            ),
            errorAnimationController: errorController,
            // animationDuration: Duration(milliseconds: 300),
            backgroundColor: Colors.white,
            enableActiveFill: false,
            onCompleted: (v) {
              validateOtp(otpKey: v);
              // countDownController.reset();
            },

            onChanged: (value) {},
            autoFocus: true,
            enablePinAutofill: false,
            beforeTextPaste: (text) {
              return false;
            },
          ),
        ),
        SizedBox(height: 44.h),
        Obx(
          () => (countDownController.count.value != 0)
              ? RichText(
                  text: TextSpan(
                    text: 'Tidak menerima OTP ? ',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    children: [
                      TextSpan(
                        text:
                            '00 :${(countDownController.count.value < 10) ? 0 : ''}${countDownController.count.value}',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, color: Colors.blue),
                      ),
                    ],
                  ),
                )
              : RichText(
                  text: TextSpan(
                    text: 'Tidak menerima OTP ',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    children: [
                      TextSpan(
                          text: ' Kirim ulang OTP',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              countDownController.reset();

                              final logger = Logger();
                              logger.d('clicked resend otp');

                              resendOtp(
                                  noIpl: controllerIpl.text,
                                  status: controller.methodVerifChose.value);

                              countDownController.countDown(
                                  iplOrEmail: (controllerIpl.text.isEmpty)
                                      ? authController.controllerUsername.text
                                      : controllerIpl.text);

                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: (controller
                                                  .methodVerifChose.value ==
                                              'EMAIL')
                                          ? Text(
                                              'Kirim ulang OTP baru ke $email')
                                          : (controller
                                                      .methodVerifChose.value ==
                                                  'WHATSAPP')
                                              ? Text(
                                                  'Kirim ulang OTP baru ke $noTelp')
                                              : Text(
                                                  'Kirim ulang OTP baru ke $noTelp')));
                            }),
                    ],
                  ),
                ),
        ),
        SizedBox(height: 32.h),
        SizedBox(
          height: 40.h,
          width: 293.w,
          child: TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Color(0xff2094F3),
            ),
            onPressed: () {
              if (otpKey != null && otpKey.length == 6) {
                validateOtp();

                // countDownController.reset();
                // final logger = Logger();
                // logger.w(countDownController.count.value);
                // print('verify');
              } else {
                // otp length not validate
                controller.isEmpty = true.obs;
                setState(() {});
              }
            },
            child: Text('Verifikasi dan Proses',
                style: TextStyle(color: Colors.white, fontSize: 14.sp)),
          ),
        ),
        SizedBox(height: 16.h),
        Obx(() => (countDownController.count.value == 0)
            ? TextButton(
                child: Text('Pilih cara lain untuk mengirim OTP ?',
                    style: TextStyle(
                      color: Color(0xff2094F3),
                      fontSize: 12.sp,
                    )),
                onPressed: (countDownController.count.value == 0)
                    ? () {
                        controller.toOtp = false.obs;
                        controller.otpWhenExit = true.obs;
                        controller.isWrong = false.obs;
                        controller.isEmpty = false.obs;

                        controller.update();
                      }
                    : null,
              )
            : SizedBox()),
        SizedBox(height: 41.h)
      ],
    );
  }
}
