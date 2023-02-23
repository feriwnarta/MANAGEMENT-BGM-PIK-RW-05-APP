import 'package:aplikasi_rw/modules/profiles/services/change_password_services.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/state_manager.dart';
import 'package:logger/logger.dart';

//ignore: must_be_immutable
class SecurityScreen extends StatelessWidget {
  SecurityScreen({Key key}) : super(key: key);

  RxBool isObsecureNew = true.obs;
  RxBool isObsecureNow = true.obs;
  RxBool isObsecureReNew = true.obs;

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();

  TextEditingController controllerCurrentPassword = TextEditingController();
  TextEditingController controllerNewPassword = TextEditingController();
  TextEditingController controllerReNewPassword = TextEditingController();

  RxBool passwordNotSame = false.obs;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));

    return Scaffold(
      appBar: AppBar(
        title: Text('Ganti Password'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: SizeConfig.width(16)),
            child: Column(
              children: [
                SizedBox(
                  height: SizeConfig.height(16),
                ),
                Text(
                  'Kata sandi Anda harus panjangnya 8 hingga 72 karakter, tidak mengandung email nama Anda, tidak umum digunakan dan mudah ditebak',
                  style: TextStyle(
                    fontSize: SizeConfig.text(12),
                  ),
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: SizeConfig.height(32),
                ),
                Obx(
                  () => Form(
                    key: _formKey1,
                    child: Column(
                      children: [
                        Form(
                          key: _formKey2,
                          child: SizedBox(
                            height: SizeConfig.height(24),
                            child: TextFormField(
                              controller: controllerCurrentPassword,
                              obscureText: isObsecureNow.value,
                              onChanged: (value) {
                                _formKey2.currentState.validate();
                              },
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  padding: EdgeInsets.zero,
                                  iconSize: SizeConfig.image(20),
                                  icon: (isObsecureNow.value)
                                      ? Icon(
                                          Icons.visibility_off_outlined,
                                        )
                                      : Icon(
                                          Icons.visibility,
                                        ),
                                  onPressed: () {
                                    isObsecureNow.value = !isObsecureNow.value;
                                  },
                                ),
                                icon: SvgPicture.asset(
                                  'assets/img/image-svg/key.svg',
                                  height: SizeConfig.height(20),
                                ),
                                hintText: 'Kata sandi sekarang',
                                hintStyle:
                                    TextStyle(fontSize: SizeConfig.text(14)),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'kata sandi tidak boleh kosong';
                                } else if (value.length < 8) {
                                  return 'kata sandi harus 8 karakter hingga 72 karakter';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.height(32),
                        ),
                        Form(
                          key: _formKey3,
                          child: SizedBox(
                            height: SizeConfig.height(24),
                            child: TextFormField(
                              controller: controllerNewPassword,
                              obscureText: isObsecureNew.value,
                              onChanged: (value) {
                                _formKey3.currentState.validate();
                              },
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  iconSize: SizeConfig.image(20),
                                  padding: EdgeInsets.zero,
                                  icon: (isObsecureNew.value)
                                      ? Icon(
                                          Icons.visibility_off_outlined,
                                        )
                                      : Icon(
                                          Icons.visibility,
                                        ),
                                  onPressed: () {
                                    isObsecureNew.value = !isObsecureNew.value;
                                  },
                                ),
                                icon: SvgPicture.asset(
                                  'assets/img/image-svg/key.svg',
                                  height: SizeConfig.height(20),
                                ),
                                hintText: 'Kata sandi baru',
                                hintStyle:
                                    TextStyle(fontSize: SizeConfig.text(14)),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'kata sandi tidak boleh kosong';
                                } else if (value.length < 8) {
                                  return 'kata sandi harus 8 karakter hingga 72 karakter';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.height(32),
                        ),
                        Form(
                          key: _formKey4,
                          child: SizedBox(
                            height: SizeConfig.height(24),
                            child: TextFormField(
                              controller: controllerReNewPassword,
                              obscureText: isObsecureReNew.value,
                              onChanged: (value) {
                                _formKey4.currentState.validate();
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'kata sandi tidak boleh kosong';
                                } else if (value !=
                                    controllerNewPassword.text) {
                                  return 'kata sandi tidak cocok';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                isDense: true,
                                isCollapsed: true,
                                suffixIcon: IconButton(
                                  padding: EdgeInsets.zero,
                                  splashRadius: 10,
                                  iconSize: SizeConfig.image(20),
                                  icon: (isObsecureReNew.value)
                                      ? Icon(
                                          Icons.visibility_off_outlined,
                                        )
                                      : Icon(
                                          Icons.visibility,
                                        ),
                                  onPressed: () {
                                    isObsecureReNew.value =
                                        !isObsecureReNew.value;
                                  },
                                ),
                                icon: SvgPicture.asset(
                                  'assets/img/image-svg/key.svg',
                                  height: SizeConfig.height(20),
                                ),
                                hintText: 'Ulangi kata sandi baru',
                                hintStyle:
                                    TextStyle(fontSize: SizeConfig.text(14)),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.height(318),
                ),
                SizedBox(
                  width: SizeConfig.width(328),
                  height: SizeConfig.height(40),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey1.currentState.validate() &&
                          _formKey2.currentState.validate() &&
                          _formKey3.currentState.validate() &&
                          _formKey4.currentState.validate()) {
                        // save password
                        EasyLoading.show(status: 'loading');
                        var result =
                            await ChangePasswordServices.changePassword(
                                currentPassword: controllerCurrentPassword.text,
                                newPassword: controllerReNewPassword.text);
                        final logger = Logger();
                        logger.i(result);
                        EasyLoading.dismiss();
                        if (result == 'SUCCESS CHANGE') {
                          EasyLoading.showSuccess('Password berhasil diubah');
                        } else if (result == 'FAILED CHANGE') {
                          EasyLoading.showError('Password gagal diubah');
                        } else if (result == 'USER NOT FOUND') {
                          EasyLoading.showError(
                              'Gagal mengambil data user, silahkan hubungi admin');
                        } else if (result == 'CURRENT WRONG PASSWORD') {
                          EasyLoading.showError('Password anda salah');
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    )),
                    child: Text(
                      'Simpan',
                      style: TextStyle(
                        fontSize: SizeConfig.text(16),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
