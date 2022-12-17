import 'dart:io';
import 'package:aplikasi_rw/controller/status_user_controller.dart';
import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/controller/write_status_controller.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/services/status_user_services.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart' as sidio;
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//ignore: must_be_immutable
class TempatTulisStatus extends StatefulWidget {
  @override
  State<TempatTulisStatus> createState() => _TempatTulisStatusState();
}

//ignore: must_be_immutable
class _TempatTulisStatusState extends State<TempatTulisStatus> {
  final _picker = ImagePicker();
  // app bar disimpan ke variabel untuk diambil tingginya
  AppBar appBar;
  // field untuk data user
  final TextEditingController controllerStatus = TextEditingController();
  XFile pickedFile;
  StatusUserController controllerPostingStatus =
      Get.put(StatusUserController());
  var controllerLogin;
  WriteStatusController writeStatusController;
  final logger = Logger(printer: PrettyPrinter());
  sidio.Dio dio;

  @override
  void initState() {
    super.initState();
    // controllerPostingStatus = Get.put(StatusUserController());
    controllerLogin = Get.put(UserLoginController());
    writeStatusController = Get.put(WriteStatusController());
    dio = sidio.Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));
    // dio.interceptors.add(RetryOnConnectionChangeInterceptor(
    //   requestRetrier: DioConnectivityRequestRetrier(
    //     dio: dio,
    //     connectivity: Connectivity(),
    //   ),
    // ));
  }

  @override
  void dispose() {
    // controllerStatus.dispose();
    writeStatusController.deleteImage();
    // Navigator.of(context).pop();
    // Get.delete<StatusUserController>();
    Get.delete<WriteStatusController>();
    super.dispose();
  }

  Widget build(BuildContext context) {
    appBar = AppBar(
      brightness: Brightness.light,
      // leading: IconButton(
      //   icon: Icon(
      //     Icons.clear_rounded,
      //     color: Colors.white,
      //     size: 20.h,
      //   ),
      //   onPressed: () {
      //     writeStatusController.deleteImage();
      //     Navigator.of(context).pop();
      //     Get.delete<StatusUserController>();
      //   },
      // ),

      title: Text('Buat Postingan',
          style: TextStyle(
            fontSize: 17.sp,
          )),
    );

    return Scaffold(
        appBar: appBar,
        body: SafeArea(
          child: ListView(children: [
            Column(
              children: [
                SizedBox(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            top: BorderSide(color: Colors.grey[200]),
                            bottom: BorderSide(color: Colors.grey[200]))),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 10.h),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              // avatar
                              CircleAvatar(
                                radius: 20.h,
                                backgroundImage: CachedNetworkImageProvider(
                                    '${ServerApp.url}${controllerLogin.urlProfile}'),
                              ),
                              headerName(),
                              Material(
                                color: Colors.transparent,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.image,
                                    size: 20.h,
                                    color: Colors.green[400],
                                  ),
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) =>
                                            bottomImagePicker(context));
                                  },
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                textFieldTulisStatus(),
                // gambar jika diupload
                gambarUploadStatus(),

                // divider untuk memberikan batas antara container gambar yg di upload dengan button bawahnya
                Divider(
                  height: 2,
                ),

                // button untuk upload gambar / pilih gambar
                buttonPilihGambar(context),

                // button untuk kirim posting status
                buttonPosting(context)
              ],
            ),
          ]),
        ));
  }

  ElevatedButton buttonPosting(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(30.h),
          backgroundColor: Colors.green,
          // onPrimary: Colors.white,
          textStyle: TextStyle(fontSize: 13.0.sp, fontWeight: FontWeight.bold)),
      child: Column(
        children: [
          SizedBox(
            height: 15.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.h),
                child: Text(
                  'Posting',
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
              )
            ],
          ),
          SizedBox(
            height: 15.h,
          )
        ],
      ),
      onPressed: () async {
        String idUser = await UserSecureStorage.getIdUser();
        // String imgPath = (tsstate.imageFile.path == null && tsstate.imageFile == null) ? 'no_image' : tsstate.imageFile.path;
        String imgPath = (writeStatusController.pickedFile.value != null &&
                writeStatusController.pickedFile.value.isNotEmpty)
            ? writeStatusController.pickedFile.value
            : 'no_image';

        // List<String> listImage = [imgPath];

        if (!imgPath.isCaseInsensitiveContainsAny('no_image') ||
            controllerStatus.text.isNotEmpty) {
          final sidio.FormData formData = sidio.FormData.fromMap({
            "status_image": !(imgPath.isCaseInsensitiveContainsAny('no_image'))
                ? await sidio.MultipartFile.fromFile(
                    imgPath,
                    filename: imgPath,
                    contentType: new MediaType("image", "jpeg"),
                  )
                : imgPath,
            'id_user': idUser,
            'username': '${controllerLogin.username}',
            'foto_profile': '${controllerLogin.urlProfile}',
            'caption': controllerStatus.text,
          });
          // showLoading(context);
          EasyLoading.show(status: 'loading');
          String message = await StatusUserServices.sendStatus(formData, dio);
          if (message != null && message.isNotEmpty) {
            controllerPostingStatus.addStatus();
            Get.delete<WriteStatusController>();
            FocusScope.of(context).requestFocus(FocusNode());
            EasyLoading.showToast('terkirim',
                dismissOnTap: true,
                toastPosition: EasyLoadingToastPosition.bottom);
            EasyLoading.dismiss();
            Navigator.of(context)..pop();
          }
        } else {
          Get.snackbar(
            'message',
            'caption atau gambar tidak boleh kosong',
            maxWidth: 300,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            isDismissible: false,
            overlayBlur: 2,
            duration: Duration(milliseconds: 1200),
            snackPosition: SnackPosition.TOP,
          );
        }
      },
    );
  }

  ElevatedButton buttonPilihGambar(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(20.h),
        backgroundColor: Colors.blue,
        // onPrimary: Colors.green // splash color
      ),
      child: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.image_outlined,
                color: Colors.white,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 10.w,
                ),
                child: Text(
                  'Pilih gambar',
                  style: TextStyle(color: Colors.white, fontSize: 14.0.sp),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.h,
          )
        ],
      ),
      onPressed: () {
        showModalBottomSheet(
            context: context,
            builder: ((builder) => bottomImagePicker(context)));
      },
    );
  }

  GetBuilder gambarUploadStatus() {
    return GetBuilder<WriteStatusController>(
      builder: (controller) => Visibility(
        visible: controller.isVisibility.value,
        child: (Container(
          // width: mediaSizeWidth,
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 2.0.w),
                child: Image(
                  alignment: Alignment.topLeft,
                  repeat: ImageRepeat.noRepeat,
                  fit: BoxFit.cover,
                  image: (writeStatusController.pickedFile.value != null)
                      ? FileImage(File(writeStatusController.pickedFile.value))
                      : AssetImage(''),
                  height: 100.h,
                  width: 200.w,
                ),
              ),

              //  button hapus gambar
              Padding(
                padding: EdgeInsets.only(left: 1.5.w),
                child: ElevatedButton(
                    // elevation: 0,
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blueGrey[100]),
                    // color: Colors.blueGrey[100],
                    child: Text(
                      'Hapus',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 10.0.sp),
                    ),
                    onPressed: () {
                      writeStatusController.deleteImage();
                      writeStatusController.update();
                    }),
              ),
            ],
          ),
        )),
      ),
    );
  }

  // sebelumnya pake sizebox
  Padding textFieldTulisStatus() {
    return Padding(
      padding: EdgeInsets.only(left: 10.w),
      child: TextField(
        controller: controllerStatus,
        maxLines: 10,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Apa yang anda pikirkan ?',
            hintStyle: TextStyle(fontSize: 14.0.sp)),
      ),
    );
  }

  Padding headerName() {
    return Padding(
      padding: EdgeInsets.only(left: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Text(
                '${controllerLogin.username}',
                style: TextStyle(fontFamily: 'poppins', fontSize: 14.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget bottomImagePicker(BuildContext context) => Container(
        margin: EdgeInsets.only(top: 20),
        width: MediaQuery.of(context).size.width,
        height: 100.h,
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

  void getImage(ImageSource source) async {
    pickedFile = await _picker.pickImage(source: source, imageQuality: 50);

    if (pickedFile != null) {
      RxString path = pickedFile.path.obs;
      writeStatusController.addImage(true.obs, path);
      logger.i('PATH' + writeStatusController.pickedFile.value);
      writeStatusController.update();
    }
  }
}
