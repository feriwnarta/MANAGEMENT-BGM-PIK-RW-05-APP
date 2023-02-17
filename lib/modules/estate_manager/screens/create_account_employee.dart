import 'dart:io';

import 'package:aplikasi_rw/modules/authentication/validate/validate_email_and_password.dart';
import 'package:aplikasi_rw/modules/estate_manager/controllers/estate_manager_controller.dart';
import 'package:aplikasi_rw/modules/estate_manager/data/position_employee.dart';
import 'package:aplikasi_rw/modules/estate_manager/services/create_account_services.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class CreateAccountEmployee extends StatefulWidget {
  const CreateAccountEmployee({Key key, this.division, this.title, this.job})
      : super(key: key);
  final String division;
  final String title, job;

  @override
  State<CreateAccountEmployee> createState() => _CreateAccountEmployeeState();
}

class _CreateAccountEmployeeState extends State<CreateAccountEmployee> {
  RxString pathAvatar = ''.obs;
  final AssetImage image = AssetImage('assets/img/blank_profile_picture.jpg');
  final _picker = ImagePicker();

  /// form key
  final _formKeyUsername = GlobalKey<FormState>();
  final _formKeyNama = GlobalKey<FormState>();
  final _formKeyEmail = GlobalKey<FormState>();
  final _formKeyNoTelp = GlobalKey<FormState>();
  final _formKeyPassword = GlobalKey<FormState>();

  final emController = Get.put(EstateManagerController());

  RxString position = ''.obs;

