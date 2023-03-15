import 'dart:io';

import 'package:aplikasi_rw/modules/admin/controllers/AdminController.dart';
import 'package:aplikasi_rw/modules/admin/screens/informasi_umum/buat_informasi_umum_content.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:aplikasi_rw/utils/view_image_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class BuatInformasiUmum extends StatefulWidget {
  BuatInformasiUmum({Key key}) : super(key: key);

  @override
  State<BuatInformasiUmum> createState() => _BuatInformasiUmum();
}

class _BuatInformasiUmum extends State<BuatInformasiUmum> {
  final AdminController adminController = Get.put(AdminController());

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tulis Informasi Umum',
        ),
        systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.width(16),
              vertical: SizeConfig.height(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Masukan Gambar Untuk Thumbnail',
                  style: TextStyle(
                    fontSize: SizeConfig.text(14),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.height(16),
                ),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isDismissible: true,
                      elevation: 0,
                      builder: (context) => bottomImagePicker(context),
                    );
                  },
                  child: Obx(
                    () => Container(
                      width: double.infinity,
                      height: SizeConfig.height(188),
                      margin: EdgeInsets.only(bottom: SizeConfig.height(24)),
                      decoration: BoxDecoration(
                        color: Color(0xffEDEDED),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: (adminController.imagePath.value.isEmpty)
                          ? Center(
                              child: SvgPicture.asset(
                                'assets/img/admin/photograph.svg',
                                fit: BoxFit.cover,
                              ),
                            )
                          : InkWell(
                              onTap: () => Get.to(
                                ViewImageFile(
                                  path: adminController.imagePath.value,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    repeat: ImageRepeat.noRepeat,
                                    fit: BoxFit.cover,
                                    image: FileImage(
                                      File(adminController.imagePath.value),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Ukuran gambar : maks. 5 MB\n Format gambar : .JPG, .PNG',
                    style: TextStyle(
                      fontSize: SizeConfig.text(16),
                      color: Color(0xff9E9E9E),
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.height(32),
                ),
                Text(
                  'Masukan Judul Informasi',
                  style: TextStyle(
                    fontSize: SizeConfig.text(14),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.height(4),
                ),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: adminController.controllerTitle,
                    decoration: InputDecoration(
                      hintText: 'Vaksinasi Booster ke-2',
                      hintStyle: TextStyle(
                        fontSize: SizeConfig.text(14),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: SizeConfig.height(6),
                          horizontal: SizeConfig.width(12)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty || value != null) {
                        _formKey.currentState.validate();
                      }
                    },
                    validator: (String value) {
                      return (value != null && value.isEmpty)
                          ? 'judul informasi tidak boleh kosong'
                          : null;
                    },
                  ),
                ),
                SizedBox(
                  height: SizeConfig.height(172),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    onPressed: () {
                      if (adminController.imagePath.value.isEmpty) {
                        EasyLoading.showInfo(
                            'Gambar thumbnail tidak boleh kosong');
                      } else {
                        if (_formKey.currentState.validate()) {
                          Get.to(
                            () => BuatInformasiUmumContent(),
                            transition: Transition.cupertino,
                          );
                        }
                      }
                    },
                    child: Text(
                      'Mulai Menulis',
                      style: TextStyle(
                        fontSize: SizeConfig.text(14),
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

  Widget writeContent() {
    return Container(
      height: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.width(16),
        vertical: SizeConfig.height(16),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: SizeConfig.text(14),
                      color: Colors.black,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: Text(
                    'Selesai',
                    style: TextStyle(
                      fontSize: SizeConfig.text(10),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future getImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile imageOrPhoto =
        await _picker.pickImage(source: source, imageQuality: 50);

    if (imageOrPhoto != null) {
      adminController.imagePath.value = imageOrPhoto.path;
    }
  }

  Widget bottomImagePicker(BuildContext context) => Container(
        margin: EdgeInsets.only(top: SizeConfig.height(20)),
        // width: MediaQuery.of(context).size.width,
        height: SizeConfig.height(90),
        child: Column(
          children: [
            Text(
              'Pilih gambar',
              style: TextStyle(
                  fontSize: SizeConfig.text(13), fontFamily: 'Pt Sans Narrow'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                    icon: Icon(Icons.camera_alt),
                    label: Text(
                      'Kamera',
                      style: TextStyle(
                        fontSize: SizeConfig.text(13),
                      ),
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
                      fontSize: SizeConfig.text(13),
                    ),
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
