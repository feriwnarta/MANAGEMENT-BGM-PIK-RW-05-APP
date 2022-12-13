import 'dart:convert';

import 'package:aplikasi_rw/controller/indexscreen_home_controller.dart';
import 'package:aplikasi_rw/controller/report_user_controller.dart';
import 'package:aplikasi_rw/model/category_model.dart';
import 'package:aplikasi_rw/screen/report_screen2/controller/write_page_controller.dart';
import 'package:aplikasi_rw/screen/report_screen2/google_maps_screen.dart';
import 'package:aplikasi_rw/screen/report_screen2/new_google_maps_screen.dart';
import 'package:aplikasi_rw/services/category_services.dart';
import 'package:aplikasi_rw/services/klasifikasi_category_services.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart' as sidio;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';

import '../../server-app.dart';
import 'package:aplikasi_rw/screen/loading_send_screen.dart';

enum RadioComplaint { Anonim, Rahasia }

class StepperController extends GetxController {
  RxInt index = 0.obs;
}

class AddComplaint extends StatefulWidget {
  AddComplaint({Key key}) : super(key: key);

  @override
  State<AddComplaint> createState() => _AddComplaintState();
}

class _AddComplaintState extends State<AddComplaint> {
  Duration duration;

  @override
  void initState() {
    super.initState();

    duration = Duration(hours: 1);
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Buat Laporan',
            style: TextStyle(
              fontSize: 19.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: StepperRw(duration: duration));
  }
}

class StepperRw extends StatefulWidget {
  StepperRw({Key key, this.duration}) : super(key: key);

  Duration duration;

  @override
  _StepperRwState createState() => _StepperRwState();
}

