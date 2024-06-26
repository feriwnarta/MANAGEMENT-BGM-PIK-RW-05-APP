import 'dart:io';
import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/modules/authentication/validate/validate_email_and_password.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';

//ignore: must_be_immutable
class ChangeDataUser extends StatefulWidget {
  String urlProfilePath;

  @override
  _ChangeDataUserState createState() => _ChangeDataUserState();
}

class _ChangeDataUserState extends State<ChangeDataUser> {
  ImagePicker _picker = ImagePicker();

  TextEditingController controllerUsername = TextEditingController();
  TextEditingController controllerFullName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controller = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();

  String status;

  @override
  void dispose() {
    super.dispose();
    controllerUsername.dispose();
    controllerEmail.dispose();
    controllerFullName.dispose();
    controllerPhone.dispose();
    controller.dispose();
  }

  // final homeController = Get.put(HomeScreenController());
  final loginController = Get.put(UserLoginController());

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));
    return WillPopScope(
      onWillPop: () async {
        if (status != null && status == 'refresh') {
          Navigator.of(context).pop('refresh');
          return true;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pengaturan profil'),
        ),
        body: FutureBuilder<UserChangeModel>(
          future: UserChangeServices.getDataUser('${loginController.idUser}'),
          builder: (context, snapshot) => (snapshot.hasData)
              ? Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.height(15),
                    ),
                    Center(
                      child: GestureDetector(
                        child: Column(
                          children: [
                            Container(
                              height: SizeConfig.image(64),
                              width: SizeConfig.image(64),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  repeat: ImageRepeat.noRepeat,
                                  image: (widget.urlProfilePath == null)
                                      ? CachedNetworkImageProvider(
                                          '${ServerApp.url}${snapshot.data.profileImage}')
                                      : FileImage(
                                          File(widget.urlProfilePath),
                                        ),
                                ),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: ((builder) =>
                                        bottomImagePicker(context)));
                              },
                              icon: Icon(
                                FontAwesomeIcons.pen,
                                size: SizeConfig.height(14),
                              ),
                              label: Text(
                                'Ubah Foto',
                                style: TextStyle(fontSize: SizeConfig.text(14)),
                              ),
                            )
                          ],
                        ),
                        onTap: () => showModalBottomSheet(
                            context: context,
                            builder: ((builder) => bottomImagePicker(context))),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.height(28),
                    ),
                    ListTile(
                      leading: Icon(Icons.person, size: SizeConfig.height(20)),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: SizeConfig.height(1)),
                          Text(
                            'Username',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: SizeConfig.text(12)),
                          ),
                          SizedBox(height: SizeConfig.height(1)),
                          Text(
                            '${snapshot.data.fullName}',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: SizeConfig.text(12)),
                          ),
                          SizedBox(height: SizeConfig.height(1)),
                        ],
                      ),
                      trailing: Icon(
                        FontAwesomeIcons.pen,
                        size: SizeConfig.height(10),
                      ),
                      onTap: () => showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15.0))),
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => buildPaddingChangeData(
                              context, 'masukan username', 'username')),
                    ),
                    (snapshot.data.numberHouse == null)
                        ? SizedBox()
                        : ListTile(
                            leading:
                                Icon(Icons.home, size: SizeConfig.height(20)),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: SizeConfig.height(1)),
                                Text(
                                  'Nomor Rumah',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: SizeConfig.text(12)),
                                ),
                                SizedBox(height: SizeConfig.height(1)),
                                Text(
                                  '${snapshot.data.numberHouse}',
                                  style:
                                      TextStyle(fontSize: SizeConfig.text(12)),
                                ),
                                SizedBox(height: SizeConfig.height(1)),
                              ],
                            ),
                            trailing: Icon(
                              FontAwesomeIcons.pen,
                              size: SizeConfig.height(10),
                            ),
                            onTap: () => showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(15.0))),
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => buildPaddingChangeData(
                                    context,
                                    'masukan username',
                                    'number_house')),
                          ),
                    SizedBox(
                      height: SizeConfig.height(1),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.email,
                        size: SizeConfig.height(20),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: SizeConfig.height(1),
                          ),
                          Text(
                            'Email',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: SizeConfig.text(12)),
                          ),
                          SizedBox(
                            height: SizeConfig.height(1),
                          ),
                          Text(
                            '${snapshot.data.email}',
                            style: TextStyle(fontSize: SizeConfig.text(12)),
                          ),
                          SizedBox(
                            height: SizeConfig.height(1),
                          ),
                        ],
                      ),
                      trailing: Icon(
                        FontAwesomeIcons.pen,
                        size: SizeConfig.height(10),
                      ),
                      onTap: () => showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15.0))),
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => buildPaddingChangeData(
                              context, 'masukan email', 'email')),
                    ),
                    SizedBox(
                      height: SizeConfig.height(1),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.phone_android,
                        size: SizeConfig.height(20),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: SizeConfig.height(1),
                          ),
                          Text(
                            'Nomor telpon',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: SizeConfig.text(12),
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.height(1),
                          ),
                          Text(
                            '${snapshot.data.noPhone}',
                            style: TextStyle(fontSize: SizeConfig.text(12)),
                          ),
                          SizedBox(
                            height: SizeConfig.height(1),
                          ),
                        ],
                      ),
                      trailing: Icon(
                        FontAwesomeIcons.pen,
                        size: SizeConfig.height(10),
                      ),
                      onTap: () => showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15.0))),
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => buildPaddingChangeData(
                              context, 'masukan nomor telepon', 'phone')),
                    ),
                    SizedBox(
                      height: SizeConfig.height(1),
                    ),
                  ],
                )
              : LinearProgressIndicator(),
        ),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();

  Padding buildPaddingChangeData(
      BuildContext context, String label, String dataKolom) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: SizeConfig.height(1),
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: label,
                      ),
                      keyboardType: (dataKolom == 'phone')
                          ? TextInputType.number
                          : (dataKolom == 'email')
                              ? TextInputType.emailAddress
                              : TextInputType.text,
                      autofocus: true,
                      validator: (dataKolom == 'email')
                          ? (value) {
                              if (value.isEmpty) {
                                return 'email can\'t empty';
                              } else {
                                return ValidationForm.isValidEmail(value)
                                    ? null
                                    : 'email format does not match';
                              }
                            }
                          : (dataKolom == 'phone')
                              ? (value) {
                                  if (value.isEmpty) {
                                    return 'phone number can\'t empty';
                                  } else {
                                    return ValidationForm.isValidPhone(value)
                                        ? null
                                        : 'phone number format does not match';
                                  }
                                }
                              : (value) => (value.isEmpty)
                                  ? 'field can\'t be empty'
                                  : null),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text('Batal'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Simpan'),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          if (dataKolom == 'username') {
                            EasyLoading.show(status: 'loading');
                            String rs = await UserChangeServices.editData(
                              '${loginController.idUser}',
                              controller.text,
                              'username',
                            );
                            if (rs == 'OK') {
                              EasyLoading.dismiss();
                              Get.back();

                              setState(() {});
                              loginController.username.value = controller.text;
                              print(loginController.username.value);
                              status = 'refresh';
                            }
                          } else if (dataKolom == 'number_house') {
                            EasyLoading.show(status: 'loading');
                            String rs = await UserChangeServices.editData(
                                '${loginController.idUser}',
                                controller.text,
                                'number_house');
                            if (rs == 'OK') {
                              EasyLoading.dismiss();
                              Get.back();
                              loginController.houseNumber.value =
                                  controller.text;
                              setState(() {});
                              status = 'refresh';
                            }
                          } else if (dataKolom == 'email') {
                            EasyLoading.show(status: 'loading');
                            String rs = await UserChangeServices.editData(
                                '${loginController.idUser}',
                                controller.text,
                                'email');
                            if (rs == 'OK') {
                              EasyLoading.dismiss();
                              Get.back();
                              setState(() {});
                              loginController.email.value = controller.text;
                              status = 'refresh';
                            } else if (rs == 'email sudah digunakan') {
                              EasyLoading.showInfo('Email sudah digunakan');
                            }
                          } else if (dataKolom == 'phone') {
                            EasyLoading.show(status: 'loading');
                            String rs = await UserChangeServices.editData(
                                '${loginController.idUser}',
                                controller.text,
                                'phone');

                            if (rs == 'OK') {
                              EasyLoading.dismiss();
                              Get.back();
                              setState(() {});
                              loginController.noTelp.value = controller.text;
                              status = 'refresh';
                            } else if (rs == 'no telp sudah digunakan') {
                              EasyLoading.showInfo(
                                  'No telpon sudah terdaftar, silahkan menggunakan nomor lain');
                            }
                          }
                          controller.clear();
                        }
                      },
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: SizeConfig.height(1)),
        ],
      ),
    );
  }

  Future buildShowDialogAnimation(
      String title, String btnMessage, String urlAsset, double size) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              title,
              style: TextStyle(fontSize: 12.0.sp),
            ),
            insetPadding: EdgeInsets.all(10.0.h),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: SizedBox(
              width: size.w,
              height: size.h,
              child: LottieBuilder.asset(urlAsset),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(btnMessage),
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pop();
                  });
                },
              ),
            ],
          );
        });
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

  Future<void> getImage(ImageSource source) async {
    final pickedFile =
        await _picker.pickImage(source: source, imageQuality: 50);

    if (pickedFile != null) {
      String message = await UserChangeServices.changeFoto(
          '${loginController.idUser}', pickedFile.path);

      setState(() {
        widget.urlProfilePath = pickedFile.path;
        loginController.urlProfile.value = message;
      });

      status = 'refresh';
    }
  }
}

