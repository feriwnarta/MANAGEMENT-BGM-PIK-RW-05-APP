import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'package:aplikasi_rw/controller/register_controller.dart';
import 'package:aplikasi_rw/controller/resend_otp_countdown_controller.dart';
import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/screen/login_screen/validate/validate_email_and_password.dart';
import 'package:aplikasi_rw/screen/splash_screen/SplashView.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/services/send_otp_services.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:async/async.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  String email, noTelp;
  TextEditingController controllerIpl;

  LoginScreen({this.email, this.noTelp, this.controllerIpl});

  @override
  State<LoginScreen> createState() => _LoginScreenState(
      controllerIpl: controllerIpl, email: email, noTelp: noTelp);
}

class _LoginScreenState extends State<LoginScreen> with ValidationForm {
  final _formKeyLogin = GlobalKey<FormState>();
  final _formKeyRegister = GlobalKey<FormState>();
  final _formKeyCreatePassword = GlobalKey<FormState>();

  double mediaSizeHeight, mediaSizeWidth;
  bool _isObscure = true;
  bool _isObscure2 = true;
  Color buttonLoginRegister = Colors.lightBlue[400];
  TextEditingController controllerUsername = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  TextEditingController controllerIpl;
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerNoTelp = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController num1 = TextEditingController();
  TextEditingController num2 = TextEditingController();
  TextEditingController num3 = TextEditingController();
  TextEditingController num4 = TextEditingController(text: '\u200b');
  TextEditingController num5 = TextEditingController();
  TextEditingController num6 = TextEditingController();

  // UserLoadingBloc bloc;

  String otpKey;
  bool isLogin = true;
  final registerController = Get.put(RegisterController());
  final _scaffoldkey = new GlobalKey<ScaffoldState>();
  final loginController = Get.put(UserLoginController());
  final countDownController = Get.put(CountDownController());

  bool passwordWrong = false;
  String email, noTelp;
  bool isIplSuccess = false;

  CancelableOperation cancelableOperation;

  var enabled1 = false.obs;
  var enabled2 = false.obs;
  var enabled3 = false.obs;
  var enabled4 = false.obs;
  var enabled5 = false.obs;
  var enabled6 = false.obs;

  String idUser, status;

  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>.broadcast();

  _LoginScreenState({this.email, this.noTelp, this.controllerIpl});

  @override
  initState() {
    super.initState();
    if (email != null && noTelp != null) {
      if (email.isNotEmpty && noTelp.isNotEmpty) {
        final logger = Logger();
        logger.e('email ga kosong');
        registerController.otpWhenExit = true.obs;
      }
    } else {
      controllerIpl = TextEditingController();
    }

    final storage = FlutterSecureStorage();
    storage.read(key: 'successotp').then((value) {
      final logger = Logger();
      logger.e(registerController.otpWhenExit.value);
    });
  }

