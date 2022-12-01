import 'dart:io';
import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/screen/login_screen/validate/validate_email_and_password.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:flutter/material.dart';
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
          title: Text('Ganti data'),
          brightness: Brightness.light,
        ),
        body: FutureBuilder<UserChangeModel>(
            future: UserChangeServices.getDataUser('${loginController.idUser}'),
            builder: (context, snapshot) => (snapshot.hasData)
                ? Obx(
                    () => Column(
                      children: [
                        SizedBox(
                          height: 1.5.h,
                        ),
                        Center(
                          child: Stack(
                            children: [
                              GestureDetector(
                                child: Container(
                                    height: 15.0.h,
                                    width: 30.0.w,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.blue),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            repeat: ImageRepeat.noRepeat,
                                            image: (widget.urlProfilePath ==
                                                    null)
                                                ? NetworkImage(
                                                    '${ServerApp.url}${loginController.urlProfile}')
                                                : FileImage(File(
                                                    widget.urlProfilePath))))),
                                onTap: () => showModalBottomSheet(
                                    context: context,
                                    builder: ((builder) =>
                                        bottomImagePicker(context))),
                              ),
                              Positioned(
                                right: -2.7.w,
                                bottom: -1.5.h,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.image,
                                    color: Colors.blue[800],
                                  ),
                                  onPressed: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: ((builder) =>
                                            bottomImagePicker(context)));
                                  },
                                  iconSize: 5.0.h,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 3.0.h,
                        ),
                        ListTile(
                          leading: Icon(Icons.person),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 1.0.h),
                              Text(
                                'username',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 10.0.sp),
                              ),
                              SizedBox(height: 1.0.h),
                              Text('${loginController.username}'),
                              SizedBox(height: 1.0.h),
                            ],
                          ),
                          trailing: Icon(
                            FontAwesomeIcons.pen,
                            size: 2.0.h,
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
                        SizedBox(
                          height: 1.0.h,
                        ),
                        ListTile(
                          leading: Icon(Icons.email),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 1.0.h),
                              Text(
                                'email',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 10.0.sp),
                              ),
                              SizedBox(height: 1.0.h),
                              Text('${snapshot.data.email}'),
                              SizedBox(height: 1.0.h),
                            ],
                          ),
                          trailing: Icon(
                            FontAwesomeIcons.pen,
                            size: 2.0.h,
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
                          height: 1.0.h,
                        ),
                        ListTile(
                          leading: Icon(Icons.phone_android),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 1.0.h),
                              Text(
                                'nomor telpon',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 10.0.sp),
                              ),
                              SizedBox(height: 1.0.h),
                              Text('${snapshot.data.noPhone}'),
                              SizedBox(height: 1.0.h),
                            ],
                          ),
                          trailing: Icon(
                            FontAwesomeIcons.pen,
                            size: 2.0.h,
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
                          height: 1.0.h,
                        ),
                      ],
                    ),
                  )
                : Center(child: CircularProgressIndicator())),
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
            height: 1.0.h,
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
                            buildShowDialogAnimation('', '',
                                'assets/animation/loading-plane.json', 2.0.h);
                            String rs = await UserChangeServices.editData(
                                '${loginController.idUser}',
                                controller.text,
                                'username');
                            if (rs == 'OK') {
                              Navigator.of(context)
                                ..pop()
                                ..pop();
                              setState(() {});
                              loginController.username = controller.text.obs;
                              print(loginController.username.value);
                              status = 'refresh';
                            }
                          } else if (dataKolom == 'fullname') {
                            String rs = await UserChangeServices.editData(
                                '${loginController.idUser}',
                                controller.text,
                                'fullname');
                            if (rs == 'OK') {
                              Navigator.of(context).pop();
                              setState(() {});
                              status = 'refresh';
                            }
                          } else if (dataKolom == 'email') {
                            String rs = await UserChangeServices.editData(
                                '${loginController.idUser}',
                                controller.text,
                                'email');
                            if (rs == 'OK') {
                              Navigator.of(context)..pop();
                              setState(() {});
                              status = 'refresh';
                            } else if (rs == 'email sudah digunakan') {
                              buildShowDialogAnimation(
                                  'email sudah digunakan',
                                  'OKE',
                                  'assets/animation/error-orange-animation.json',
                                  2.0.h);
                            }
                          } else if (dataKolom == 'phone') {
                            String rs = await UserChangeServices.editData(
                                '${loginController.idUser}',
                                controller.text,
                                'phone');
                            if (rs == 'OK') {
                              loginController.username = controller.text.obs;
                              Navigator.of(context).pop();
                              setState(() {});
                              status = 'refresh';
                            } else if (rs == 'no telp sudah digunakan') {
                              buildShowDialogAnimation(
                                  'no telpon sudah digunakan',
                                  'OKE',
                                  'assets/animation/error-orange-animation.json',
                                  2.0.h);
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
          SizedBox(height: 1.0.h),
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
        height: 18.0.h,
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
    final pickedFile = await _picker.getImage(source: source, imageQuality: 50);

    if (pickedFile != null) {
      setState(() {
        widget.urlProfilePath = pickedFile.path;
      });
      String message = await UserChangeServices.changeFoto(
          '${loginController.idUser}', pickedFile.path);
      loginController.urlProfile = message.obs;
      final logger = Logger();
      logger.w(message);
      status = 'refresh';
    }
  }
}

class UserChangeModel {
  String email;
  String username;
  String fullname;
  String noPhone;

  UserChangeModel({this.email, this.username, this.fullname, this.noPhone});
}

class UserChangeServices {
  static Future<UserChangeModel> getDataUser(String idUser) async {
    String url = '${ServerApp.url}src/user/user.php';
    var data = {"id_user": idUser};
    var response = await http.post(Uri.parse(url), body: jsonEncode(data));
    if (response.statusCode >= 200 && response.body.isNotEmpty) {
      var result = jsonDecode(response.body);
      print(result['username']);
      UserChangeModel model = UserChangeModel(
          email: result['email'],
          fullname: result['fullname'],
          noPhone: result['no_telp'],
          username: result['username']);
      return model;
    }
    return UserChangeModel();
  }

  static Future<String> editData(
      String idUser, String initData, String kolom) async {
    // Dio dio = Dio();
    // dio.interceptors.add(RetryOnConnectionChangeInterceptor(
    //   requestRetrier: DioConnectivityRequestRetrier(
    //     dio: dio,
    //     connectivity: Connectivity(),
    //   ),
    // ));
    String url = '${ServerApp.url}src/user/update_user.php';
    var data = {'id_user': idUser, 'kolom': kolom, 'data': initData};
    // http.Response response = await http.post(url, body: jsonEncode(data));
    var response = await http.post(Uri.parse(url), body: jsonEncode(data));
    var result = jsonDecode(response.body);
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
