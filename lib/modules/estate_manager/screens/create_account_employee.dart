import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateAccountEmployee extends StatefulWidget {
  const CreateAccountEmployee({Key key}) : super(key: key);

  @override
  State<CreateAccountEmployee> createState() => _CreateAccountEmployeeState();
}

class _CreateAccountEmployeeState extends State<CreateAccountEmployee> {
  RxString pathAvatar = ''.obs;
  final AssetImage image = AssetImage('assets/img/blank_profile_picture.jpg');
  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));

    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Akun'),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            children: [
              AutoSizeText(
                'Tambah personil di bagian perawatan lanskap.',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Color(0xff616161),
                ),
                maxLines: 3,
                minFontSize: 15,
                overflow: TextOverflow.ellipsis,
              ),
              CircleAvatar(
                backgroundImage: (pathAvatar.value.isEmpty)
                    ? image
                    : FileImage(
                        File(pathAvatar.value),
                      ),
                radius: 124.h / 2,
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
                  style: TextStyle(fontSize: 16.sp, color: Color(0xff9E9E9E)),
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
