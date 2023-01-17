import 'dart:io';
import 'package:aplikasi_rw/modules/authentication/validate/validate_email_and_password.dart';
import 'package:aplikasi_rw/modules/estate_manager/controllers/estate_manager_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:image_picker/image_picker.dart';
import '../services/create_account_services.dart';

enum TypeAccount { em, kontraktor }

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  TypeAccount akun = TypeAccount.em;
  final _picker = ImagePicker();
  RxString condition = 'estatekordinator'.obs;
  RxString pathCordinator = ''.obs;
  RxString pathKontraktor = ''.obs;
  RxString bagian = ''.obs;
  RxString kepalaBagian = ''.obs;
  final _formCordinator = GlobalKey<FormState>();

  Future futureBagian = CreateAccountServices.getBagian();

  final AssetImage image = AssetImage('assets/img/blank_profile_picture.jpg');

  /// form key validator
  final _formKeyUsername = GlobalKey<FormState>();
  final _formKeyNama = GlobalKey<FormState>();
  final _formKeyEmail = GlobalKey<FormState>();
  final _formKeyNoTelp = GlobalKey<FormState>();
  final _formKeyPassword = GlobalKey<FormState>();

  /// form key contractor
  /// form key validator
  final _formKeyUsernameContractor = GlobalKey<FormState>();
  final _formKeyNamaContractor = GlobalKey<FormState>();
  final _formKeyEmailContractor = GlobalKey<FormState>();
  final _formKeyPasswordContractor = GlobalKey<FormState>();
  final _formKeyNoTelpContractor = GlobalKey<FormState>();

  final emController = Get.put(EstateManagerController());

  RxList<String> listChecked = [].obs;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(image, context);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Akun',
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tambah personil di lapangan untuk memudahkan pekerjaan',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Color(0xff9E9E9E),
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Radio<TypeAccount>(
                                  value: TypeAccount.em,
                                  groupValue: akun,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  onChanged: (akun) {
                                    setState(() {
                                      this.akun = akun;
                                    });
                                    condition.value = 'estatekordinator';
                                  }),
                              Expanded(child: Text('Estate kordinator'))
                            ],
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Radio<TypeAccount>(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  value: TypeAccount.kontraktor,
                                  groupValue: akun,
                                  onChanged: (akun) {
                                    setState(() {
                                      this.akun = akun;
                                    });
                                    condition.value = 'kontraktor';
                                  }),
                              Expanded(child: Text('Kontraktor'))
                            ],
                          ),
                          flex: 1,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Obx(
                      () => (condition.value == 'estatekordinator')
                          ? estateKordinator()
                          : kontraktor(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomImagePicker(String path) => Container(
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
                      getImage(ImageSource.camera, path);
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
                    getImage(ImageSource.gallery, path);
                    Navigator.of(context)
                        .pop(); // -> digunakan untuk menutup show modal bottom sheet secara programatic
                  },
                )
              ],
            )
          ],
        ),
      );

  void getImage(ImageSource source, String path) async {
    var pickedFile = await _picker.pickImage(source: source, imageQuality: 50);

    if (pickedFile != null) {
      if (path == 'cordinator') {
        pathCordinator.value = pickedFile.path;
      } else {
        pathKontraktor.value = pickedFile.path;
      }
    }
  }

  FutureBuilder kontraktor() {
    return FutureBuilder<List<dynamic>>(
        future: futureBagian,
        builder: (context, snapshot) => (snapshot.hasData)
            ? Column(
                children: [
                  Center(
                    child: Obx(
                      () => Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: (pathKontraktor.isEmpty)
                                ? image
                                : FileImage(File(pathKontraktor.value)),
                            radius: 124.h / 2,
                          ),
                          SizedBox(
                            height: 24.h,
                          ),
                          OutlinedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) =>
                                    bottomImagePicker('kontraktor'),
                              );
                            },
                            child: Text(
                              'Pilih gambar',
                              style: TextStyle(
                                  fontSize: 16.sp, color: Color(0xff9E9E9E)),
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
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 38.h,
                  ),
                  Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Username',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Form(
                              key: _formKeyUsernameContractor,
                              onChanged: () => _formKeyUsernameContractor
                                  .currentState
                                  .validate(),
                              child: TextFormField(
                                controller: emController.usernameContractor,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'username tidak boleh kosong';
                                  } else if (value.length < 5) {
                                    return 'username harus lebih dari 5 karakter';
                                  } else {
                                    return null;
                                  }
                                },
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
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nama',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Form(
                              key: _formKeyNamaContractor,
                              onChanged: () => _formKeyNamaContractor
                                  .currentState
                                  .validate(),
                              child: TextFormField(
                                onChanged: (value) {
                                  if (value.isEmpty) {
                                    return 'nama tidak boleh kosong';
                                  }
                                  return null;
                                },
                                controller: emController.namaContractor,
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
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Form(
                              key: _formKeyEmailContractor,
                              child: TextFormField(
                                onChanged: (value) => _formKeyEmailContractor
                                    .currentState
                                    .validate(),
                                controller: emController.emailContractor,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'email tidak boleh kosong';
                                  } else if (!ValidationForm.isValidEmail(
                                      value)) {
                                    return 'email tidak valid';
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
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'No telpon',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Form(
                              key: _formKeyNoTelpContractor,
                              child: TextFormField(
                                controller: emController.noTelpContractor,
                                keyboardType: TextInputType.number,
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
                            )
                          ],
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Text(
                          'Bagian',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        FutureBuilder<List<Map<String, dynamic>>>(
                            future: CreateAccountServices.getBagianContractor(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return CheckboxGroup(
                                  checked: listChecked,
                                  labels: snapshot.data
                                      .map((e) => e['category'] as String)
                                      .toList(),
                                  labelStyle: TextStyle(fontSize: 12.sp),
                                  onChange: (isChecked, label, index) {
                                    if (isChecked) {
                                      listChecked.add(label);
                                    } else {
                                      listChecked.remove(label);
                                    }

                                    print(listChecked);
                                  },
                                );
                              } else {
                                return Center(
                                  child: CircularProgressIndicator.adaptive(),
                                );
                              }
                            }),
                        SizedBox(
                          height: 16.h,
                        ),
                        Text(
                          'Kepala Bagian',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: CreateAccountServices.getKepalaBagian(),
                          builder: (context, snapshot) => (snapshot.hasData)
                              ? DropdownButtonFormField(
                                  itemHeight: null,
                                  items: snapshot.data
                                      .map(
                                        (e) => DropdownMenuItem<String>(
                                          enabled: true,
                                          value: '${e['id_estate_cordinator']}',
                                          child: Text(
                                            '${e['name_estate_cordinator']}',
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                color: Color(0xff757575)),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  hint: Text(
                                      '${snapshot.data[0]['name_estate_cordinator']}'),
                                  value: snapshot.data[0]
                                      ['id_estate_cordinator'],
                                  onChanged: (value) {
                                    kepalaBagian.value = value;
                                    print(value);
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
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xffC2C2C2),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        ),
                        SizedBox(
                          height: 22.h,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Password',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Form(
                              key: _formKeyPasswordContractor,
                              child: TextFormField(
                                controller: emController.passwordContractor,
                                onChanged: (value) => _formKeyPasswordContractor
                                    .currentState
                                    .validate(),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'password tidak boleh kosong';
                                  } else {
                                    return null;
                                  }
                                },
                                obscureText: true,
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
                            )
                          ],
                        ),
                        SizedBox(
                          height: 32.h,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50))),
                            onPressed: () async {
                              if (_formKeyUsernameContractor.currentState
                                      .validate() &&
                                  _formKeyNamaContractor.currentState
                                      .validate() &&
                                  _formKeyEmailContractor.currentState
                                      .validate() &&
                                  _formKeyPasswordContractor.currentState
                                      .validate()) {
                                if (listChecked.isEmpty) {
                                  EasyLoading.showInfo('Bagian harus dipilih');
                                } else if (kepalaBagian.value.isEmpty) {
                                  EasyLoading.showInfo(
                                      'Kepala bagian harus dipilih');
                                } else {
                                  String result =
                                      await CreateAccountServices.contractor(
                                    email: emController.emailContractor.text,
                                    fotoProfile: pathKontraktor.value,
                                    name: emController.namaContractor.text,
                                    noTelp: emController.noTelpContractor.text,
                                    password:
                                        emController.passwordContractor.text,
                                    username:
                                        emController.usernameContractor.text,
                                    idEstateCord: kepalaBagian.value,
                                    contractorJob: listChecked.join(','),
                                  );

                                  if (result == 'register successfull') {
                                    setState(() {
                                      emController.reset();
                                      listChecked.clear();
                                    });
                                  }
                                }
                              }
                            },
                            child: Text(
                              'Simpan',
                              style: TextStyle(fontSize: 16.sp),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                      ],
                    ),
                  )
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  FutureBuilder estateKordinator() {
    return FutureBuilder<List<dynamic>>(
        future: futureBagian,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bagian.value = snapshot.data.first['id_master_category'];
            return Column(
              children: [
                Obx(
                  () => Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: (pathCordinator.isEmpty)
                              ? image
                              : FileImage(File(pathCordinator.value)),
                          radius: 124.h / 2,
                        ),
                        SizedBox(
                          height: 24.h,
                        ),
                        OutlinedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) =>
                                  bottomImagePicker('cordinator'),
                            );
                          },
                          child: Text(
                            'Pilih gambar',
                            style: TextStyle(
                                fontSize: 16.sp, color: Color(0xff9E9E9E)),
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
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 38.h,
                ),
                Form(
                  key: _formCordinator,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                  return 'username harus lebih dari 5 karakter';
                                }
                                return null;
                              },
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
                              onChanged: (value) =>
                                  _formKeyUsername.currentState.validate(),
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nama',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Form(
                            key: _formKeyNama,
                            child: TextFormField(
                              controller: emController.nama,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'tidak boleh kosong';
                                }
                                return null;
                              },
                              onChanged: (value) =>
                                  _formKeyNama.currentState.validate(),
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
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                              onChanged: (value) =>
                                  _formKeyEmail.currentState.validate(),
                              validator: (value) {
                                if (ValidationForm.isValidEmail(value)) {
                                  return null;
                                } else {
                                  return 'email tidak valid';
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'No Telp',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Form(
                            key: _formKeyNoTelp,
                            child: TextFormField(
                              controller: emController.noTelp,
                              keyboardType: TextInputType.number,
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
                                if (ValidationForm.isValidPhone(value)) {
                                  return null;
                                } else if (value.isEmpty) {
                                  return null;
                                } else {
                                  return 'Nomor telpon tidak sesuai';
                                }
                              },
                              onChanged: (value) =>
                                  _formKeyNoTelp.currentState.validate(),
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          )
                        ],
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
                                value: '${e['id_master_category']}',
                                child: Text(
                                  '${e['unit']}',
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Color(0xff757575)),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          bagian.value = value;
                        },
                        hint: Text('${snapshot.data[0]['unit']}',
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
                        height: 22.h,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                              onChanged: (value) =>
                                  _formKeyPassword.currentState.validate(),
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 32.h,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50))),
                          onPressed: () async {
                            if (_formKeyUsername.currentState.validate() &&
                                _formKeyNama.currentState.validate() &&
                                _formKeyEmail.currentState.validate() &&
                                _formKeyNoTelp.currentState.validate() &&
                                _formKeyPassword.currentState.validate() &&
                                _formKeyNama.currentState.validate()) {
                              /// kirim data keserver
                              String result =
                                  await CreateAccountServices.cordinator(
                                username: emController.username.text,
                                email: emController.email.text,
                                name: emController.nama.text,
                                noTelp: emController.noTelp.text,
                                password: emController.password.text,
                                cordinatorJob: bagian.value,
                                fotoProfile: pathCordinator.value,
                              );

                              if (result == 'Register Successful') {
                                emController.reset();
                                pathCordinator.value = '';
                                FocusScope.of(context).unfocus();
                              }
                            }
                          },
                          child: Text(
                            'Simpan',
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                    ],
                  ),
                )
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