class _StepperRwState extends State<StepperRw> {
  var _radio = RadioComplaint.Anonim.obs;
  RxString selectDate = ''.obs, selectLoc = ''.obs, imagePath = ''.obs;
  FToast fToast;
  WritePageController controllerWrite;
  final GlobalKey<FormState> _formKeyContent = GlobalKey<FormState>();
  RxBool isSelected = false.obs;
  var selectedIndex = <String>[].obs;
  var klasifikasiPicked = <String>[].obs;
  var nameKlasifikasi = <String>[].obs;
  var idCategory = ''.obs;
  var nameCategory = ''.obs;
  final _picker = ImagePicker();
  StepperController stepperController;
  RxList<Map<String, dynamic>> idKlasifikasi = <Map<String, dynamic>>[].obs;
  sidio.Dio dio;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    widget.duration = Duration(hours: 1);
    // dio = sidio.Dio();
    // dio.interceptors.add(RetryOnConnectionChangeInterceptor(
    //   requestRetrier: DioConnectivityRequestRetrier(
    //     dio: dio,
    //     connectivity: Connectivity(),
    //   ),
    // ));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showToast();
    });
    stepperController = Get.put(StepperController());
    controllerWrite = Get.put(WritePageController());
  }

  final logger = Logger();

  @override
  dispose() {
    widget.duration = Duration(seconds: 0);
    fToast.removeCustomToast();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (stepperController.index.value == 2) {
          stepperController.index.value--;
          selectedIndex.clear();
          return false;
        } else if (stepperController.index.value == 1) {
          stepperController.index.value--;
          selectedIndex.clear();
          isSelected.value = false;
          return false;
        } else {
          return true;
        }
      },
      child: SingleChildScrollView(
          child: GetX<StepperController>(
        init: StepperController(),
        builder: (controller) => Column(
          children: [
            stepper(stepperController: controller),
            IndexedStack(
              index: controller.index.value,
              children: [
                writePage(steperController: controller, toast: fToast),
                selectCategory(controller),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 16.h),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                              'assets/img/image-svg/information-circle.svg'),
                          SizedBox(
                            width: 8.w,
                          ),
                          Row(
                            children: [
                              Text(
                                'Laporan ini bersifat ',
                                style: TextStyle(
                                  color: Color(0xffC2C2C2),
                                ),
                              ),
                              Text('${controllerWrite.type.value}')
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(thickness: 2),
                    Container(
                      height: 436.h,
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16.h),
                            Text(
                              '${controllerWrite.controllerTitleReport.text}',
                              style: TextStyle(
                                fontSize: 19.sp,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 16.h),
                            Container(
                              width: 70.w,
                              height: 70.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: (imagePath.value.isEmpty)
                                  ? SizedBox()
                                  : Image.asset(
                                      imagePath.value,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            SizedBox(height: 16.h),
                            Container(
                              // margin: EdgeInsets.symmetric(horizontal: 16.w),
                              width: 328.w,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/img/image-svg/location-2.svg',
                                    color: Color(0xffC2C2C2),
                                  ),
                                  SizedBox(width: 4.w),
                                  Expanded(
                                    child: Text(
                                      '${selectLoc.value}',
                                      style: TextStyle(
                                        color: Color(0xff9E9E9E),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.w),
                            Text(
                              '${nameCategory.value}',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Row(
                              children: [
                                Text('Keluhan',
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Color(0xff616161))),
                                SizedBox(width: 200.w),
                                Text(
                                  'Date',
                                  style: TextStyle(
                                    color: Color(0xff616161),
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Obx(
                              () => (stepperController.index.value == 2)
                                  ? ListView.builder(
                                      itemCount: selectedIndex.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              size: 6,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(width: 5.w),
                                            SizedBox(
                                              child: Text(
                                                '${selectedIndex[index]}',
                                                style: TextStyle(
                                                  color: Color(0xff9E9E9E),
                                                  fontSize: 14.sp,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              width: 140.w,
                                            ),
                                            (index == 0)
                                                ? Row(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(width: 16.w),
                                                          Icon(
                                                            Icons.circle,
                                                            size: 6,
                                                            color: Colors.grey,
                                                          ),
                                                          SizedBox(width: 5.w),
                                                          SizedBox(
                                                            width: 150.w,
                                                            child: Text(
                                                              '${selectDate.value}aaaaa',
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xff9E9E9E),
                                                                fontSize: 14.sp,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                : Text('')
                                          ],
                                        );
                                      },
                                    )
                                  : SizedBox(),
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            Text(
                              'Deskripsi Problem',
                              style: TextStyle(
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            TextField(
                              enabled: false,
                              decoration: InputDecoration(
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xffE0E0E0),
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 55.h,
                                  horizontal: 5.w,
                                ),
                                hintMaxLines: 5,
                                hintText: controllerWrite
                                    .controllerContentReport.text,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      width: 328.w,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          foregroundColor: Color(0xff2094F3),
                        ),
                        onPressed: () async {
                          /**
                           ** ini digunakan untuk mencari id klasifikasi berdasrkan label yang di ceklis
                           */
                          // List<String> idPicked = [];
                          String stringKlasifikasi = '';

                          selectedIndex.forEach((element) {
                            for (int i = 0; i <= idKlasifikasi.length; i++) {
                              if (idKlasifikasi[i].containsKey(element)) {
                                idKlasifikasi[i]
                                    .entries
                                    .forEach((idKlasifikasi) {
                                  // idPicked.add(idKlasifikasi.value);
                                  stringKlasifikasi +=
                                      idKlasifikasi.value + ',';
                                });
                                break;
                              }
                            }
                          });

                          String idUser = await UserSecureStorage.getIdUser();
                          String uri =
                              '${ServerApp.url}/src/report/add_report.php';
                          final sidio.FormData formData =
                              sidio.FormData.fromMap({
                            'image': await sidio.MultipartFile.fromFile(
                              imagePath.value,
                              filename: imagePath.value,
                              contentType: new MediaType("image", "jpeg"),
                            ),
                            'category': nameCategory.value,
                            'id_category': idCategory.value,
                            'latitude': controllerWrite.latitude.value,
                            'longitude': controllerWrite.longitude.value,
                            'address': controllerWrite.address.value,
                            'description':
                                controllerWrite.controllerContentReport.text,
                            'status': 'listed',
                            'id_klasifikasi_category': stringKlasifikasi,
                            'id_user': idUser,
                            'type': controllerWrite.type.value
                          });
                          showLoading(context);
                          var response = await dio.post(uri, data: formData);
                          String m = jsonDecode(response.data);
                          if (m != null && m.isNotEmpty) {
                            Navigator.of(context).pop();
                            buildShowDialogAnimation(
                                'Laporan Berhasil Dikirim',
                                '',
                                'assets/animation/succes-animation.json',
                                100.h);
                            await Future.delayed(Duration(milliseconds: 1350));
                            final indexHome =
                                Get.put(IndexScreenHomeController());
                            final reportController =
                                Get.put(ReportUserController());
                            reportController.refresReport();
                            reportController.update();
                            indexHome.index.value = 1;

                            Get
                              ..back()
                              ..back()
                              ..back();
                          }

                          // ReportServices.sendDataReport(
                          //         description: controllerWrite
                          //             .controllerContentReport.text,
                          //         category: nameCategory.value,
                          //         idCategory: idCategory.value,
                          //         latitude: controllerWrite.latitude.value,
                          //         longitude: controllerWrite.longitude.value,
                          //         address: controllerWrite.address.value,
                          //         status: 'listed',
                          //         idKlasifikasiCategory: stringKlasifikasi,
                          //         idUser: idUser,
                          //         imgPath: imagePath.value,
                          //         type: controllerWrite.type.value)
                          //     .then((res) {
                          //   showLoading(context);
                          //   res.send().then((value) {
                          //     http.Response.fromStream(value).then((val) async {
                          //       String m = jsonDecode(val.body);
                          //       if (m != null && m.isNotEmpty) {
                          //         Navigator.of(context).pop();
                          //         buildShowDialogAnimation(
                          //             'Laporan Berhasil Dikirim',
                          //             '',
                          //             'assets/animation/succes-animation.json',
                          //             100.h);
                          //         await Future.delayed(
                          //             Duration(milliseconds: 1350));
                          //         final indexHome =
                          //             Get.put(IndexScreenHomeController());
                          //         final reportController =
                          //             Get.put(ReportUserController());
                          //         reportController.refresReport();
                          //         reportController.update();
                          //         indexHome.index.value = 1;

                          //         Get..back()..back()..back();
                          //       }
                          //     });
                          //   });
                          // });
                        },
                        child: Text(
                          'Kirim Laporan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      )),
    );
  }

  Obx selectCategory(StepperController controller) {
    return Obx(
      () => (isSelected.value)
          ? FutureBuilder<List<KlasifikasiCategory>>(
              future: KlasifikasiCategoryServices.getKlasifikasiCategory2(
                  idCategory.value),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Container(
                        child: Center(child: CircularProgressIndicator()));
                    break;
                  case ConnectionState.done:
                    return Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                          height: 500.h,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${nameCategory.value}',
                                  style: TextStyle(
                                    fontSize: 19.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                ...snapshot.data.map<Widget>(
                                  (data) => ExpansionTile(
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          size: 8,
                                        ),
                                        SizedBox(width: 5.w),
                                        Expanded(
                                          child: Text(
                                            '${data.name}',
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff616161),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    children: [
                                      CheckboxGroup(
                                        labelStyle: TextStyle(
                                          fontSize: 14.sp,
                                          color: Color(0xff757575),
                                        ),
                                        checked: selectedIndex,
                                        labels: data.dataKlasifikasi
                                            .map<String>((e) {
                                          idKlasifikasi.add(
                                            {
                                              e['name_klasifikasi']:
                                                  e['id_klasifikasi']
                                            },
                                          );
                                          return e['name_klasifikasi'];
                                        }).toList(),
                                        onChange: (isChecked, label, index) {
                                          if (isChecked) {
                                            selectedIndex.add(label);
                                          } else {
                                            selectedIndex.remove(label);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 328.w,
                          height: 40.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              foregroundColor: Colors.blue,
                            ),
                            onPressed: () {
                              if (selectedIndex.isEmpty) {
                                print('asdas');
                                errorToast(
                                    error:
                                        'silahkan ceklis salah satu masalah');
                              } else {
                                controller.index.value++;
                              }
                            },
                            child: Text(
                              'Selanjutnya',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                    break;
                  default:
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                }
                return Container();
              })
          : Column(
              children: [
                SizedBox(height: 16.h),
                Container(
                  height: 400.h,
                  child: FutureBuilder<List<CategoryModel>>(
                      future: CategoryServices.getCategory(),
                      builder: (_, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Container(
                                child:
                                    Center(child: CircularProgressIndicator()));
                          case ConnectionState.done:
                            return Container(
                              margin: EdgeInsets.all(16.w / 16.h),
                              child: gridViewCategory(snapshot.data),
                            );
                          default:
                            if (snapshot.hasError)
                              return new Text('Error: ${snapshot.error}');
                            return Container(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                        }
                      }),
                ),
              ],
            ),
    );
  }

  GridView gridViewCategory(List<CategoryModel> category) {
    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: .15 / .12,
      children: category
          .map<Widget>(
            (e) => GestureDetector(
              child: Column(
                children: [
                  SizedBox(
                    width: 60.w,
                    height: 60.h,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CachedNetworkImage(
                          imageUrl: '${ServerApp.url}/icon/${e.icon}',
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '${e.category}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.clip,
                  ),
                ],
              ),
              onTap: () {
                idCategory.update((val) {
                  idCategory = e.idCategory.obs;
                });
                nameCategory.update((val) {
                  nameCategory = e.category.obs;
                });
                isSelected.update((val) {
                  isSelected = true.obs;
                });
              },
            ),
          )
          .toList(),
    );
  }

  Column stepper({StepperController stepperController}) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              headerSteper(
                  stepIcon: 'assets/img/image-svg/step-tulis.svg',
                  text: 'Tulis',
                  colorText: stepperController.index.value == 0
                      ? Colors.blue
                      : Colors.blue,
                  colorIcon: stepperController.index.value == 0
                      ? Colors.blue
                      : Colors.blue,
                  colorChevron: (stepperController.index.value == 0)
                      ? Colors.grey
                      : Colors.blue),
              SizedBox(width: 8.w),
              headerSteper(
                  stepIcon: 'assets/img/image-svg/step-kategori.svg',
                  text: 'Kategori',
                  colorText: stepperController.index.value != 0
                      ? Colors.blue
                      : Color(0xffC2C2C2),
                  colorIcon: stepperController.index.value != 0
                      ? Colors.blue
                      : Color(0xffC2C2C2),
                  colorChevron: stepperController.index.value == 2
                      ? Colors.blue
                      : Colors.grey),
              SizedBox(width: 8.w),
              headerSteper(
                status: 'last',
                stepIcon: 'assets/img/image-svg/step-tinjau.svg',
                text: 'Tinjau',
                colorText: stepperController.index.value == 2
                    ? Colors.blue
                    : Color(0xffC2C2C2),
                colorIcon: stepperController.index.value == 2
                    ? Colors.blue
                    : Color(0xffC2C2C2),
              ),
            ],
          ),
        ),
        Divider(
          color: Color(0xffE0E0E0),
          thickness: 2,
        ),
      ],
    );
  }

  Form writePage({StepperController steperController, FToast toast}) {
    return Form(
      key: _formKeyContent,
      child: Column(
        children: [
          Container(
            height: 555.h,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: controllerWrite.controllerTitleReport,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffE0E0E0),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xffE0E0E0),
                        ),
                      ),
                      hintText: 'Ketik judul laporan anda',
                      contentPadding: EdgeInsets.only(
                        right: 23.w,
                        left: 23.w,
                        bottom: 22.h,
                        top: 13.h,
                      ),
                      hintStyle:
                          TextStyle(color: Colors.black, fontSize: 14.sp),
                    ),
                    validator: (value) => (value.length > 0)
                        ? null
                        : 'judul laporan tidak boleh kosong',
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 18.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 147.h,
                          child: TextFormField(
                            controller: controllerWrite.controllerContentReport,
                            maxLines: 7,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              hintText: 'Ketik isi laporan anda',
                              hintStyle: TextStyle(
                                  color: Colors.grey, fontSize: 14.sp),
                            ),
                            validator: (value) => (value.length > 0)
                                ? null
                                : 'isi laporan tidak boleh kosong',
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            SvgPicture.asset(
                                'assets/img/image-svg/mark-question.svg'),
                            SizedBox(width: 4.w),
                            Text(
                              'Perhatikan cara penyampaian laporan yang baik\ndan benar',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        SizedBox(
                          height: 30.h,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/img/image-svg/tanggal-kejadian.svg',
                                    ),
                                    SizedBox(width: 8.w),
                                    Obx(
                                      () => Text(
                                        (selectDate.value.isEmpty)
                                            ? 'Tanggal kejadian'
                                            : selectDate.value,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.black,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                onTap: () async {
                                  FocusScope.of(context).unfocus();
                                  var datePicked =
                                      await DatePicker.showSimpleDatePicker(
                                          context,
                                          titleText: '',
                                          cancelText: 'Batal',
                                          confirmText: 'Oke',
                                          firstDate: DateTime(1960),
                                          dateFormat: 'dd-MMMM-yyyy',
                                          locale: DateTimePickerLocale.id,
                                          reverse: true,
                                          looping: true);

                                  if (datePicked != null) {
                                    String formated =
                                        DateFormat("EEEE, d MMMM yyyy", "id_ID")
                                            .format(datePicked);

                                    selectDate.update((val) {
                                      selectDate = formated.obs;
                                    });

                                    controllerWrite.date = formated.obs;
                                  } else {
                                    DateTime time = DateTime.now();
                                    String formated =
                                        DateFormat("EEEE, d MMMM yyyy", "id_ID")
                                            .format(time);
                                    selectDate.update((val) {
                                      selectDate = formated.obs;
                                    });

                                    controllerWrite.date = formated.obs;
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        SizedBox(
                          height: 30.h,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/img/image-svg/location-marker-complaint.svg',
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Text(
                                        (selectLoc.isEmpty)
                                            ? 'Pilih lokasi kejadian'
                                            : selectLoc.value,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.black,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  fToast.removeCustomToast();
                                  Get.to<Map<String, dynamic>>(
                                      () => NewGoogleMaps()).then((value) {
                                    if (value != null) {
                                      String address = value['data'];
                                      selectLoc.update((val) {
                                        selectLoc = address.obs;
                                      });
                                      showToast();

                                      String latitude =
                                          value['latitude'].toString();
                                      String longitude =
                                          value['longitude'].toString();
                                      controllerWrite.address = address.obs;
                                      controllerWrite.latitude = latitude.obs;
                                      controllerWrite.longitude = longitude.obs;
                                      logger.w(controllerWrite.latitude.value);
                                      logger.w(controllerWrite.longitude.value);
                                      logger.w(controllerWrite.address.value);
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 105.h),
                  Divider(
                    color: Color(0xffE0E0E0),
                    thickness: 2,
                  ),
                  Obx(
                    () => IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 170.w,
                            child: RadioListTile<RadioComplaint>(
                              dense: true,
                              title: Text(
                                'Anonim',
                                style: TextStyle(fontSize: 14.sp),
                              ),
                              groupValue: _radio.value,
                              value: RadioComplaint.Anonim,
                              selected: false,
                              onChanged: (value) {
                                FocusScope.of(context).unfocus();
                                _radio.update((val) {
                                  _radio = value.obs;
                                });
                                controllerWrite.type = describeEnum(value).obs;
                              },
                            ),
                          ),
                          VerticalDivider(
                              thickness: 2, color: Color(0xffE0E0E0)),
                          SizedBox(
                            width: 170.w,
                            child: RadioListTile<RadioComplaint>(
                              title: Text(
                                'Rahasia',
                                style: TextStyle(fontSize: 14.sp),
                              ),
                              groupValue: _radio.value,
                              value: RadioComplaint.Rahasia,
                              selected: false,
                              onChanged: (value) {
                                _radio.update((val) {
                                  this._radio = value.obs;
                                });
                                controllerWrite.type = describeEnum(value).obs;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 2,
                  ),
                ],
              ),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            IconButton(
              splashRadius: 20,
              icon:
                  SvgPicture.asset('assets/img/image-svg/camera-complaint.svg'),
              onPressed: () async {
                FocusScope.of(context).unfocus();
                await getImage(ImageSource.camera);
              },
            ),
            SizedBox(width: 200.w),
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                foregroundColor: Color(0xff2094F3),
              ),
              onPressed: () {
                // steperController.index.value++;
                fToast.removeCustomToast();
                // errorToast(error: 'lokasi harus dipilih');
                // showToast();

                if (imagePath.value.isEmpty &&
                    controllerWrite.address.value.isEmpty) {
                  errorToast(error: 'lokasi dan gambar harus dipilih');
                } else {
                  if (imagePath.value.isEmpty) {
                    errorToast(error: 'gambar harus dipilih');
                  }

                  if (controllerWrite.address.value.isEmpty) {
                    errorToast(error: 'lokasi harus dipilih');
                  }
                }

                if (_formKeyContent.currentState.validate() &&
                    imagePath.value.isNotEmpty) {
                  /**
                   * * UPDATE DATE TIME OTOMATIS BERDASARKAN HARI INI
                   */
                  DateTime time = DateTime.now();
                  String formated =
                      DateFormat("EEEE, d MMMM yyyy", "id_ID").format(time);
                  selectDate.update((val) {
                    selectDate = formated.obs;
                  });
                  controllerWrite.date = formated.obs;

                  if (controllerWrite.date.value.isNotEmpty) {
                    logger.w('test');

                    if (controllerWrite.address.value.isNotEmpty) {
                      steperController.index.value++;
                      fToast.removeCustomToast();
                    }
                  }
                } else {
                  DateTime time = DateTime.now();
                  String formated =
                      DateFormat("EEEE, d MMMM yyyy", "id_ID").format(time);
                  selectDate.update((val) {
                    selectDate = formated.obs;
                  });
                  controllerWrite.date = formated.obs;
                  showToast();
                }
              },
              child: Text(
                'Lanjutkan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
            )
          ])
        ],
      ),
    );
  }

  Row headerSteper(
      {String stepIcon,
      String text,
      Color colorText,
      Color colorIcon,
      Color colorChevron,
      String status}) {
    return Row(
      children: [
        SvgPicture.asset(
          stepIcon,
          color: colorIcon,
        ),
        SizedBox(width: 8.w),
        Text(
          text,
          style: TextStyle(fontSize: 16.sp, color: colorText),
        ),
        SizedBox(width: 8.w),
        (status == 'last')
            ? SizedBox()
            : SvgPicture.asset(
                'assets/img/image-svg/chevron-left.svg',
                color: colorChevron,
              ),
      ],
    );
  }

  void showToast() {
    Widget toast = Obx(() => Container(
          height: 36.h,
          width: 288.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            color: Color(0xff9E9E9E),
          ),
          child: Center(
              child: Text(
            (_radio.value == RadioComplaint.Anonim
                ? 'Nama anda bersifat rahasia'
                : 'Nama dan laporan anda bersifat rahasia'),
            style: TextStyle(
              color: Color(0xffE0E0E0),
              fontSize: 14.sp,
            ),
          )),
        ));

    // Custom Toast Position
    fToast.showToast(
      child: toast,
      toastDuration: widget.duration,
      positionedToastBuilder: (context, child) {
        return Positioned(
          child: child,
          bottom: 182.h,
          left: 36.w,
        );
      },
    );
  }

  void errorToast({String error}) {
    Widget toast = Container(
      height: 36.h,
      width: 288.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        color: Colors.redAccent,
      ),
      child: Center(
          child: Text(
        error,
        style: TextStyle(
          color: Color(0xffE0E0E0),
          fontSize: 14.sp,
        ),
      )),
    );

    // Custom Toast Position
    fToast.showToast(
      child: toast,
      toastDuration: Duration(seconds: 2),
      // positionedToastBuilder: (context, child) {
      //   return Positioned(
      //     child: child,
      //     bottom: 158.h,
      //     left: 36.w,
      //   );
      // },
      gravity: ToastGravity.CENTER,
    );
  }

  Future getImage(ImageSource source) async {
    var pickedFile = await _picker.getImage(source: source, imageQuality: 50);
    if (pickedFile != null) {
      imagePath = pickedFile.path.obs;
    }
  }

  Future buildShowDialogAnimation(
      String title, String btnMessage, String urlAsset, double size) {
    return showDialog(
        barrierDismissible: false,
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
}