  @override
  void didChangeDependencies() {
    precacheImage(image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));

    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Akun'),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: FutureBuilder<List<PositionEmployee>>(
          future: CreateAccountServices.getPosition(type: widget.division),
          builder: (context, snapshot) {
            return (snapshot.hasData)
                ? SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              AutoSizeText(
                                widget.title,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Color(0xff616161),
                                ),
                                maxLines: 3,
                                minFontSize: 15,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                height: 34.h,
                              ),
                              Center(
                                child: CircleAvatar(
                                  backgroundImage: (pathAvatar.value.isEmpty)
                                      ? image
                                      : FileImage(
                                          File(pathAvatar.value),
                                        ),
                                  radius: 124.h / 2,
                                ),
                              ),
                              SizedBox(
                                height: 24.h,
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) => bottomImagePicker(),
                                  );
                                },
                                child: Text(
                                  'Pilih gambar',
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Color(0xff9E9E9E)),
                                ),
                              ),
                              SizedBox(
                                height: 32.h,
                              ),
                              SizedBox(
                                width: 216.w,
                                child: Column(children: [
                                  Text(
                                    'Ukuran gambar : maks. 1MB',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Color(0xff9E9E9E),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4.h,
                                  ),
                                  Text(
                                    'Format gambar : .JPG, .PNG',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Color(0xff9E9E9E),
                                    ),
                                  )
                                ]),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 24.h,
                          ),
                          Text(
                            'Username',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Form(
                            key: _formKeyUsername,
                            child: TextFormField(
                              controller: emController.username,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'tidak boleh kosong';
                                } else if (value.length < 5) {
                                  return 'username harus lebih dari 4 karakter';
                                }
                                return null;
                              },
                              onChanged: (value) =>
                                  _formKeyUsername.currentState.validate(),
                              style: TextStyle(fontSize: 14.sp),
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 6.h),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xffC2C2C2),
                                  ),
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Text(
                            'Nama',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                          Form(
                            key: _formKeyNama,
                            child: TextFormField(
                              controller: emController.nama,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'tidak boleh kosong';
                                } else if (value.length < 5) {
                                  return 'nama harus lebih dari 4 karakter';
                                }
                                return null;
                              },
                              onChanged: (value) =>
                                  _formKeyNama.currentState.validate(),
                              style: TextStyle(fontSize: 14.sp),
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xffC2C2C2),
                                  ),
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Text(
                            'Email',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Form(
                            key: _formKeyEmail,
                            child: TextFormField(
                              controller: emController.email,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 6.h),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xffC2C2C2),
                                  ),
                                ),
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (ValidationForm.isValidEmail(value)) {
                                  return null;
                                } else {
                                  return 'email tidak valid';
                                }
                              },
                              onChanged: (value) =>
                                  _formKeyEmail.currentState.validate(),
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Text(
                            'Nomor Telpon',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Form(
                            key: _formKeyNoTelp,
                            child: TextFormField(
                              controller: emController.noTelp,
                              onChanged: (value) {
                                _formKeyNoTelp.currentState.validate();
                              },
                              // controller: emController.noTelpContractor,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'no telpon tidak boleh kosong';
                                } else if (!ValidationForm.isValidPhone(
                                    value)) {
                                  return 'no telpon tidak valid';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 6.h),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xffC2C2C2),
                                  ),
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Text(
                            'Bagian',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          DropdownButtonFormField<String>(
                            items: snapshot.data
                                .map(
                                  (e) => DropdownMenuItem<String>(
                                    enabled: true,
                                    value: e.idPosition,
                                    child: Text(
                                      e.position,
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Color(0xff757575)),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              position.value = value;
                              print(position.value);
                            },
                            hint: Text('${snapshot.data[0].position}',
                                style: TextStyle(
                                    fontSize: 14.sp, color: Color(0xff757575))),
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 6.h),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffC2C2C2),
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffC2C2C2),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Text(
                            'Password',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Form(
                            key: _formKeyPassword,
                            child: TextFormField(
                              controller: emController.password,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'tidak boleh kosong';
                                } else if (value.length < 8) {
                                  return 'password harus lebih dari 7 karakter';
                                }
                                return null;
                              },
                              onChanged: (value) =>
                                  _formKeyPassword.currentState.validate(),
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 6.h),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xffC2C2C2),
                                  ),
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 24.h,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKeyUsername.currentState.validate() &&
                                    _formKeyNama.currentState.validate() &&
                                    _formKeyEmail.currentState.validate() &&
                                    _formKeyPassword.currentState.validate() &&
                                    _formKeyNoTelp.currentState.validate()) {
                                  if (position.value.isEmpty) {
                                    EasyLoading.showInfo(
                                        'Bagian harus dipilih');
                                  } else {
                                    String result = await CreateAccountServices
                                        .saveEmployee(
                                            username:
                                                emController.username.text,
                                            division: widget.division,
                                            email: emController.email.text,
                                            fotoProfile: pathAvatar.value,
                                            idPosition: position.value,
                                            job: widget.job,
                                            name: emController.nama.text,
                                            noTelp: emController.noTelp.text,
                                            password:
                                                emController.password.text);

                                    if (result != null && result.isNotEmpty) {
                                      if (result == 'user exist') {
                                        EasyLoading.showInfo(
                                            'Username sudah digunakan, silahkan gunakan username lain');
                                      } else if (result == 'email exist') {
                                        EasyLoading.showError(
                                            'Email sudah digunakan, silahkan gunakan email lain');
                                      } else if (result == 'no_telpon exist') {
                                        EasyLoading.showError(
                                            'Nomor telpon sudah digunakan, silahkan gunakan nomor lain');
                                      } else if (result == 'success') {
                                        EasyLoading.showSuccess(
                                            'Berhasil menambahkan akun');

                                        emController.reset();
                                        pathAvatar.value = '';
                                      } else if (result == 'failed') {
                                        EasyLoading.showError(
                                            'Gagal membuat akun');
                                      } else if (result ==
                                          'insert user failed') {
                                        EasyLoading.showError(
                                            'Gagal membuat akun, silahkan hubungi admin');
                                      }
                                    } else {
                                      EasyLoading.showInfo(
                                          'Gagal membuat akun');
                                    }
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff2094F3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: Text(
                                'Simpan',
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : LinearProgressIndicator();
          }),
    );
  }

  void getImage(ImageSource source) async {
    var pickedFile = await _picker.pickImage(source: source, imageQuality: 50);

    if (pickedFile != null) {
      pathAvatar.value = pickedFile.path;
    }
  }

  Widget bottomImagePicker() => Container(
        margin: EdgeInsets.only(top: 20),
        width: MediaQuery.of(context).size.width,
        height: 120.h,
        child: Column(
          children: [
            Text(
              'Pilih gambar',
              style: TextStyle(fontSize: 13.0.sp, fontFamily: 'Pt Sans Narrow'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                    icon: Icon(Icons.camera_alt),
                    label: Text(
                      'Kamera',
                      style: TextStyle(
                          fontSize: 13.0.sp, fontFamily: 'Pt Sans Narrow'),
                    ),
                    onPressed: () {
                      getImage(ImageSource.camera);
                      Navigator.of(context)
                          .pop(); // -> digunakan untuk menutup show modal bottom sheet secara programatic
                    }),
                TextButton.icon(
                  icon: Icon(Icons.image),
                  label: Text(
                    'Gallery',
                    style: TextStyle(
                        fontSize: 13.0.sp, fontFamily: 'Pt Sans Narrow'),
                  ),
                  onPressed: () {
                    getImage(ImageSource.gallery);
                    Navigator.of(context)
                        .pop(); // -> digunakan untuk menutup show modal bottom sheet secara programatic
                  },
                )
              ],
            )
          ],
        ),
      );
}
