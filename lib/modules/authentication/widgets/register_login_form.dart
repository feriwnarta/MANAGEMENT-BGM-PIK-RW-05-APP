import 'package:aplikasi_rw/controller/register_controller.dart';
import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/modules/authentication/controllers/auth_controller.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../validate/validate_email_and_password.dart';

//ignore: must_be_immutable
class RegisterLoginForm extends StatefulWidget {
  bool isLogin;
  GlobalKey<FormState> formKeyLogin, formKeyRegister;
  AuthController authController;
  TextEditingController controllerIpl;
  RegisterController registerController;
  CancelableOperation cancelableOperation;
  Function checkEmailIpl;
  bool isObscure;
  bool passwordWrong;
  Function userRegister, userLogin;
  String email, noTelp;

  RegisterLoginForm(
      {this.formKeyLogin,
      this.formKeyRegister,
      this.isObscure,
      this.authController,
      this.cancelableOperation,
      this.checkEmailIpl,
      this.controllerIpl,
      this.email,
      this.isLogin,
      this.noTelp,
      this.passwordWrong,
      this.registerController,
      this.userLogin,
      this.userRegister});

  @override
  State<RegisterLoginForm> createState() => _RegisterLoginFormState(
      authController: authController,
      cancelableOperation: cancelableOperation,
      checkEmailIpl: checkEmailIpl,
      controllerIpl: controllerIpl,
      email: email,
      formKeyLogin: formKeyLogin,
      formKeyRegister: formKeyRegister,
      isLogin: isLogin,
      isObscure: isObscure,
      noTelp: noTelp,
      passwordWrong: passwordWrong,
      registerController: registerController,
      userLogin: userLogin,
      userRegister: userRegister);
}

class _RegisterLoginFormState extends State<RegisterLoginForm> {
  _RegisterLoginFormState(
      {this.formKeyLogin,
      this.formKeyRegister,
      this.isObscure,
      this.authController,
      this.cancelableOperation,
      this.checkEmailIpl,
      this.controllerIpl,
      this.email,
      this.isLogin,
      this.noTelp,
      this.passwordWrong,
      this.registerController,
      this.userLogin,
      this.userRegister});

  bool isLogin;
  GlobalKey<FormState> formKeyLogin, formKeyRegister;
  AuthController authController;
  TextEditingController controllerIpl;
  RegisterController registerController;
  CancelableOperation cancelableOperation;
  Function checkEmailIpl;
  bool isObscure;
  bool passwordWrong;
  Function userRegister, userLogin;
  String email, noTelp;
  UserLoginController loginController = Get.put(UserLoginController());
  RegisterController userRegisterController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
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
        key: formKeyLogin,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: TextFormField(
                controller: authController.controllerUsername,
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
                            authController.controllerUsername.text = '';
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
                    if (authController.controllerUsername.text.isNotEmpty) {
                      await checkEmailIpl(
                          authController.controllerUsername.text);
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
                  Obx(
                    () => TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: isObscure,
                      controller: authController.controllerPassword,
                      decoration: InputDecoration(
                          icon:
                              SvgPicture.asset('assets/img/image-svg/key.svg'),
                          suffixIcon: IconButton(
                            icon: Icon((isObscure)
                                ? Icons.visibility_off_outlined
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                isObscure = !isObscure;
                              });
                            },
                          ),
                          errorText:
                              (loginController.passwordWrong.value == 'true')
                                  ? 'Kata sandi anda salah !'
                                  : null,
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
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text('Lupa kata sandi ?',
                            style: TextStyle(fontSize: 14.sp)),
                        onPressed: () {
                          registerController.toResetPassword.value = true;
                          registerController.email.value =
                              authController.controllerEmail.text;
                          registerController.noTelp.value =
                              authController.controllerNoTelp.text;
                          registerController.update();
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
                  if (formKeyLogin.currentState.validate()) {
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

  Form buildFormRegister() {
    return Form(
      key: formKeyRegister,
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
                  controller: authController.controllerEmail,
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
                  controller: authController.controllerNoTelp,
                  decoration: InputDecoration(
                      icon: SvgPicture.asset(
                          'assets/img/image-svg/handphone.svg'),
                      hintText: 'Masukan nomor telpon',
                      hintStyle: TextStyle(fontSize: 14.sp),
                      border: UnderlineInputBorder()),
                  validator: (value) {
                    print('${ValidationForm.isValidPhone(value)}');
                    if (value.isEmpty) {
                      return 'Nomor telpon tidak boleh kosong';
                    } else {
                      if (ValidationForm.isValidPhone(value)) {
                        return null;
                      } else {
                        return 'Nomor yang anda masukan tidak valid';
                      }
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
                if (formKeyRegister.currentState.validate()) {
                  userRegister(
                      controllerIpl.text,
                      authController.controllerEmail.text,
                      authController.controllerNoTelp.text);
                  setState(() {
                    email = authController.controllerEmail.text;
                    noTelp = authController.controllerNoTelp.text;
                  });
                  registerController.email.value =
                      authController.controllerEmail.text;
                  registerController.noTelp.value =
                      authController.controllerNoTelp.text;
                }
              },
            ),
          ),
          SizedBox(height: 40.h)
        ],
      ),
    );
  }
}