class UserChangeModel {
  String email;
  String username;
  String fullName;
  String noPhone;
  String cluster;
  String numberHouse;
  String profileImage;

  UserChangeModel(
      {this.email,
      this.username,
      this.fullName,
      this.noPhone,
      this.cluster,
      this.numberHouse,
      this.profileImage});
}

class UserChangeServices {
  static Future<UserChangeModel> getDataUser(String idUser) async {
    String url = '${ServerApp.url}src/user/user.php';

    String statusUser = await UserSecureStorage.getStatus();

    var data = {"id_user": idUser, "status_user": statusUser};
    var response = await http.post(Uri.parse(url), body: jsonEncode(data));
    if (response.statusCode >= 200 && response.body.isNotEmpty) {
      var result = jsonDecode(response.body);

      UserChangeModel model = UserChangeModel(
        email: result['email'],
        fullName: result['name'],
        cluster: result['cluster'],
        numberHouse: result['house_number'],
        noPhone: result['no_telp'],
        username: result['username'],
        profileImage: result['profile_image'],
      );
      return model;
    }
    return UserChangeModel();
  }

  static Future<String> editData(
      String idUser, String initData, String kolom) async {
    Dio dio = Dio();
    dio.interceptors.add(RetryInterceptor(dio: dio, retries: 100));
    String url = '${ServerApp.url}src/user/update_user.php';
    var data = {'id_user': idUser, 'kolom': kolom, 'data': initData};
    // http.Response response = await http.post(url, body: jsonEncode(data));
    var response = await dio.post(url, data: jsonEncode(data));
    var result = jsonDecode(response.data);
    final logger = Logger();
    logger.d(result);

    return result;
  }

  static Future<String> changeFoto(String idUser, String imgPath) async {
    String uri = '${ServerApp.url}/src/user/update_user.php';
    var request = http.MultipartRequest('POST', Uri.parse(uri));
    String message;

    if (imgPath != null && imgPath.isNotEmpty) {
      var pic = await http.MultipartFile.fromPath('image', imgPath);
      request.files.add(pic);
      request.fields['id_user'] = idUser;
      var req = await request.send();
      var resStream = await http.Response.fromStream(req);
      message = json.decode(resStream.body);
      return message;
    }
    return message;
  }
}
