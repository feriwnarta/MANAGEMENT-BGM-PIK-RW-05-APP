import 'dart:io';

import 'package:aplikasi_rw/modules/admin/controllers/AdminController.dart';
import 'package:aplikasi_rw/modules/admin/services/admin_services.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:aplikasi_rw/utils/view_image.dart';
import 'package:aplikasi_rw/utils/view_image_file.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class EditInformasiWarga extends StatefulWidget {
  EditInformasiWarga({Key key, this.id, this.url, this.title, this.content})
      : super(key: key);

  final String id, url, title, content;

  @override
  State<EditInformasiWarga> createState() => _EditInformasiWargaState();
}

class _EditInformasiWargaState extends State<EditInformasiWarga> {
  final _formKeyTitle = GlobalKey<FormState>();
  final _formKeyContent = GlobalKey<FormState>();

  final RxString imagePath = ''.obs;

  TextEditingController controllerTitle;

  TextEditingController controllerContent;

  final AdminController adminController = Get.put(AdminController());

  @override
  void initState() {
    super.initState();
    controllerTitle = TextEditingController(text: '${widget.title}');
    controllerContent = TextEditingController(text: '${widget.content}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tulis Informasi Warga',
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
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: (imagePath.value.isEmpty)
                              ? CachedNetworkImageProvider(widget.url)
                              : FileImage(File('${imagePath.value}')),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
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
                  key: _formKeyTitle,
                  child: TextFormField(
                    controller: controllerTitle,
                    decoration: InputDecoration(
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
                        _formKeyTitle.currentState.validate();
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
                  height: SizeConfig.height(16),
                ),
                Text(
                  'Masukan Isi Informasi',
                  style: TextStyle(
                    fontSize: SizeConfig.text(14),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.height(4),
                ),
                Form(
                  key: _formKeyContent,
                  child: TextFormField(
                    maxLines: 10,
                    controller: controllerContent,
                    decoration: InputDecoration(
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
                        _formKeyTitle.currentState.validate();
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
                  height: SizeConfig.height(16),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKeyContent.currentState.validate() &&
                          _formKeyTitle.currentState.validate()) {
                        EasyLoading.show(status: 'loading');

                        var result = await AdminServices.updateNews(
                            caption: controllerTitle.text,
                            content: controllerContent.text,
                            idNews: widget.id,
                            isNewImage:
                                (imagePath.value.isNotEmpty) ? true : false,
                            image: (imagePath.value.isEmpty)
                                ? widget.url
                                : imagePath.value);

                        if (result.isCaseInsensitiveContainsAny('OK')) {
                          EasyLoading.showSuccess('berhasil update');
                          Get.back();
                          adminController.refreshShow();
                        } else {
                          EasyLoading.showError('gagal update');
                        }
                      }
                    },
                    child: Text(
                      'Perbarui',
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
      imagePath.value = imageOrPhoto.path;
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