  @override
  void dispose() {
    controllerUsername.clear();
    controllerPassword.clear();
    controllerIpl.clear();
    controllerEmail.clear();
    controllerNoTelp.clear();
    _passwordController.clear();
    num1.clear();
    num2.clear();
    num3.clear();
    num4.clear();
    num5.clear();
    num6.clear();
    // bloc.close();

    Get.delete<RegisterController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: Stack(
        children: [
          Container(
            height: 302.h,
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(30)),
                image: DecorationImage(
                  image: AssetImage('assets/img/background-login-rw.png'),
                  alignment: Alignment.center,
                  fit: BoxFit.fill,
                  repeat: ImageRepeat.noRepeat,
                )),
          ),
          Center(
            child: SingleChildScrollView(
              child: SizedBox(
                width: 325.w,
                child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: GetBuilder<RegisterController>(
                      init: registerController,
                      builder: (controller) {
                        if (registerController.toPassword.value) {
                          return createPassword();
                        } else if (registerController.toSucces.value) {
                          return createPasswordSucces();
                        } else if (registerController.toOtp.value) {
                          return otp(context);
                        } else if (registerController.toOtpVerif.value) {
                          return methodVerification(
                              controllerEmail.text, controllerNoTelp.text);
                        } else if (registerController.toResetPassword.value) {
                          if (controllerUsername.text.isNotEmpty &&
                              registerController.iplOrEmailValid.value ==
                                  false &&
                              isIplSuccess == true) {
                            return methodVerification(email, noTelp);
                          } else {
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
                                  Form(
                                    // key: _formKeyLogin,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: 280.w,
                                          child: Text(
                                            '* Enter your IPL number or email, the system will automatically detect it',
                                            style: TextStyle(
                                                fontSize: 11.sp,
                                                color: Colors.grey),
                                          ),
                                        ),
                                        SizedBox(height: 5.h),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16.w),
                                          child: TextFormField(
                                            controller: controllerUsername,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            decoration: InputDecoration(
                                              errorText: !registerController
                                                      .iplOrEmailValid.value
                                                  ? null
                                                  : 'Your email/ipl number is incorrect',
                                              icon: SvgPicture.asset(
                                                  'assets/img/image-svg/user-login.svg'),
                                              hintText:
                                                  'Enter your email / IPL number',
                                              hintStyle:
                                                  TextStyle(fontSize: 14.sp),
                                              border: UnderlineInputBorder(),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: (registerController
                                                            .iplOrEmailSucces
                                                            .value)
                                                        ? Colors.blue
                                                        : Colors.grey),
                                              ),
                                              suffixIcon: (!registerController
                                                      .iplOrEmailValid.value)
                                                  ? (registerController
                                                          .iplOrEmailSucces
                                                          .value)
                                                      ? SvgPicture.asset(
                                                          'assets/img/image-svg/success.svg',
                                                        )
                                                      : null
                                                  : SvgPicture.asset(
                                                      'assets/img/image-svg/close.svg',
                                                    ),
                                              suffixIconConstraints:
                                                  BoxConstraints(
                                                      minHeight: 5.h,
                                                      minWidth: 5.w),
                                            ),
                                            onChanged: (value) async {
                                              cancelableOperation =
                                                  CancelableOperation
                                                      .fromFuture(
                                                          Future.delayed(
                                                              Duration(
                                                                  seconds: 1),
                                                              () async {
                                                if (controllerUsername
                                                    .text.isNotEmpty) {
                                                  await checkEmailIpl(
                                                      controllerUsername.text);
                                                  await cancelableOperation
                                                      .cancel();
                                                  setState(() {});
                                                } else {
                                                  registerController
                                                          .iplOrEmailValid =
                                                      false.obs;
                                                  registerController
                                                          .iplOrEmailSucces =
                                                      false.obs;
                                                  setState(() {});
                                                }
                                              }));
                                            },
                                            validator: (value) {
                                              if (value != null &&
                                                  value.length >= 5) {
                                                return null;
                                              } else {
                                                return 'IPL number cannot be empty and must be valid';
                                              }
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 32.h),
                                        SizedBox(
                                          height: 66.h,
                                        ),
                                      ],
                                    ),
                                  ),
                                ]);
                          }
                        } else if (registerController.otpWhenExit.value) {
                          return methodVerification(email, noTelp);
                        } else {
                          return registerAndLoginForm();
                        }
                      },
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }

  Column methodVerification(String email, String noTelp) {
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

  Column createPasswordSucces() {
    return Column(
      children: [
        SizedBox(height: 56.h),
        SvgPicture.asset('assets/img/image-svg/otp-succes.svg'),
        SizedBox(
          height: 16.h,
        ),
        SizedBox(
          width: 190.w,
          child: Text('Sandi berhasil dibuat',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700)),
        ),
        SizedBox(height: 176.h),
        SizedBox(
          height: 40.h,
          width: 293.w,
          child: TextButton(
            // shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(20)),
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () async {
              // registerController.toSucces = false.obs;
              registerController.resetController();
              // final storage = FlutterSecureStorage();
              // await storage.delete(key: 'successotp');
              // await storage.delete(key: 'noipl');
              // await storage.delete(key: 'email');
              // await storage.delete(key: 'notelp');
              // bloc.add(UserLogOut());
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                  (route) => false);
            },
            child: Text('Masuk Sekarang',
                style: TextStyle(color: Colors.white, fontSize: 14.sp)),
          ),
        ),
        SizedBox(height: 72.h)
      ],
    );
  }

  Column createPassword() {
    return Column(
      children: [
        SizedBox(height: 56.h),
        SvgPicture.asset('assets/img/image-svg/otp-key.svg'),
        SizedBox(height: 16.h),
        Text(
          'Buat Kata Sandi',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 8),
        Text(
          'kata sandi yang kuat akan menghindari pencurian akun',
          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
        ),
        SizedBox(height: 32.h),
        Form(
          key: _formKeyCreatePassword,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: TextFormField(
              keyboardType: TextInputType.visiblePassword,
              controller: _passwordController,
              obscureText: _isObscure2,
              decoration: InputDecoration(
                  icon: SvgPicture.asset('assets/img/image-svg/key.svg'),
                  suffixIcon: IconButton(
                    icon: Icon((_isObscure2)
                        ? Icons.visibility_off_outlined
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isObscure2 = !_isObscure2;
                      });
                    },
                  ),
                  errorMaxLines: 2,
                  hintText: 'Masukan kata sandi',
                  hintStyle: TextStyle(fontSize: 14.sp),
                  border: UnderlineInputBorder()),
              validator: (value) {
                if (value.length < 8) {
                  return 'kata sandi harus memiliki panjang 8 sampai 72 karakter';
                } else if (value.length >= 72) {
                  return 'kata sandi harus memiliki panjang 8 sampai 72 karakter';
                } else if (value.isEmpty) {
                  return 'kata sandi tidak boleh kosong';
                } else {
                  return null;
                }
              },
            ),
          ),
        ),
        SizedBox(
          height: 14.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kata sandi Anda harus :',
                style: TextStyle(color: Colors.grey, fontSize: 10.sp),
              ),
              Text(
                '* panjangnya 8 hingga 72 karakter',
                style: TextStyle(color: Colors.grey, fontSize: 10.sp),
              ),
              Text(
                '* tidak mengandung email nama Anda',
                style: TextStyle(color: Colors.grey, fontSize: 10.sp),
              ),
              Text(
                '* tidak umum digunakan dan mudah ditebak',
                style: TextStyle(color: Colors.grey, fontSize: 10.sp),
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
                    backgroundColor: Colors.lightBlue[400],
                  ),
                  onPressed: () {
                    if (_formKeyCreatePassword.currentState.validate()) {
                      insertPassword(password: _passwordController.text);
                    }
                  },
                  child: Text('Buat Kata Sandi',
                      style: TextStyle(color: Colors.white, fontSize: 14.sp)),
                ),
              ),
              SizedBox(
                height: 72.h,
              )
            ],
          ),
        )
      ],
    );
  }

  Column otp(BuildContext context) {
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
                        text: (registerController.methodVerifChose.value
                                .isCaseInsensitiveContainsAny('EMAIL'))
                            ? '$email'
                            : (registerController.methodVerifChose.value
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
          if (registerController.isEmpty.value) {
            return Text(
              'OTP yang kamu masukan kosong',
              style: TextStyle(fontSize: 11.sp, color: Colors.red),
            );
          } else if (registerController.isWrong.value) {
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
                              logger.w(countDownController.count.value);

                              resendOtp(
                                  noIpl: controllerIpl.text,
                                  status: registerController
                                      .methodVerifChose.value);

                              countDownController.countDown(
                                  iplOrEmail: (controllerIpl.text.isEmpty)
                                      ? controllerUsername.text
                                      : controllerIpl.text);

                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: (registerController
                                                  .methodVerifChose.value ==
                                              'EMAIL')
                                          ? Text(
                                              'Kirim ulang OTP baru ke $email')
                                          : (registerController
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
                registerController.isEmpty = true.obs;
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
                        registerController.toOtp = false.obs;
                        registerController.otpWhenExit = true.obs;
                        registerController.isWrong = false.obs;
                        registerController.isEmpty = false.obs;

                        registerController.update();
                      }
                    : null,
              )
            : SizedBox()),
        SizedBox(height: 41.h)
      ],
    );
  }

  Column registerAndLoginForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
          height: 32.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 40.h,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[400]),
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      backgroundColor:
                          (isLogin) ? Colors.lightBlue[400] : Colors.white,
                      padding:
                          EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),
                    ),
                    onPressed: () {
                      setState(() {
                        isLogin = true;
                      });
                    },
                    child: Text(
                      'Masuk',
                      style: TextStyle(
                          color:
                              (isLogin) ? Colors.white : Colors.lightBlue[400],
                          fontSize: 14.sp),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      backgroundColor:
                          (!isLogin) ? Colors.lightBlue[400] : Colors.white,
                      padding:
                          EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),
                    ),
                    onPressed: () {
                      // Navigator.of(context)
                      //     .push(MaterialPageRoute(
                      //   builder: (context) => RegisterScreen(),
                      // ));
                      setState(() {
                        isLogin = false;
                      });
                    },
                    child: Text('Daftar',
                        style: TextStyle(
                            color: (isLogin)
                                ? Colors.lightBlue[400]
                                : Colors.white,
                            fontSize: 14.sp)),
                  )
                ],
              ),
            ),
          ],
        ),
        // (formLoginOrRegister)
        SizedBox(height: 48.h),
        (isLogin) ? buildFormLogin() : buildFormRegister(),
        SizedBox(
          height: 2.h,
        )
      ],
    );
  }

  Obx buildFormLogin() {
    return Obx(
      () => Form(
        key: _formKeyLogin,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: TextFormField(
                controller: controllerUsername,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  errorText: !registerController.iplOrEmailValid.value
                      ? null
                      : 'Nomor email / ipl anda salah',
                  icon: SvgPicture.asset('assets/img/image-svg/user-login.svg'),
                  hintText: 'Masukan email / nomor IPL',
                  hintStyle: TextStyle(fontSize: 14.sp),
                  border: UnderlineInputBorder(),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: (registerController.iplOrEmailSucces.value)
                            ? Colors.blue
                            : Colors.grey),
                  ),
                  suffixIcon: (!registerController.iplOrEmailValid.value)
                      ? (registerController.iplOrEmailSucces.value)
                          ? SvgPicture.asset(
                              'assets/img/image-svg/success.svg',
                            )
                          : null
                      : GestureDetector(
                          child: SvgPicture.asset(
                            'assets/img/image-svg/close.svg',
                          ),
                          onTap: () {
                            controllerUsername.text = '';
                            registerController.iplOrEmailValid = false.obs;
                            registerController.iplOrEmailSucces = false.obs;
                            setState(() {});
                          },
                        ),
                  suffixIconConstraints:
                      BoxConstraints(minHeight: 5.h, minWidth: 5.w),
                ),
                validator: (value) {
                  if (value != null && value.length >= 5) {
                    return null;
                  } else {
                    return 'Nomor ipl anda tidak boleh kosong dan harus sesuai';
                  }
                },
                onChanged: (value) async {
                  cancelableOperation = CancelableOperation.fromFuture(
                      Future.delayed(Duration(seconds: 1), () async {
                    if (controllerUsername.text.isNotEmpty) {
                      await checkEmailIpl(controllerUsername.text);
                      await cancelableOperation.cancel();
                      setState(() {});
                    } else {
                      registerController.iplOrEmailValid = false.obs;
                      registerController.iplOrEmailSucces = false.obs;
                      setState(() {});
                    }
                  }));
                },
              ),
            ),
            SizedBox(height: 32.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _isObscure,
                    controller: controllerPassword,
                    decoration: InputDecoration(
                        icon: SvgPicture.asset('assets/img/image-svg/key.svg'),
                        suffixIcon: IconButton(
                          icon: Icon((_isObscure)
                              ? Icons.visibility_off_outlined
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                        errorText:
                            (passwordWrong) ? 'Kata sandi anda salah !' : null,
                        hintText: 'Masukan kata sandi',
                        hintStyle: TextStyle(fontSize: 14.sp),
                        border: UnderlineInputBorder()),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Kata sandi tidak boleh kosong';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text('Lupa kata sandi ?',
                            style: TextStyle(fontSize: 14.sp)),
                        onPressed: () {
                          registerController.toResetPassword = true.obs;
                          setState(() {});
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
            SizedBox(
              height: 40.h,
              width: 293.w,
              child: TextButton(
                child: Text(
                  'Masuk',
                  style: TextStyle(color: Colors.white, fontSize: 11.0.sp),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.lightBlue[400],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () async {
                  // await userLogin();
                  if (_formKeyLogin.currentState.validate()) {
                    await userLogin();
                    final logger = Logger();
                    logger.d('clicked');
                  }
                  // final logger = Logger();
                  // logger.w('test');
                },
              ),
            ),
            SizedBox(
              height: 66.h,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkEmailIpl(String iplOrEmail) async {
    String url = '${ServerApp.url}src/login/check_ipl_email.php';
    var data = {'iplOrEmail': iplOrEmail};
    try {
      var response = await http.post(Uri.parse(url), body: jsonEncode(data));
      if (response.statusCode >= 200 && response.statusCode <= 399) {
        var message = jsonDecode(response.body);
        if (message['status'] == 'success') {
          registerController.iplOrEmailValid = false.obs;
          registerController.iplOrEmailSucces = true.obs;
          email = message['email'];
          noTelp = message['no_telp'];
          isIplSuccess = true;
        } else {
          registerController.iplOrEmailValid = true.obs;
        }
      }
    } catch (exception) {
      throw Exception(exception.toString());
    }
  }

  Form buildFormRegister() {
    return Form(
      key: _formKeyRegister,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextFormField(
              controller: controllerIpl,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  icon: SvgPicture.asset('assets/img/image-svg/user-login.svg'),
                  hintText: 'Masukan nomor IPL',
                  hintStyle: TextStyle(fontSize: 14.sp),
                  border: UnderlineInputBorder()),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Nomor IPL tidak boleh kosong';
                } else {
                  return null;
                }
              },
            ),
          ),
          SizedBox(height: 32.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: controllerEmail,
                  decoration: InputDecoration(
                      icon: SvgPicture.asset('assets/img/image-svg/email.svg'),
                      hintText: 'Masukan Email',
                      hintStyle: TextStyle(fontSize: 14.sp),
                      border: UnderlineInputBorder()),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    } else {
                      return null;
                    }
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 32.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: controllerNoTelp,
                  decoration: InputDecoration(
                      icon: SvgPicture.asset(
                          'assets/img/image-svg/handphone.svg'),
                      hintText: 'Masukan nomor telpon',
                      hintStyle: TextStyle(fontSize: 14.sp),
                      border: UnderlineInputBorder()),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Nomor telpon tidak boleh kosong';
                    } else {
                      return null;
                    }
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 42.h),
          SizedBox(
            width: 293.w,
            height: 40.h,
            child: TextButton(
              child: Text(
                'Daftar',
                style: TextStyle(color: Colors.white, fontSize: 11.0.sp),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.lightBlue[400],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: () {
                if (_formKeyRegister.currentState.validate()) {
                  userRegister(controllerIpl.text, controllerEmail.text,
                      controllerNoTelp.text);
                  setState(() {
                    email = controllerEmail.text;
                    noTelp = controllerNoTelp.text;
                  });
                }
              },
            ),
          ),
          SizedBox(height: 40.h)
        ],
      ),
    );
  }

  Future<String> checkNumberPhone(String phone) async {
    String url = '${ServerApp.url}/src/login/otp/check_number_wa.php';
    var data = {'phone': phone};
    var request = await http.post(Uri.parse(url), body: jsonEncode(data));

    if (request.statusCode >= 200 && request.statusCode <= 399) {
      String message = jsonDecode(request.body);

      if (message != null && message.isNotEmpty) {
        if (message.isCaseInsensitiveContainsAny('FOUND')) {
          return message;
        } else {
          return message;
        }
      }
    } else {
      return 'SERVER ERROR';
    }
    return 'NOT FOUND';
  }

  Future resendOtp({String noIpl, String status}) async {
    String url = '${ServerApp.url}src/login/resend_otp.php';
    var data;
    if (controllerIpl.text.isNotEmpty) {
      data = {'noIplOrEmail': controllerIpl.text, 'status': status};
    } else {
      data = {'noIplOrEmail': controllerUsername.text, 'status': status};
    }

    try {
      // buildShowDialogAnimation(
      //     '', '', 'assets/animation/loading-plane.json', 100);
      EasyLoading.show(status: 'loading');
      http.Response response =
          await http.post(Uri.parse(url), body: json.encode(data));
      print('response ${response.body}');
      if (response.body != null && response.body.isNotEmpty) {
        if (response.body.contains('email terkirim')) {
          // Navigator.of(context).pop();
          EasyLoading.dismiss();
          EasyLoading.showSuccess(
            'Mengirim ulang kode OTP ke email sukses',
            dismissOnTap: true,
          );
          EasyLoading.dismiss();
          // buildShowDialogAnimation('Mengirim ulang kode OTP ke email sukses',
          //     'OKE', 'assets/animation/succes-animation.json', 100);
          setState(() {});
        } else if (response.body.contains('success kirim otp wa')) {
          EasyLoading.dismiss();
          EasyLoading.showSuccess(
            'Mengirim ulang kode OTP ke whatsapp sukses',
            dismissOnTap: true,
          );
          // Navigator.of(context).pop();
          // buildShowDialogAnimation('Mengirim ulang kode OTP ke whatsapp sukses',
          //     'OKE', 'assets/animation/succes-animation.json', 100);
          setState(() {});
        } else if (response.body.contains('no ipl tidak ada')) {
          // Navigator.of(context).pop();
          EasyLoading.dismiss();
          EasyLoading.showError('Nomor IPL tidak ditemukan');
          // buildShowDialogAnimation('Nomor IPL tidak ditemukan', 'OKE',
          //     'assets/animation/error-animation.json', 100);
          setState(() {});
        } else {
          // Navigator.of(context).pop();
          EasyLoading.dismiss();
          EasyLoading.show(status: 'ada yang salah, silahkan hubungi admin');
          // buildShowDialogAnimation(
          //     'Ada yang salah, silahkan hubungi administrator',
          //     'OKE',
          //     'assets/animation/error-animation.json',
          //     15.0);
        }
      }
    } on io.SocketException {
      EasyLoading.dismiss();
      EasyLoading.showError('No internet');
      EasyLoading.dismiss();
      // buildShowDialogAnimation(
      //     'No Internet', 'OKE', 'assets/animation/error-animation.json', 15.0);
    } on io.HttpException {
      EasyLoading.dismiss();
      EasyLoading.showError('Server error');
      EasyLoading.dismiss();
      // buildShowDialogAnimation(
      //     'Server Error', 'OKE', 'assets/animation/error-animation.json', 15.0);
    }
  }

  Future insertPassword({String password}) async {
    String url = '${ServerApp.url}src/login/create_password.php';

    var data;
    if (controllerIpl.text.isNotEmpty) {
      data = {'noIplOrEmail': controllerIpl.text, 'password': password};
    } else {
      data = {'noIplOrEmail': controllerUsername.text, 'password': password};
    }

    try {
      // buildShowDialogAnimation(
      //     '', '', 'assets/animation/loading-plane.json', 2.0.h);
      EasyLoading.show(status: 'loading');
      http.Response response =
          await http.post(Uri.parse(url), body: json.encode(data));
      print('response ${response.body}');
      if (response.body != null && response.body.isNotEmpty) {
        if (response.body.contains('OKE')) {
          // Navigator.of(context).pop();
          EasyLoading.dismiss();
          registerController.resetController();
          registerController.toSucces = true.obs;
          registerController.update();
          // registerController.resetController();
          // email
          final storage = FlutterSecureStorage();
          await storage.delete(key: 'successotp');
          await storage.delete(key: 'noipl');
          await storage.delete(key: 'email');
          await storage.delete(key: 'notelp');
          final logger = Logger();
          storage.read(key: 'successotp').then((value) {
            logger.e(value);
          });
          // setState(() {});
        } else if (response.body.contains('FAILL')) {
          // Navigator.of(context).pop();
          EasyLoading.dismiss();
          EasyLoading.showError(
              'password tidak bisa dibuat, tolong hubungi admin',
              dismissOnTap: true);
          // buildShowDialogAnimation(
          //     'Password can\'t create, Please Contact Administrator',
          //     'OKE',
          //     'assets/animation/error-animation.json',
          //     15.0);
          setState(() {});
        } else {
          // Navigator.of(context).pop();
          EasyLoading.dismiss();
          EasyLoading.showError(
            'ada sesuatu yang salah, tolong hubungi admin',
            dismissOnTap: true,
          );
          // buildShowDialogAnimation('Somethine Went Wrong', 'OKE',
          //     'assets/animation/error-animation.json', 15.0);
        }
      }
    } on io.SocketException {
      // buildShowDialogAnimation(
      //     'No Internet', 'OKE', 'assets/animation/error-animation.json', 15.0);
      EasyLoading.showError('No internet', dismissOnTap: true);
    } on io.HttpException {
      EasyLoading.showError('Server error', dismissOnTap: true);
      // buildShowDialogAnimation(
      //     'Server Error', 'OKE', 'assets/animation/error-animation.json', 15.0);
    }
  }

  Future validateOtp({String otpKey}) async {
    String url = '${ServerApp.url}src/login/verify_otp.php';

    var data;
    if (controllerIpl.text.isEmpty) {
      data = {'iplOrEmail': controllerUsername.text, 'otp': otpKey};
    } else {
      data = {'iplOrEmail': controllerIpl.text, 'otp': otpKey};
    }
    final logger = Logger();
    logger.d(otpKey);
    logger.d(controllerUsername.text);
    try {
      // buildShowDialogAnimation(
      //     '', '', 'assets/animation/loading-plane.json', 2.0.h);
      EasyLoading.show(status: 'loading');
      http.Response response =
          await http.post(Uri.parse(url), body: json.encode(data));
      print('response ${response.body}');
      if (response.body != null && response.body.isNotEmpty) {
        if (response.body.contains('OKE')) {
          // jika otp dari login berhasil
          if (registerController.fromLogin.value) {
            await UserSecureStorage.setIdUser(this.idUser);
            await UserSecureStorage.setStatusLogin(this.status);
            String idUser = await UserSecureStorage.getIdUser();
            // countDownController.reset();
            countDownController.reset();
            if (idUser.isNotEmpty) {
              // Navigator.of(context).pop();
              EasyLoading.dismiss();
              registerController.resetController();
              registerController.update();
              Get.offAll(SplashView());
            }
          } else {
            // Navigator.of(context).pop();
            EasyLoading.dismiss();
            registerController.isEmpty = false.obs;
            registerController.toPassword = true.obs;
            setState(() {});
          }
        } else if (response.body.contains('FAILL')) {
          // Navigator.of(context).pop();
          EasyLoading.dismiss();
          registerController.isEmpty = false.obs;
          registerController.isWrong = true.obs;
          errorController.add(ErrorAnimationType.shake);
          setState(() {});
        } else {
          // Navigator.of(context).pop();
          EasyLoading.dismiss();
          EasyLoading.showError(
              'Ada sesuatu yang salah, silahkan hubungi admin',
              dismissOnTap: true);
          // buildShowDialogAnimation('Somethine Went Wrong', 'OKE',
          //     'assets/animation/error-animation.json', 15.0);
        }
      }
    } on io.SocketException {
      buildShowDialogAnimation(
          'No Internet', 'OKE', 'assets/animation/error-animation.json', 15.0);
    } on io.HttpException {
      buildShowDialogAnimation(
          'Server Error', 'OKE', 'assets/animation/error-animation.json', 15.0);
    }
  }

  Future<void> emailServices(
      String email, String noTelp, String methodChose) async {
    final logger = Logger();
    logger.e('email services di klik');
    await SendOtpServices.sendOtpGmail(email: email, noTelp: noTelp)
        .then((request) {
      // buildShowDialogAnimation(
      //     '', '', 'assets/animation/loading-plane.json', 100);
      EasyLoading.show(status: 'loading');
      request.send().then((streamResponse) {
        http.Response.fromStream(streamResponse).then((response) {
          String message = jsonDecode(response.body);
          if (message == 'success') {
            logger.e('succes kirim otp gmail $email, $noTelp, $message');
            // Navigator.of(context).pop();
            EasyLoading.dismiss();
            registerController.toOtpVerif = false.obs;
            registerController.toOtp = true.obs;
            registerController.methodVerifChose = methodChose.obs;
            registerController.update();
            countDownController.countDown(
                iplOrEmail: (controllerIpl.text.isEmpty)
                    ? controllerUsername.text
                    : controllerIpl.text);
            // print('${registerController.toOtp.value}');
            // setState(() {});
          } else if (message == 'format email wrong') {
            // format email wrong
            // print('email tidak ada atau ada kesalahan penulisan');
            // buildShowDialogAnimation('email format does not match', 'OKE',
            //     'assets/animation/error-animation.json', 15.0);
            EasyLoading.showError(
              'email tidak ada atau ada kesalahan penulisan',
              dismissOnTap: true,
            );
          } else {
            // buildShowDialogAnimation(
            //     'Email otp is in error, please use another option',
            //     'OK',
            //     'assets/animation/error-animation.json',
            //     2.0.h);
            EasyLoading.showError(
              'Email OTP error, tolong gunakan pilihan lain',
              dismissOnTap: true,
            );
          }
        });
      });
    });
  }

  /// method yang digunakan untuk mengirim otp whatsapp
  void whatsappServices(String email, String noTelp, String methodChose) {
    SendOtpServices.sendOtpWhatsapp(email: email, noTelp: noTelp)
        .then((message) {
      if (message == 'success') {
        registerController.toOtpVerif = false.obs;
        registerController.toOtp = true.obs;
        registerController.methodVerifChose = methodChose.obs;
        print('${registerController.toOtp.value}');
        // setState(() {});
      } else if (message == 'format email wrong') {
        // format email wrong
        print('email tidak ada atau ada kesalahan penulisan');
      } else {
        print('$message');
      }
    });
  }

  Widget cardMethodVerification(
      {String icon,
      String title,
      String subtitle,
      String methodChose,
      String email,
      String noTelp}) {
    return GestureDetector(
      onTap: () async {
        print('on tap');
        if (methodChose.isCaseInsensitiveContainsAny('EMAIL')) {
          emailServices(email, noTelp, methodChose);
          // countDownController.count = 60.obs;
        } else if (methodChose.isCaseInsensitiveContainsAny('WHATSAPP')) {
          // buildShowDialogAnimation(
          //     '', '', 'assets/animation/loading-plane.json', 100);
          EasyLoading.show(status: 'loading');
          String message = await SendOtpServices.sendOtpWhatsapp(
              email: email, noTelp: noTelp);

          // Navigator.of(context).pop();
          if (message == 'success') {
            EasyLoading.dismiss();
            if (!registerController.toOtpVerif.value) {
              registerController.toOtpVerif = false.obs;
              registerController.toOtp = true.obs;
              registerController.methodVerifChose = methodChose.obs;
              countDownController.countDown(
                  iplOrEmail: (controllerIpl.text.isEmpty)
                      ? controllerUsername.text
                      : controllerIpl.text);
              // registerController.update();
              registerController.update();
              // setState(() {});
              final logger = Logger();
              logger.d(registerController.toOtp.value);
              logger.i(message);
            } else {
              registerController.toOtpVerif = false.obs;
              registerController.toOtp = true.obs;
              registerController.methodVerifChose = methodChose.obs;
              countDownController.countDown(
                  iplOrEmail: (controllerIpl.text.isEmpty)
                      ? controllerUsername.text
                      : controllerIpl.text);
              registerController.update();
            }
          } else if (message == 'wa number not found') {
            buildShowDialogAnimation(
                'Whatsapp number not found, please use another option',
                'OK',
                'assets/animation/error-animation.json',
                2.0.h);
          } else {
            buildShowDialogAnimation(
                'Whatsapp otp is in error, please use another option',
                'OK',
                'assets/animation/error-animation.json',
                2.0.h);
            print('$message');
          }
        }
      },
      child: SizedBox(
        width: 294.w,
        child: Card(
          elevation: 2,
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: 12.h,
              horizontal: 12.w,
            ),
            child: Row(
              children: [
                SvgPicture.asset('$icon'),
                SizedBox(
                  width: 11.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$title',
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    Text(
                      '$subtitle',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future userLogin() async {
    String url = '${ServerApp.url}src/login/login.php';
    var message, response;

    // firebase init
    // FirebaseMessaging messaging = FirebaseMessaging.instance;
    // String userToken = await messaging.getToken();
    // ! SAMPLE USER TOKEN FIREBASE PERLU DIPERBAIKI
    String userToken = "asdjasjdhbkj1234";

    // cek device info
    var deviceInfoPlugin = DeviceInfoPlugin();
    var deviceName;
    // var deviceVersion;
    var identifier;

    // Dio dio = Dio();

    // dio.interceptors.add(RetryOnConnectionChangeInterceptor(
    //   requestRetrier: DioConnectivityRequestRetrier(
    //     dio: dio,
    //     connectivity: Connectivity(),
    //   ),
    // ));

    final logger = Logger();
    logger.w('s');

    try {
      if (io.Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        // deviceVersion = build.version.toString();
        identifier = build.id; //UUID for Android
      } else if (io.Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        // deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor; //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }

    var data = {
      'usernameOrIpl': controllerUsername.text,
      'password': controllerPassword.text,
      'token': userToken,
      'device_name': deviceName,
      'device_identifier': identifier
    };

    if (_formKeyLogin.currentState.validate()) {
      try {
        // buildShowDialogAnimation(
        //     '', '', 'assets/animation/loading-plane.json', 100.h);
        EasyLoading.show(status: 'loading');

        // response = await http.post(url, body: json.encode(data));
        response = await http.post(Uri.parse(url), body: json.encode(data));

        if (response.statusCode >= 400) {
          EasyLoading.showError('Server error, tolong hubungin admin',
              dismissOnTap: true);
          // buildShowDialogAnimation('Error During login', 'OKE',
          //     'assets/animation/error-animation.json', 15.0);
        }

        print(response.body);
        if (response.body.isNotEmpty) {
          message = jsonDecode(response.body);
          if (message != 'login failed') {
            EasyLoading.dismiss();
            if (message['active_user'] == true) {
              // Navigator.of(context).pop();
              EasyLoading.dismiss();
              await buildShowDialogAnimation(
                  'kami mendeteksi adanya login diperangkat baru, login diperangkat lain akan otomatis keluar',
                  'OKE',
                  'assets/animation/warning-circle-animation.json',
                  15.0);
            }

            // await UserSecureStorage.setIdUser(message['id_user']);
            // await UserSecureStorage.setStatusLogin(message['status']);
            // String idUser = await UserSecureStorage.getIdUser();
            // if (idUser.isNotEmpty) {
            idUser = message['id_user'];
            status = message['status'];
            // Navigator.of(context).pop();
            loginController.loginCitizen();
            // Get.offAll(SplashView());
            registerController.toOtpVerif = true.obs;
            registerController.fromLogin = true.obs;
            controllerEmail.text = message['email'];
            controllerNoTelp.text = message['no_telp'];
            registerController.update();
            // }
          } else if (message == 'login failed') {
            String urlKontraktor =
                '${ServerApp.url}src/login/login_cordinator/login_cordinator.php';
            var dataKordinator = {
              'username': controllerUsername.text,
              'password': controllerPassword.text
            };
            response = await http.post(Uri.parse(urlKontraktor),
                body: json.encode(dataKordinator));
            message = jsonDecode(response.body);

            // jika response bukan login cordinator failed, artinya login cordinator berhasil
            if (message != 'login_cordinator_failed') {
              await UserSecureStorage.setIdUser(
                  message['id_estate_cordinator']);
              await UserSecureStorage.setStatusLogin(message['status']);
              print(message['status']);
              String idUser = await UserSecureStorage.getIdUser();
              if (idUser.isNotEmpty) {
                // ambil token fcm cordinator, dan simpan ke database
                // FirebaseMessaging messaging = FirebaseMessaging();
                // messaging.getToken().then((token) {
                //   saveToken(username: controllerUsername.text, token: token);
                // });
                loginController.loginCordinator();
                Get.offAll(SplashView());
              }
            }

            /**
              * jika status response login cordinator failed
              * akses login ke kontraktor
              */
            else {
              var dataKordinator = {
                'username': controllerUsername.text,
                'password': controllerPassword.text
              };

              http.Response response = await http.post(
                  Uri.parse(
                      '${ServerApp.url}src/login/login_kontraktor/login_kontraktor.php'),
                  body: jsonEncode(dataKordinator));
              /**
               * jika response status code diatas 200, berarti tidak ada kesalahan dalam mengirim request
               * setelah itu cek response apakah login succes atau tidak
               */
              if (response.statusCode >= 200 && response.statusCode <= 399) {
                var message = jsonDecode(response.body);

                // jika login gagal / username atau password salah
                if (message == 'login_kontraktor_failed') {
                  Navigator.of(context).pop();
                  // buildShowDialogAnimation('IPL number / email / passwod wrong',
                  //     'OKE', 'assets/animation/error-animation.json', 15.0);
                  setState(() {
                    passwordWrong = true;
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                }
                // jika login berhasil
                else {
                  await UserSecureStorage.setIdUser(message['id_contractor']);
                  await UserSecureStorage.setStatusLogin(message['status']);

                  String idUser = await UserSecureStorage.getIdUser();
                  if (idUser.isNotEmpty) {
                    print('login kontraktor');
                    Navigator.of(context).pop();
                    loginController.loginContractor();
                    Get.offAll(SplashView());
                  }
                }
              } else {
                Navigator.of(context).pop();
                buildShowDialogAnimation('Http Response Error', 'OKE',
                    'assets/animation/error-animation.json', 15.0);
              }
            }
          } else {
            Navigator.of(context).pop();
            buildShowDialogAnimation('Nomor IPL atau email salah', 'OKE',
                'assets/animation/error-animation.json', 15.0);
          }
        } else {
          Navigator.of(context).pop();
          buildShowDialogAnimation('Http Response Error', 'OKE',
              'assets/animation/error-animation.json', 15.0);
        }
      } on io.SocketException {
        buildShowDialogAnimation('Tidak ada internet', 'OKE',
            'assets/animation/error-animation.json', 15.0);
      } on io.HttpException {
        buildShowDialogAnimation('Server sedang error', 'OKE',
            'assets/animation/error-animation.json', 15.0);
      }
    }
  }

  Future saveToken({String username, String token}) async {
    String url = '${ServerApp.url}src/login/login_cordinator/save_token.php';
    var body = {'username': username, 'token': token};

    try {
      http.Response response =
          await http.post(Uri.parse(url), body: jsonEncode(body));
      if (response.statusCode >= 200 && response.statusCode <= 399) {
        String message = jsonDecode(response.body);
        return message;
      } else {
        buildShowDialogAnimation('Response Error', 'OKE',
            'assets/animation/error-animation.json', 15.0);
      }
    } on io.SocketException {
      buildShowDialogAnimation(
          'No Internet', 'OKE', 'assets/animation/error-animation.json', 15.0);
    } on io.HttpException {
      buildShowDialogAnimation(
          'Server Error', 'OKE', 'assets/animation/error-animation.json', 15.0);
    }
  }

  Future userRegister(String noIpl, String email, String noTelp) async {
    // buildShowDialogAnimation(
    //     '', '', 'assets/animation/loading-plane.json', 2.0.h);
    EasyLoading.show(status: 'loading', dismissOnTap: false);

    String result = await checkNumberPhone(noTelp);
    final logger = Logger();
    logger.w(result);

    if (result == 'FOUND') {
      String url = '${ServerApp.url}src/login/register.php';
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields['no_ipl'] = noIpl;
      request.fields['email'] = email;
      request.fields['no_telp'] = noTelp;
      request.send().then((value) {
        http.Response.fromStream(value).then((value) async {
          String message = json.decode(value.body);
          if (message != null && message.isNotEmpty) {
            if (message == 'success') {
              // Navigator.of(context).pop();
              EasyLoading.dismiss();
              final storage = new FlutterSecureStorage();
              // FlutterSecureStorage().write(key: 'successotp', value: 'false');
              // FlutterSecureStorage().write(key: 'noipl', value: noIpl);
              // FlutterSecureStorage().write(key: 'email', value: email);
              // FlutterSecureStorage().write(key: 'notelp', value: noTelp);
              await storage.write(key: 'successotp', value: 'false');
              await storage.write(key: 'noipl', value: noIpl);
              await storage.write(key: 'email', value: email);
              await storage.write(key: 'notelp', value: noTelp);
              registerController.toOtpVerif = true.obs;
              setState(() {});
              // buat password
            } else if (message == 'no_ipl tidak ada') {
              // warning ipl tidak terdaftar disiter
              // Navigator.of(context).pop();
              EasyLoading.dismiss();
              EasyLoading.showError(
                'Nomor IPL tidak ada',
                dismissOnTap: true,
              );
              // buildShowDialogAnimation('Nomor IPL tidak ada', 'OKE',
              //     'assets/animation/error-animation.json', 2.0.h);
            } else if (message == 'ipl exist') {
              // ipl sudah pernah register disistem
              // Navigator.of(context).pop();
              EasyLoading.dismiss();
              EasyLoading.showError(
                'Nomor IPL ini sudah digunakan',
                dismissOnTap: true,
              );
              // buildShowDialogAnimation('Nomor IPL ini sudah digunakan', 'OKE',
              //     'assets/animation/error-animation.json', 2.0.h);
            } else if (message == 'email exist') {
              // Navigator.of(context).pop();
              EasyLoading.dismiss();
              EasyLoading.showError(
                'Email ini sudah digunakan',
                dismissOnTap: true,
              );
              // buildShowDialogAnimation('Email ini sudah digunakan', 'OKE',
              //     'assets/animation/error-animation.json', 2.0.h);
            } else if (message == 'phone number exist') {
              // Navigator.of(context).pop();
              EasyLoading.dismiss();
              EasyLoading.showError(
                'Nomor telpon ini sudah digunakan',
                dismissOnTap: true,
              );
              // buildShowDialogAnimation('Nomor telpon ini sudah digunakan',
              //     'OKE', 'assets/animation/error-animation.json', 2.0.h);
            } else {
              // Navigator.of(context).pop();
              EasyLoading.dismiss();
              EasyLoading.showError(
                'Ada proses yang salah $message, hubungi Admin',
                dismissOnTap: true,
              );
              // buildShowDialogAnimation(
              //     'Ada proses yang salah ${message}, Hubungi admin',
              //     'OKE',
              //     'assets/animation/error-animation.json',
              //     2.0.h);
            }
          }
        });
      });
    } else {
      Navigator.of(context).pop();
      buildShowDialogAnimation('Nomor telpon tidak benar', 'OKE',
          'assets/animation/error-animation.json', 2.0.h);
    }
  }

  Future buildShowDialogAnimation(
      String title, String btnMessage, String urlAsset, double size) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              title,
              style: TextStyle(fontSize: 12.0.sp),
            ),
            insetPadding: EdgeInsets.all(10.0.h),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: LottieBuilder.asset(
              urlAsset,
              height: size.h,
              width: size.w,
              fit: BoxFit.contain,
            ),
            actions: <Widget>[
              TextButton(
                child: Text(btnMessage),
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pop();
                  });
                },
              ),
            ],
          );
        });
  }

  Map<String, String> headers = {};
}
