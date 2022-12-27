import 'dart:convert';
import 'dart:io';

import 'package:aplikasi_rw/modules/estate_manager/widgets/app_bar.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

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
  final _formCordinator = GlobalKey<FormState>();
  final _formKontraktor = GlobalKey<FormState>();

  Future futureBagian = CreateAccountServices.getBagian();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppBarEm(),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tambah akun',
                      style: TextStyle(fontSize: 23.sp),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
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
                                ? AssetImage(
                                    'assets/img/blank_profile_picture.jpg')
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
                            TextFormField(
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
                            TextFormField(
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
                            TextFormField(
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
                              .map((e) => DropdownMenuItem<String>(
                                    enabled: true,
                                    value: '${e['id_master_category']}',
                                    child: Text(
                                      '${e['unit']}',
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Color(0xff757575)),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {},
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
                          height: 16.h,
                        ),
                        Text(
                          'Kepala Bagian',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        DropdownButtonFormField(
                          itemHeight: null,
                          items: [
                            DropdownMenuItem(
                                child: Text(
                              'Iskandar',
                              style: TextStyle(fontSize: 12.sp),
                            ))
                          ],
                          onChanged: (value) {},
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
                            TextFormField(
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
                            onPressed: () {},
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
        builder: (context, snapshot) => (snapshot.hasData)
            ? Column(
                children: [
                  Obx(
                    () => Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: (pathCordinator.isEmpty)
                                ? AssetImage(
                                    'assets/img/blank_profile_picture.jpg')
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
                            TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'tidak boleh kosong';
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
                            TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'tidak boleh kosong';
                                }
                                return null;
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
                            TextFormField(
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
                              .map((e) => DropdownMenuItem<String>(
                                    enabled: true,
                                    value: '${e['id_master_category']}',
                                    child: Text(
                                      '${e['unit']}',
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Color(0xff757575)),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {},
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
                            TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'tidak boleh kosong';
                                }
                                return null;
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
                            onPressed: () {
                              if (_formCordinator.currentState.validate()) {}
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
            : Center(child: CircularProgressIndicator()));
  }
}

class CreateAccountServices {
  static Future<List<dynamic>> getBagian() async {
    String idUser = await UserSecureStorage.getIdUser();
    if (idUser == null) {
      idUser = '1';
    }
    List<dynamic> result;

    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));

    var data = {'id_user': idUser};

    String url = '${ServerApp.url}src/cordinator/tarik_bagian.php';

    var response = await dio.post(url, data: jsonEncode(data));

    if (response.statusCode == 200) {
      var result = jsonDecode(response.data);

      final logger = Logger();
      logger.i(result);

      return result;
    }
    return result;
  }
}
