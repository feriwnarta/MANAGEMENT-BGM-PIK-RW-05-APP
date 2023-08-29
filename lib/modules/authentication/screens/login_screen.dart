import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'package:aplikasi_rw/controller/register_controller.dart';
import 'package:aplikasi_rw/controller/resend_otp_countdown_controller.dart';
import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/modules/authentication/controllers/access_controller.dart';
import 'package:aplikasi_rw/modules/authentication/controllers/auth_controller.dart';
import 'package:aplikasi_rw/modules/authentication/services/check_access_otp.dart';
import 'package:aplikasi_rw/modules/authentication/validate/validate_email_and_password.dart';
import 'package:aplikasi_rw/modules/authentication/widgets/header_logo.dart';
import 'package:aplikasi_rw/modules/authentication/widgets/method_verification.dart';
import 'package:aplikasi_rw/modules/authentication/widgets/otp.dart';
import 'package:aplikasi_rw/modules/authentication/widgets/register_login_form.dart';
import 'package:aplikasi_rw/routes/app_routes.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/services/send_otp_services.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:async/async.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
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

//ignore: must_be_immutable
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
  TextEditingController controllerIpl;

  // UserLoadingBloc bloc;

  String otpKey;
  bool isLogin = true;
  final _scaffoldkey = new GlobalKey<ScaffoldState>();
  RegisterController registerController;
  UserLoginController loginController;
  CountDownController countDownController;
  AuthController authController;
  AccessController accessController;

  final logger = Logger();

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
    registerController = Get.put(RegisterController(), permanent: true);
    loginController = Get.put(UserLoginController());
    countDownController = Get.put(CountDownController());
    authController = Get.put(AuthController(), permanent: false);
    accessController = Get.put(AccessController(), permanent: true);

    if (email != null && noTelp != null) {
      if (email.isNotEmpty && noTelp.isNotEmpty) {
        registerController.otpWhenExit = true.obs;
      }
    } else {
      controllerIpl = TextEditingController();
    }

    final storage = FlutterSecureStorage();
    storage.read(key: 'successotp').then((value) {});
  }

  @override
  void dispose() {
    controllerIpl.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));
    return Scaffold(
      key: _scaffoldkey,
      body: Stack(
        children: [
          HeaderLogo(),
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
                          return Otp(
                            controllerIpl: controllerIpl,
                            email: registerController.email.value,
                            errorController: errorController,
                            noTelp: registerController.noTelp.value,
                            otpKey: otpKey,
                            resendOtp: resendOtp,
                            validateOtp: validateOtp,
                          );
                        } else if (registerController.toOtpVerif.value) {
                          return MethodVerification(
                            email: controller.email.value,
                            noTelp: controller.noTelp.value,
                            cardMethodVerification: cardMethodVerification,
                          );
                        } else if (registerController.toResetPassword.value) {
                          if (authController.controllerUsername.text.isNotEmpty &&
                              registerController.iplOrEmailValid.value ==
                                  false &&
                              isIplSuccess == true) {
                            return MethodVerification(
                              email: email,
                              noTelp: noTelp,
                              cardMethodVerification: cardMethodVerification,
                            );
                          } else {
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: SizeConfig.height(32),
                                  ),
                                  Image(
                                    image: AssetImage('assets/img/logo_rw.png'),
                                    width: SizeConfig.width(80),
                                    height: SizeConfig.height(94),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.height(36),
                                  ),
                                  Form(
                                    // key: _formKeyLogin,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: SizeConfig.width(280),
                                          child: Text(
                                            '* Enter your IPL number or email, the system will automatically detect it',
                                            style: TextStyle(
                                                fontSize: SizeConfig.text(11),
                                                color: Colors.grey),
                                          ),
                                        ),
                                        SizedBox(height: SizeConfig.height(5)),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: SizeConfig.width(16)),
                                          child: TextFormField(
                                            controller: authController
                                                .controllerUsername,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            decoration: InputDecoration(
                                              errorText: !registerController
                                                      .iplOrEmailValid.value
                                                  ? null
                                                  : 'Your email/ipl number is incorrect',
                                              icon: SvgPicture.asset(
                                                'assets/img/image-svg/user-login.svg',
                                                width: SizeConfig.width(20),
                                                height: SizeConfig.height(
                                                  20,
                                                ),
                                              ),
                                              hintText:
                                                  'Enter your email / IPL number',
                                              hintStyle: TextStyle(
                                                  fontSize:
                                                      SizeConfig.text(14)),
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
                                                          width:
                                                              SizeConfig.width(
                                                                  20),
                                                          height:
                                                              SizeConfig.height(
                                                            20,
                                                          ),
                                                        )
                                                      : null
                                                  : SvgPicture.asset(
                                                      'assets/img/image-svg/close.svg',
                                                      width:
                                                          SizeConfig.width(20),
                                                      height: SizeConfig.height(
                                                        20,
                                                      ),
                                                    ),
                                              suffixIconConstraints:
                                                  BoxConstraints(
                                                      minHeight:
                                                          SizeConfig.height(5),
                                                      minWidth:
                                                          SizeConfig.width(5)),
                                            ),
                                            onChanged: (value) async {
                                              cancelableOperation =
                                                  CancelableOperation
                                                      .fromFuture(
                                                          Future.delayed(
                                                              Duration(
                                                                  seconds: 1),
                                                              () async {
                                                if (authController
                                                    .controllerUsername
                                                    .text
                                                    .isNotEmpty) {
                                                  await checkEmailIpl(
                                                      authController
                                                          .controllerUsername
                                                          .text);
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
                                        SizedBox(height: SizeConfig.height(32)),
                                        SizedBox(
                                          height: SizeConfig.height(66),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]);
                          }
                        } else if (registerController.otpWhenExit.value) {
                          return MethodVerification(
                            email: email,
                            noTelp: noTelp,
                            cardMethodVerification: cardMethodVerification,
                          );
                        } else {
                          return RegisterLoginForm(
                            authController: authController,
                            cancelableOperation: cancelableOperation,
                            checkEmailIpl: checkEmailIpl,
                            controllerIpl: controllerIpl,
                            email: email,
                            formKeyLogin: _formKeyLogin,
                            formKeyRegister: _formKeyRegister,
                            isLogin: isLogin,
                            isObscure: _isObscure,
                            noTelp: noTelp,
                            passwordWrong: passwordWrong,
                            registerController: registerController,
                            userLogin: userLogin,
                            userRegister: userRegister,
                          );
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

  Column createPasswordSucces() {
    return Column(
      children: [
        SizedBox(height: SizeConfig.height(56)),
        SvgPicture.asset('assets/img/image-svg/otp-succes.svg'),
        SizedBox(
          height: SizeConfig.height(16),
        ),
        SizedBox(
          width: SizeConfig.width(190),
          child: Text('Sandi berhasil dibuat',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: SizeConfig.text(18), fontWeight: FontWeight.w700)),
        ),
        SizedBox(height: SizeConfig.height(176)),
        SizedBox(
          height: SizeConfig.height(40),
          width: SizeConfig.width(293),
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

              final logger = Logger();
              logger.i(registerController.isWrong.value);
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
                style: TextStyle(
                    color: Colors.white, fontSize: SizeConfig.text(14))),
          ),
        ),
        SizedBox(height: SizeConfig.height(72))
      ],
    );
  }

  Column createPassword() {
    return Column(
      children: [
        SizedBox(height: SizeConfig.height(56)),
        SvgPicture.asset('assets/img/image-svg/otp-key.svg'),
        SizedBox(height: SizeConfig.height(16)),
        Text(
          'Buat Kata Sandi',
          style: TextStyle(
              fontSize: SizeConfig.text(18), fontWeight: FontWeight.w700),
        ),
        SizedBox(height: SizeConfig.height(8)),
        Text(
          'kata sandi yang kuat akan menghindari pencurian akun',
          style: TextStyle(fontSize: SizeConfig.text(12), color: Colors.grey),
        ),
        SizedBox(height: SizeConfig.height(32)),
        Form(
          key: _formKeyCreatePassword,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.width(16)),
            child: TextFormField(
              keyboardType: TextInputType.visiblePassword,
              controller: authController.passwordController,
              obscureText: _isObscure2,
              decoration: InputDecoration(
                  icon: SvgPicture.asset(
                    'assets/img/image-svg/key.svg',
                    height: SizeConfig.height(20),
                    width: SizeConfig.width(20),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon((_isObscure2)
                        ? Icons.visibility_off_outlined
                        : Icons.visibility),
                    iconSize: SizeConfig.image(20),
                    onPressed: () {
                      setState(() {
                        _isObscure2 = !_isObscure2;
                      });
                    },
                  ),
                  suffixIconConstraints: BoxConstraints.tightFor(
                    width: SizeConfig.width(24),
                  ),
                  errorMaxLines: 2,
                  hintText: 'Masukan kata sandi',
                  hintStyle: TextStyle(fontSize: SizeConfig.text(14)),
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
          height: SizeConfig.height(14),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.width(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kata sandi Anda harus :',
                style: TextStyle(
                    color: Colors.grey, fontSize: SizeConfig.text(10)),
              ),
              Text(
                '* panjangnya 8 hingga 72 karakter',
                style: TextStyle(
                    color: Colors.grey, fontSize: SizeConfig.text(10)),
              ),
              Text(
                '* tidak mengandung email nama Anda',
                style: TextStyle(
                    color: Colors.grey, fontSize: SizeConfig.text(10)),
              ),
              Text(
                '* tidak umum digunakan dan mudah ditebak',
                style: TextStyle(
                    color: Colors.grey, fontSize: SizeConfig.text(10)),
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
                    backgroundColor: Colors.lightBlue[400],
                  ),
                  onPressed: () {
                    if (_formKeyCreatePassword.currentState.validate()) {
                      insertPassword(
                          password: authController.passwordController.text);
                    }
                  },
                  child: Text('Buat Kata Sandi',
                      style: TextStyle(
                          color: Colors.white, fontSize: SizeConfig.text(14))),
                ),
              ),
              SizedBox(
                height: SizeConfig.height(72),
              )
            ],
          ),
        )
      ],
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
      data = {
        'noIplOrEmail': authController.controllerUsername.text,
        'status': status
      };
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
          final logger = Logger();
          logger.i('resend otp wa clicked');
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
      data = {
        'noIplOrEmail': authController.controllerUsername.text,
        'password': password
      };
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
          Get.delete<AuthController>();
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
      data = {
        'iplOrEmail': authController.controllerUsername.text,
        'otp': otpKey
      };
    } else {
      data = {'iplOrEmail': controllerIpl.text, 'otp': otpKey};
    }

    final logger = Logger();
    logger.d(data);
    // logger.d(otpKey);
    // logger.d(authController.controllerUsername.text);

    try {
      EasyLoading.show(status: 'loading');
      http.Response response =
          await http.post(Uri.parse(url), body: json.encode(data));

      logger.d(response.body);
      if (response.body != null && response.body.isNotEmpty) {
        if (response.body.contains('OKE')) {
          // jika otp dari login berhasil
          logger.e(response.body);
          if (registerController.fromLogin.value) {
            var rs = jsonDecode(response.body);
            await UserSecureStorage.setIdUser(this.idUser);
            await UserSecureStorage.setStatusLogin(this.status);
            await UserSecureStorage.setKeyValue(
              key: 'noIpl',
              value: rs['no_ipl'],
            );
            String idUser = await UserSecureStorage.getIdUser();
            // logger.w(status);
            // countDownController.reset();
            countDownController.reset();
            if (idUser.isNotEmpty) {
              // Navigator.of(context).pop();
              EasyLoading.dismiss();
              authController.dispose();
              registerController.resetController();
              registerController.update();
              Get.offAllNamed(RouteName.home);
              Get.delete<AuthController>();
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
    EasyLoading.show(status: 'loading');
    String message =
        await SendOtpServices.sendOtpGmail(email: email, noTelp: noTelp);
    if (message == 'success') {
      logger.e('succes kirim otp gmail $email, $noTelp, $message');
      // Navigator.of(context).pop();
      EasyLoading.dismiss();
      registerController.toOtpVerif = false.obs;
      registerController.toOtp = true.obs;
      registerController.methodVerifChose = methodChose.obs;
      registerController.email.value = email;
      registerController.update();
      countDownController.countDown(
          iplOrEmail: (controllerIpl.text.isEmpty)
              ? authController.controllerUsername.text
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
                      ? authController.controllerUsername.text
                      : controllerIpl.text);
              // registerController.update();
              registerController.update();
              // setState(() {});
              registerController.email.value = email;
              registerController.noTelp.value = noTelp;
            } else {
              registerController.toOtpVerif = false.obs;
              registerController.toOtp = true.obs;
              registerController.methodVerifChose = methodChose.obs;
              countDownController.countDown(
                  iplOrEmail: (controllerIpl.text.isEmpty)
                      ? authController.controllerUsername.text
                      : controllerIpl.text);
              registerController.update();
            }
          } else if (message == 'wa number not found') {
            EasyLoading.showError(
                'Nomor whatsapp tidak ditemukan, tolong gunakan pilihan otp lain',
                dismissOnTap: true);
          } else {
            EasyLoading.showError(
              'Whatsapp OTP sedang error, tolong gunakan pilihan otp lain',
              dismissOnTap: true,
            );
            print('$message');
          }
        }
      },
      child: SizedBox(
        width: SizeConfig.width(294),
        child: Card(
          elevation: 2,
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: SizeConfig.height(12),
              horizontal: SizeConfig.width(12),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  '$icon',
                  height: SizeConfig.height(20),
                  width: SizeConfig.width(20),
                ),
                SizedBox(
                  width: SizeConfig.width(11),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$title',
                      style: TextStyle(fontSize: SizeConfig.text(12)),
                    ),
                    Text(
                      '$subtitle',
                      style: TextStyle(
                        fontSize: SizeConfig.text(10),
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
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String userToken = await messaging.getToken();

    // String userToken = "asdjasjdhbkj1234";

    // cek device info
    var deviceInfoPlugin = DeviceInfoPlugin();
    var deviceName;
    // var deviceVersion;
    var identifier;

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
      'usernameOrIpl': authController.controllerUsername.text,
      'password': authController.controllerPassword.text,
      'token': userToken,
      'device_name': deviceName,
      'device_identifier': identifier
    };

    if (_formKeyLogin.currentState.validate()) {
      try {
        EasyLoading.show(status: 'loading');

        response = await http.post(Uri.parse(url), body: json.encode(data));

        final logger = Logger();
        logger.i(data);

        if (response.statusCode >= 400) {
          EasyLoading.showError(
            'Server error, tolong hubungin admin',
            dismissOnTap: true,
          );
        }

        if (response.body.isNotEmpty) {
          message = jsonDecode(response.body);
          if (message != 'login failed') {
            EasyLoading.dismiss();
            if (message['active_user'] == true) {
              EasyLoading.dismiss();
            }

            var result = await CheckAccessOtp.checkAccess(
                username: authController.controllerUsername.text);

            if (result['otp'] == '0') {
              await UserSecureStorage.setIdUser(message['id_user']);
              await UserSecureStorage.setStatusLogin(message['status']);
              await UserSecureStorage.setKeyValue(
                key: 'noIpl',
                value: authController.controllerUsername.text,
              );
              logger.w(message['status']);
              String idUser = await UserSecureStorage.getIdUser();

              // countDownController.reset();
              // countDownController.reset();
              if (idUser.isNotEmpty) {
                // Navigator.of(context).pop();
                EasyLoading.dismiss();
                // authController.dispose();
                registerController.resetController();
                registerController.update();
                Get.offAllNamed(RouteName.home);
                Get.delete<AuthController>();
              }
              loginController.loginCitizen();
            } else {
              idUser = message['id_user'];
              status = message['status'];

              logger.w(idUser);
              // Navigator.of(context).pop();
              loginController.loginCitizen();
              // Get.offAll(SplashView());
              registerController.toOtpVerif = true.obs;
              registerController.fromLogin = true.obs;

              registerController.email.value = message['email'];
              registerController.noTelp.value = message['no_telp'];
              authController.controllerEmail.text = message['email'];
              authController.controllerNoTelp.text = message['no_telp'];

              logger.d(registerController.email.value);
              logger.d(registerController.noTelp.value);

              registerController.update();
            }

            // }
          } else if (message == 'login failed') {
            EasyLoading.dismiss();
            EasyLoading.showError('Password salah');
          } else {
            // Navigator.of(context).pop();
            print('password salah');
            EasyLoading.dismiss();
          }
        } else {
          EasyLoading.dismiss();
          EasyLoading.showError('Response error, silahkan hubungi admin',
              dismissOnTap: true);
        }
      } on io.SocketException {
        EasyLoading.showError('Tidak ada internet', dismissOnTap: true);
      } on io.HttpException {
        EasyLoading.showError('Server error, tolong hubungin admin',
            dismissOnTap: true);
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
  }

  Future buildShowDialogAnimation(
      String title, String btnMessage, String urlAsset, double size) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            width: 20.w,
            height: 20.h,
            child: AlertDialog(
              title: Text(
                title,
                style: TextStyle(fontSize: 12.0.sp),
              ),
              insetPadding: EdgeInsets.all(10.0.h),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: LottieBuilder.asset(
                urlAsset,
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
            ),
          );
        });
  }

  Map<String, String> headers = {};
}
