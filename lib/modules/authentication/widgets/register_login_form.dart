import 'package:aplikasi_rw/controller/register_controller.dart';
import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/modules/authentication/controllers/auth_controller.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

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

  AssetImage image = AssetImage('assets/img/logo_rw.png');

  @override
  void didChangeDependencies() {
    precacheImage(image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: SizeConfig.height(32),
        ),
        Image(
          image: image,
          width: SizeConfig.width(80),
          height: SizeConfig.width(94),
        ),
        SizedBox(
          height: SizeConfig.height(32),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: SizeConfig.height(40),
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
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.height(6),
                          horizontal: SizeConfig.width(16)),
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
                          fontSize: SizeConfig.text(14)),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      backgroundColor:
                          (!isLogin) ? Colors.lightBlue[400] : Colors.white,
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.height(6),
                          horizontal: SizeConfig.width(16)),
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
                            fontSize: SizeConfig.text(14))),
                  )
                ],
              ),
            ),
          ],
        ),
        // (formLoginOrRegister)
        SizedBox(height: SizeConfig.height(48)),
        (isLogin) ? buildFormLogin() : buildFormRegister(),
        SizedBox(height: SizeConfig.height(2))
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
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.width(16)),
              child: TextFormField(
                controller: authController.controllerUsername,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  errorText: !registerController.iplOrEmailValid.value
                      ? null
                      : 'Nomor email / ipl anda salah',
                  icon: SvgPicture.asset(
                    'assets/img/image-svg/user-login.svg',
                    height: SizeConfig.image(20),
                    width: SizeConfig.image(20),
                  ),
                  hintText: 'Masukan email / nomor IPL',
                  hintStyle: TextStyle(fontSize: SizeConfig.text(14)),
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
                              height: SizeConfig.height(20),
                              width: SizeConfig.width(20),
                            )
                          : null
                      : GestureDetector(
                          child: SvgPicture.asset(
                            'assets/img/image-svg/close.svg',
                            height: SizeConfig.height(20),
                            width: SizeConfig.width(20),
                          ),
                          onTap: () {
                            authController.controllerUsername.text = '';
                            registerController.iplOrEmailValid = false.obs;
                            registerController.iplOrEmailSucces = false.obs;
                            setState(() {});
                          },
                        ),
                  suffixIconConstraints: BoxConstraints(
                    minHeight: SizeConfig.height(5),
                    minWidth: SizeConfig.width(5),
                  ),
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
            SizedBox(height: SizeConfig.height(32)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.width(16)),
              child: Column(
                children: [
                  Obx(
                    () => TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: isObscure,
                      controller: authController.controllerPassword,
                      decoration: InputDecoration(
                          icon: SvgPicture.asset(
                            'assets/img/image-svg/key.svg',
                            height: SizeConfig.height(20),
                            width: SizeConfig.width(20),
                          ),
                          suffixIcon: IconButton(
                            splashRadius: 10,
                            padding: EdgeInsets.zero,
                            icon: Icon((isObscure)
                                ? Icons.visibility_off_outlined
                                : Icons.visibility),
                            iconSize: SizeConfig.image(20),
                            onPressed: () {
                              setState(() {
                                isObscure = !isObscure;
                              });
                            },
                          ),
                          suffixIconConstraints: BoxConstraints.tightFor(
                            width: SizeConfig.width(24),
                          ),
                          errorText:
                              (loginController.passwordWrong.value == 'true')
                                  ? 'Kata sandi anda salah !'
                                  : null,
                          hintText: 'Masukan kata sandi',
                          hintStyle: TextStyle(fontSize: SizeConfig.text(14)),
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
                  SizedBox(height: SizeConfig.height(8)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text('Lupa kata sandi ?',
                            style: TextStyle(fontSize: SizeConfig.text(14))),
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
            SizedBox(height: SizeConfig.height(32)),
            SizedBox(
              height: SizeConfig.height(40),
              width: SizeConfig.width(293),
              child: TextButton(
                child: Text(
                  'Masuk',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.text(16),
                  ),
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
                  }
                  // final logger = Logger();
                  // logger.w('test');
                },
              ),
            ),
            SizedBox(
              height: SizeConfig.height(66),
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
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.width(16)),
            child: TextFormField(
              controller: controllerIpl,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  icon: SvgPicture.asset(
                    'assets/img/image-svg/user-login.svg',
                    height: SizeConfig.width(20),
                    width: SizeConfig.height(20),
                  ),
                  hintText: 'Masukan nomor IPL',
                  hintStyle: TextStyle(fontSize: SizeConfig.text(14)),
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
          SizedBox(height: SizeConfig.height(32)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.width(16)),
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: authController.controllerEmail,
                  decoration: InputDecoration(
                      icon: SvgPicture.asset(
                        'assets/img/image-svg/email.svg',
                        width: SizeConfig.width(20),
                        height: SizeConfig.height(20),
                      ),
                      hintText: 'Masukan Email',
                      hintStyle: TextStyle(fontSize: SizeConfig.text(14)),
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
          SizedBox(height: SizeConfig.height(32)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.width(16)),
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: authController.controllerNoTelp,
                  decoration: InputDecoration(
                      icon: SvgPicture.asset(
                        'assets/img/image-svg/handphone.svg',
                        width: SizeConfig.width(20),
                        height: SizeConfig.height(20),
                      ),
                      hintText: 'Masukan nomor telpon',
                      hintStyle: TextStyle(fontSize: SizeConfig.text(14)),
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
          SizedBox(height: SizeConfig.height(42)),
          SizedBox(
            width: SizeConfig.width(293),
            height: SizeConfig.height(40),
            child: TextButton(
              child: Text(
                'Daftar',
                style: TextStyle(
                    color: Colors.white, fontSize: SizeConfig.text(11)),
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
          SizedBox(height: SizeConfig.height(40))
        ],
      ),
    );
  }
}
