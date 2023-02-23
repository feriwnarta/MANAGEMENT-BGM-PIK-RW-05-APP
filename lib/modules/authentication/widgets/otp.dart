import 'dart:async';

import 'package:aplikasi_rw/controller/register_controller.dart';
import 'package:aplikasi_rw/controller/resend_otp_countdown_controller.dart';
import 'package:aplikasi_rw/modules/authentication/controllers/auth_controller.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
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
    ScreenUtil.init(context, designSize: const Size(360, 800));
    return Column(
      children: [
        SizedBox(
          height: SizeConfig.height(56),
        ),
        SvgPicture.asset('assets/img/image-svg/otp.svg'),
        SizedBox(
          height: SizeConfig.height(16),
        ),
        Column(
          children: [
            Text(
              'OTP Verifikasi',
              style: TextStyle(
                  fontSize: SizeConfig.text(18), fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: SizeConfig.height(8),
            ),
            SizedBox(
              width: SizeConfig.width(300),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Masukan OTP yang dikirim ke ',
                  style: TextStyle(
                      fontSize: SizeConfig.text(12), color: Colors.grey),
                  children: <TextSpan>[
                    TextSpan(
                        text: (controller.methodVerifChose.value == 'EMAIL')
                            ? '$email'
                            : (controller.methodVerifChose.value == 'SMS')
                                ? 'SMS $noTelp'
                                : 'WhatsApp $noTelp',
                        style: TextStyle(
                            fontSize: SizeConfig.text(12),
                            fontWeight: FontWeight.w700,
                            color: Colors.black)),
                  ],
                ),
              ),
            )
          ],
        ),
        SizedBox(height: SizeConfig.height(18)),
        Obx(() {
          if (controller.isEmpty.value) {
            return Text(
              'OTP yang kamu masukan kosong',
              style:
                  TextStyle(fontSize: SizeConfig.text(11), color: Colors.red),
            );
          } else if (controller.isWrong.value) {
            return Text(
              'OTP yang kamu masukan salah. silahkan coba lagi.',
              style:
                  TextStyle(fontSize: SizeConfig.text(11), color: Colors.red),
            );
          } else {
            return Text(
              'OTP yang kamu masukan salah. silahkan coba lagi.',
              style:
                  TextStyle(fontSize: SizeConfig.text(11), color: Colors.white),
            );
          }
        }),
        SizedBox(height: SizeConfig.text(16)),
        SizedBox(
          width: SizeConfig.width(237),
          child: PinCodeTextField(
            appContext: context,
            length: 6,
            obscureText: false,
            animationType: AnimationType.scale,
            keyboardType: TextInputType.number,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.underline,
              fieldHeight: SizeConfig.height(38),
              fieldWidth: SizeConfig.width(19),
              inactiveColor: Color(0xff9E9E9E),
            ),
            textStyle: TextStyle(fontSize: SizeConfig.text(30)),
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
        SizedBox(height: SizeConfig.height(44)),
        Obx(
          () => (countDownController.count.value != 0)
              ? RichText(
                  text: TextSpan(
                    text: 'Tidak menerima OTP ? ',
                    style: TextStyle(
                        fontSize: SizeConfig.text(12), color: Colors.grey),
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
                    style: TextStyle(
                        fontSize: SizeConfig.text(12), color: Colors.grey),
                    children: [
                      TextSpan(
                        text: ' Kirim ulang OTP',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            countDownController.reset();

                            final logger = Logger();
                            logger.d('clicked resend otp');

                            await resendOtp(
                                noIpl: controllerIpl.text,
                                status: controller.methodVerifChose.value);

                            countDownController.countDown(
                                iplOrEmail: (controllerIpl.text.isEmpty)
                                    ? authController.controllerUsername.text
                                    : controllerIpl.text);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: (controller.methodVerifChose.value ==
                                        'EMAIL')
                                    ? Text(
                                        'Kirim ulang OTP baru ke $email',
                                        style: TextStyle(
                                          fontSize: SizeConfig.text(12),
                                        ),
                                      )
                                    : (controller.methodVerifChose.value ==
                                            'WHATSAPP')
                                        ? Text(
                                            'Kirim ulang OTP baru ke $noTelp',
                                            style: TextStyle(
                                              fontSize: SizeConfig.text(12),
                                            ),
                                          )
                                        : Text(
                                            'Kirim ulang OTP baru ke $noTelp',
                                            style: TextStyle(
                                              fontSize: SizeConfig.text(12),
                                            ),
                                          ),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
        ),
        SizedBox(height: SizeConfig.height(32)),
        SizedBox(
          height: SizeConfig.height(40),
          width: SizeConfig.width(293),
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
                style: TextStyle(
                    color: Colors.white, fontSize: SizeConfig.text(14))),
          ),
        ),
        SizedBox(height: SizeConfig.height(16)),
        Obx(() => (countDownController.count.value == 0)
            ? TextButton(
                child: Text('Pilih cara lain untuk mengirim OTP ?',
                    style: TextStyle(
                      color: Color(0xff2094F3),
                      fontSize: SizeConfig.text(12),
                    )),
                onPressed: (countDownController.count.value == 0)
                    ? () {
                        controller.toOtp = false.obs;
                        controller.toOtpVerif = true.obs;
                        controller.isWrong = false.obs;
                        controller.isEmpty = false.obs;

                        final logger = Logger();
                        logger.e('${controller.toOtpVerif.value}');

                        controller.update();
                      }
                    : null,
              )
            : SizedBox()),
        SizedBox(height: SizeConfig.height(41))
      ],
    );
  }
}
