import 'dart:convert';
import 'dart:io';
import 'package:aplikasi_rw/controller/report_user_controller.dart';
import 'package:aplikasi_rw/model/category_model.dart';
import 'package:aplikasi_rw/modules/report_screen/controllers/write_page_controller.dart';
import 'package:aplikasi_rw/modules/report_screen/screens/new_google_maps_screen.dart';
import 'package:aplikasi_rw/modules/report_screen/widgets/camera_complaint.dart';
import 'package:aplikasi_rw/modules/theme/sizer.dart';
import 'package:aplikasi_rw/services/category_services.dart';
import 'package:aplikasi_rw/services/klasifikasi_category_services.dart';
import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
import 'package:aplikasi_rw/utils/screen_size.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart' as sidio;
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

import '../../../server-app.dart';

enum RadioComplaint { Anonim, Rahasia }

class StepperController extends GetxController {
  RxInt index = 0.obs;
  RxString imagePath = ''.obs;
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
    ScreenSize.designSize(context);
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle,
          title: Text(
            'Buat Laporan',
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
        ),
        body: StepperRw(duration: duration));
  }
}

//ignore: must_be_immutable
class StepperRw extends StatefulWidget {
  StepperRw({Key key, this.duration}) : super(key: key);

  Duration duration;

  @override
  _StepperRwState createState() => _StepperRwState();
}

class _StepperRwState extends State<StepperRw> {
  var _radio = RadioComplaint.Anonim.obs;
  RxString selectDate = ''.obs,
      selectLoc = ''.obs,
      imagePath = ''.obs,
      whenLocationEmpty = ''.obs;
  RxString mapsClicked = 'false'.obs;
  FToast fToast;
  FToast fToastOnWritePage;
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

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToastOnWritePage = FToast();
    fToastOnWritePage.init(context);
    fToast.init(context);
    stepperController = Get.put(StepperController());
    controllerWrite = Get.put(WritePageController());
  }

  final logger = Logger();

  @override
  dispose() {
    fToast.removeCustomToast();
    Get.delete<StepperController>();
    Get.delete<WritePageController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize.designSize(context);
    return WillPopScope(
      onWillPop: () async {
        if (stepperController.index.value == 3) {
          stepperController.index.value--;
          selectedIndex.clear();
          return false;
        } else if (stepperController.index.value == 2) {
          stepperController.index.value--;
          selectedIndex.clear();
          isSelected.value = false;
          return false;
        } else if (stepperController.index.value == 1) {
          stepperController.index.value--;
          return false;
          // gambar
        } else {
          imagePath.value = '';
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
                selectCategory(controller),
                Column(
                  children: [
                    CameraComplaint(toast: showToast),
                  ],
                ),
                writePage(steperController: controller, toast: fToast),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: (16 / Sizer.slicingWidth) *
                              SizeConfig.widthMultiplier,
                          vertical: (16 / Sizer.slicingHeight) *
                              SizeConfig.heightMultiplier),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                              'assets/img/image-svg/information-circle.svg'),
                          SizedBox(
                            width: (8 / Sizer.slicingWidth) *
                                SizeConfig.widthMultiplier,
                          ),
                          Row(
                            children: [
                              Text(
                                'Laporan ini bersifat ',
                                style: TextStyle(
                                  color: Color(0xffC2C2C2),
                                  fontSize: SizeConfig.text(16),
                                ),
                              ),
                              Text(
                                '${controllerWrite.type.value}',
                                style: TextStyle(
                                  fontSize: SizeConfig.text(16),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(thickness: 2),
                    Container(
                      height: (436 / Sizer.slicingHeight) *
                          SizeConfig.heightMultiplier,
                      margin: EdgeInsets.symmetric(
                        horizontal: (16 / Sizer.slicingWidth) *
                            SizeConfig.widthMultiplier,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: (70 / Sizer.slicingWidth) *
                                  SizeConfig.widthMultiplier,
                              height: (70 / Sizer.slicingHeight) *
                                  SizeConfig.heightMultiplier,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: (stepperController.imagePath.value.isEmpty)
                                  ? SizedBox()
                                  : Image(
                                      image: FileImage(File(
                                          stepperController.imagePath.value))),
                            ),
                            SizedBox(
                              height: (16 / Sizer.slicingHeight) *
                                  SizeConfig.heightMultiplier,
                            ),
                            Container(
                              // margin: EdgeInsets.symmetric(horizontal: 16.w),
                              width: (328 / Sizer.slicingWidth) *
                                  SizeConfig.widthMultiplier,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/img/image-svg/location-2.svg',
                                    color: Color(0xffC2C2C2),
                                  ),
                                  SizedBox(
                                      width: (4 / Sizer.slicingWidth) *
                                          SizeConfig.widthMultiplier),
                                  Expanded(
                                    child: Text(
                                      '${selectLoc.value}',
                                      style: TextStyle(
                                          color: Color(0xff9E9E9E),
                                          fontSize: SizeConfig.text(12)),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                                height: (16 / Sizer.slicingHeight) *
                                    SizeConfig.heightMultiplier),
                            Text(
                              '${nameCategory.value}',
                              style: TextStyle(
                                fontSize: SizeConfig.text(16),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                                height: (12 / Sizer.slicingHeight) *
                                    SizeConfig.heightMultiplier),
                            Row(
                              children: [
                                Text('Keluhan',
                                    style: TextStyle(
                                        fontSize: SizeConfig.text(14),
                                        color: Color(0xff616161))),
                                SizedBox(width: 200.w),
                                Text(
                                  'Date',
                                  style: TextStyle(
                                    color: Color(0xff616161),
                                    fontSize: SizeConfig.text(14),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                height: (12 / Sizer.slicingHeight) *
                                    SizeConfig.heightMultiplier),
                            Obx(
                              () => (stepperController.index.value == 3)
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
                                              size: (6 / Sizer.slicingImage) *
                                                  SizeConfig
                                                      .imageSizeMultiplier,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(
                                                width: (5 /
                                                        Sizer.slicingWidth) *
                                                    SizeConfig.widthMultiplier),
                                            SizedBox(
                                              child: Text(
                                                '${selectedIndex[index]}',
                                                style: TextStyle(
                                                  color: Color(0xff9E9E9E),
                                                  fontSize: SizeConfig.text(14),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              width: (140 /
                                                      Sizer.slicingWidth) *
                                                  SizeConfig.widthMultiplier,
                                            ),
                                            (index == 0)
                                                ? Row(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                              width: (16 /
                                                                      Sizer
                                                                          .slicingWidth) *
                                                                  SizeConfig
                                                                      .widthMultiplier),
                                                          Icon(
                                                            Icons.circle,
                                                            size: (6 /
                                                                    Sizer
                                                                        .slicingImage) *
                                                                SizeConfig
                                                                    .imageSizeMultiplier,
                                                            color: Colors.grey,
                                                          ),
                                                          SizedBox(
                                                              width: (5 /
                                                                      Sizer
                                                                          .slicingWidth) *
                                                                  SizeConfig
                                                                      .widthMultiplier),
                                                          SizedBox(
                                                            width: (150 /
                                                                    Sizer
                                                                        .slicingWidth) *
                                                                SizeConfig
                                                                    .widthMultiplier,
                                                            child: Text(
                                                              '${selectDate.value}',
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xff9E9E9E),
                                                                fontSize:
                                                                    SizeConfig
                                                                        .text(
                                                                            14),
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
                              height: (16 / Sizer.slicingHeight) *
                                  SizeConfig.heightMultiplier,
                            ),
                            Text(
                              'Catatan',
                              style: TextStyle(
                                fontSize: SizeConfig.text(14),
                              ),
                            ),
                            SizedBox(
                                height: (4 / Sizer.slicingHeight) *
                                    SizeConfig.heightMultiplier),
                            TextField(
                              enabled: false,
                              decoration: InputDecoration(
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xffE0E0E0),
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: (55 / Sizer.slicingHeight) *
                                      SizeConfig.heightMultiplier,
                                  horizontal: (5 / Sizer.slicingWidth) *
                                      SizeConfig.widthMultiplier,
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
                    SizedBox(
                        height: (20 / Sizer.slicingHeight) *
                            SizeConfig.heightMultiplier),
                    SizedBox(
                      width: (328 / Sizer.slicingWidth) *
                          SizeConfig.widthMultiplier,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          backgroundColor: Color(0xff2094F3),
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

                          if (stepperController.imagePath.value.isNotEmpty) {
                            sidio.Dio dio = sidio.Dio();

                            String idUser = await UserSecureStorage.getIdUser();
                            String uri =
                                '${ServerApp.url}/src/report/add_report.php';
                            final sidio.FormData formData =
                                sidio.FormData.fromMap({
                              'image': MultipartFileRecreatable.fromFileSync(
                                stepperController.imagePath.value,
                                filename: stepperController.imagePath.value,
                                contentType: new MediaType("image", "jpeg"),
                              ),
                              'category': nameCategory.value,
                              'id_category': idCategory.value,
                              'latitude': controllerWrite.latitude.value,
                              'longitude': controllerWrite.longitude.value,
                              'address': controllerWrite.address.value,
                              'description':
                                  controllerWrite.controllerContentReport.text,
                              'status': 'Menunggu',
                              'id_klasifikasi_category': stringKlasifikasi,
                              'id_user': idUser,
                              'type': controllerWrite.type.value
                            });
                            // showLoading(context);
                            EasyLoading.show(
                              status: 'mengirim',
                            );

                            dio.interceptors.add(RetryInterceptor(
                              dio: dio,
                              retries: 100,
                              logPrint: print,
                            ));
                            var response = await dio.post(uri, data: formData);
                            logger.e(response.data);
                            String m = jsonDecode(response.data);
                            if (m != null && m.isNotEmpty) {
                              EasyLoading.dismiss();
                              Get.off(
                                () => CompletedScreen(),
                                transition: Transition.rightToLeft,
                              );
                            }
                          } else {
                            EasyLoading.showError(
                              'foto / gambar gagal diambil, silahkan mengambil foto / gambar ulang',
                            );
                          }
                        },
                        child: Text(
                          'Kirim Laporan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.text(16),
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
                        child: Center(
                            child: CircularProgressIndicator.adaptive()));
                    break;
                  case ConnectionState.done:
                    return Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: (16 / Sizer.slicingWidth) *
                                SizeConfig.widthMultiplier,
                          ),
                          height: (404 / Sizer.slicingHeight) *
                              SizeConfig.heightMultiplier,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: (16 / Sizer.slicingWidth) *
                                          SizeConfig.widthMultiplier,
                                      vertical: (16 / Sizer.slicingHeight) *
                                          SizeConfig.heightMultiplier),
                                  child: Text(
                                    '${nameCategory.value}',
                                    style: TextStyle(
                                      fontSize: SizeConfig.text(19),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                ...snapshot.data.map<Widget>(
                                  (data) => ExpansionTile(
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          size: (8 / Sizer.slicingImage) *
                                              SizeConfig.imageSizeMultiplier,
                                        ),
                                        SizedBox(
                                            width: (5 / Sizer.slicingWidth) *
                                                SizeConfig.widthMultiplier),
                                        Expanded(
                                          child: Text(
                                            '${data.name}',
                                            style: TextStyle(
                                              fontSize: SizeConfig.text(16),
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
                                          fontSize: SizeConfig.text(14),
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
                          height: (120 / Sizer.slicingHeight) *
                              SizeConfig.heightMultiplier,
                        ),
                        SizedBox(
                          width: (328 / Sizer.slicingWidth) *
                              SizeConfig.widthMultiplier,
                          height: (40 / Sizer.slicingHeight) *
                              SizeConfig.heightMultiplier,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              foregroundColor: Colors.blue,
                            ),
                            onPressed: () {
                              if (selectedIndex.isEmpty) {
                                errorToast(
                                    error:
                                        'silahkan ceklis salah satu masalah');
                              } else {
                                setState(() {});
                                controller.index.value++;
                              }
                            },
                            child: Text(
                              'Selanjutnya',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.text(16),
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
                FutureBuilder<List<CategoryModel>>(
                    future: CategoryServices.getCategory(),
                    builder: (_, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          );
                        case ConnectionState.done:
                          return Container(
                            margin: EdgeInsets.symmetric(
                              vertical: (16 / Sizer.slicingHeight) *
                                  SizeConfig.heightMultiplier,
                              horizontal: (16 / Sizer.slicingWidth) *
                                  SizeConfig.widthMultiplier,
                            ),
                            child: gridViewCategory(snapshot.data),
                          );
                        default:
                          if (snapshot.hasError)
                            return new Text('Error: ${snapshot.error}');
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          );
                      }
                    }),
              ],
            ),
    );
  }

  Widget gridViewCategory(List<CategoryModel> category) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 0.9,
      children: category
          .map<Widget>(
            (e) => GestureDetector(
              child: Column(
                children: [
                  SizedBox(
                    width:
                        (96 / Sizer.slicingWidth) * SizeConfig.widthMultiplier,
                    height: (96 / Sizer.slicingHeight) *
                        SizeConfig.heightMultiplier,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CachedNetworkImage(
                        imageUrl: '${ServerApp.url}/icon/${e.icon}',
                      ),
                    ),
                  ),
                  Text(
                    '${e.category}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: SizeConfig.text(10),
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
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
          width: (328 / Sizer.slicingWidth) * SizeConfig.widthMultiplier,
          margin: EdgeInsets.symmetric(
              vertical:
                  (16 / Sizer.slicingHeight) * SizeConfig.heightMultiplier),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              headerSteper(
                  stepIcon: 'assets/img/image-svg/kategori-icon.svg',
                  text: 'Kategori',
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
              SvgPicture.asset('assets/img/image-svg/chevron-icon.svg',
                  color: (stepperController.index.value == 0)
                      ? Colors.grey
                      : Colors.blue),
              SizedBox(width: 8.w),
              headerSteper(
                  stepIcon: 'assets/img/image-svg/photo-icon.svg',
                  text: 'Foto',
                  colorText: stepperController.index.value != 0
                      ? Colors.blue
                      : Color(0xffC2C2C2),
                  colorIcon: stepperController.index.value != 0
                      ? Colors.blue
                      : Color(0xffC2C2C2),
                  colorChevron: stepperController.index.value > 1
                      ? Colors.blue
                      : Colors.grey),
              SizedBox(width: 8.w),
              SvgPicture.asset('assets/img/image-svg/chevron-icon.svg',
                  color: stepperController.index.value > 1
                      ? Colors.blue
                      : Colors.grey),
              SizedBox(width: 8.w),
              headerSteper(
                  stepIcon: 'assets/img/image-svg/tulis-icon.svg',
                  text: 'Tulis',
                  colorText: stepperController.index.value > 1
                      ? Colors.blue
                      : Color(0xffC2C2C2),
                  colorIcon: stepperController.index.value > 1
                      ? Colors.blue
                      : Color(0xffC2C2C2),
                  colorChevron: stepperController.index.value == 3
                      ? Colors.blue
                      : Colors.grey),
              SizedBox(width: 8.w),
              SvgPicture.asset('assets/img/image-svg/chevron-icon.svg',
                  color: stepperController.index.value == 3
                      ? Colors.blue
                      : Colors.grey),
              SizedBox(width: 8.w),
              headerSteper(
                status: 'last',
                stepIcon: 'assets/img/image-svg/tinjau-icon.svg',
                text: 'Tinjau',
                colorText: stepperController.index.value == 3
                    ? Colors.blue
                    : Color(0xffC2C2C2),
                colorIcon: stepperController.index.value == 3
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
            height: (510 / Sizer.slicingHeight) * SizeConfig.heightMultiplier,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: (18 / Sizer.slicingWidth) *
                            SizeConfig.widthMultiplier),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: (147 / Sizer.slicingHeight) *
                              SizeConfig.heightMultiplier,
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
                              hintText: 'Catatan',
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: SizeConfig.text(14)),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: (8 / Sizer.slicingHeight) *
                                SizeConfig.heightMultiplier),
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/img/image-svg/mark-question.svg',
                            ),
                            SizedBox(width: SizeConfig.width(4)),
                            Text(
                              'Perhatikan cara penyampaian laporan yang baik\ndan benar',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: SizeConfig.text(12),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: (24 / Sizer.slicingHeight) *
                                SizeConfig.heightMultiplier),
                        SizedBox(
                          height: (30 / Sizer.slicingHeight) *
                              SizeConfig.heightMultiplier,
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
                                      width: (20 / Sizer.slicingWidth) *
                                          SizeConfig.widthMultiplier,
                                      height: (20 / Sizer.slicingHeight) *
                                          SizeConfig.heightMultiplier,
                                    ),
                                    SizedBox(width: SizeConfig.width(8)),
                                    Obx(
                                      () => Text(
                                        (selectDate.value.isEmpty)
                                            ? 'Tanggal kejadian'
                                            : selectDate.value,
                                        style: TextStyle(
                                          fontSize: SizeConfig.text(14),
                                          color: Colors.black,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                onTap: () async {
                                  fToastOnWritePage.removeCustomToast();

                                  FocusScope.of(context).unfocus();
                                  var datePicked =
                                      await DatePicker.showSimpleDatePicker(
                                          context,
                                          titleText: '',
                                          cancelText: 'Batal',
                                          itemTextStyle: TextStyle(
                                              fontSize: SizeConfig.text(16)),
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
                                  // showToast();
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: (24 / Sizer.slicingHeight) *
                                SizeConfig.heightMultiplier),
                        SizedBox(
                          height: (40 / Sizer.slicingHeight) *
                              SizeConfig.heightMultiplier,
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
                                      width: (20 / Sizer.slicingWidth) *
                                          SizeConfig.widthMultiplier,
                                      height: (20 / Sizer.slicingHeight) *
                                          SizeConfig.heightMultiplier,
                                    ),
                                    SizedBox(width: SizeConfig.width(8)),
                                    Expanded(
                                      child: Text(
                                        (selectLoc.isEmpty)
                                            ? 'Pilih lokasi kejadian'
                                            : selectLoc.value,
                                        style: TextStyle(
                                          fontSize: SizeConfig.text(14),
                                          color:
                                              (whenLocationEmpty.value.isEmpty)
                                                  ? Colors.black
                                                  : Colors.red,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  fToastOnWritePage.removeCustomToast();

                                  Get.to<Map<String, dynamic>>(
                                      () => NewGoogleMaps()).then((value) {
                                    if (value != null) {
                                      String address = value['data'];
                                      selectLoc.update((val) {
                                        selectLoc = address.obs;
                                      });

                                      // showToast();

                                      String latitude =
                                          value['latitude'].toString();
                                      String longitude =
                                          value['longitude'].toString();
                                      controllerWrite.address = address.obs;
                                      whenLocationEmpty.value = '';
                                      controllerWrite.latitude = latitude.obs;
                                      controllerWrite.longitude = longitude.obs;
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
                  SizedBox(
                      height: (46 / Sizer.slicingHeight) *
                          SizeConfig.heightMultiplier),
                  Obx(
                    () => Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Color(0xff9E9E9E)),
                      width: (288 / Sizer.slicingWidth) *
                          SizeConfig.widthMultiplier,
                      height: (36 / Sizer.slicingHeight) *
                          SizeConfig.heightMultiplier,
                      child: Center(
                        child: Text(
                          (_radio.value == RadioComplaint.Anonim
                              ? 'Nama anda bersifat rahasia'
                              : 'Nama dan laporan anda bersifat rahasia'),
                          style: TextStyle(
                              fontSize: SizeConfig.text(14),
                              color: Color(0xffE0E0E0)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: (12 / Sizer.slicingHeight) *
                        SizeConfig.heightMultiplier,
                  ),
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
                            width: (170 / Sizer.slicingWidth) *
                                SizeConfig.widthMultiplier,
                            child: RadioListTile<RadioComplaint>(
                              dense: true,
                              title: Text(
                                'Anonim',
                                style: TextStyle(fontSize: SizeConfig.text(14)),
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
                            thickness: 2,
                            color: Color(0xffE0E0E0),
                          ),
                          SizedBox(
                            width: (170 / Sizer.slicingWidth) *
                                SizeConfig.widthMultiplier,
                            child: RadioListTile<RadioComplaint>(
                              title: Text(
                                'Rahasia',
                                style: TextStyle(fontSize: SizeConfig.text(14)),
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
            SizedBox(
              width: (328 / Sizer.slicingWidth) * SizeConfig.widthMultiplier,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: Color(0xff2094F3),
                ),
                onPressed: () {
                  // steperController.index.value++;
                  fToastOnWritePage.removeCustomToast();
                  // errorToast(error: 'lokasi harus dipilih');
                  // showToast();

                  if (controllerWrite.address.value.isEmpty) {
                    errorToast(error: 'lokasi harus dipilih');
                    whenLocationEmpty.value = 'wrong';
                  }

                  if (controllerWrite.address.value.isNotEmpty) {
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
                    // showToast();
                  }
                },
                child: Text(
                  'Lanjutkan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.text(14),
                  ),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgPicture.asset(
          stepIcon,
          color: colorIcon,
        ),
        SizedBox(width: (4 / Sizer.slicingWidth) * SizeConfig.widthMultiplier),
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: SizeConfig.text(16), color: colorText),
        ),
      ],
    );
  }

  Future showToast() async {
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
    fToastOnWritePage.showToast(
      child: toast,
      toastDuration: Duration(hours: 1),
      positionedToastBuilder: (context, child) {
        return Positioned(
          child: child,
          bottom: 300.h,
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
    var pickedFile = await _picker.pickImage(source: source, imageQuality: 50);
    if (pickedFile != null) {
      imagePath.value = pickedFile.path;
      final logger = Logger();
      logger.d(imagePath.value);
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

class CompletedScreen extends StatelessWidget {
  const CompletedScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: (Platform.isAndroid)
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: SizeConfig.height(124),
                ),
                SvgPicture.asset('assets/img/image-svg/completed.svg'),
                SizedBox(
                  height: SizeConfig.height(16),
                ),
                Text(
                  'Yeayyy !!',
                  style: TextStyle(
                    fontSize: SizeConfig.text(30),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: SizeConfig.height(24),
                ),
                SizedBox(
                  width: SizeConfig.width(259),
                  child: Text(
                    'Anda sudah menjadi warga yang peduli terhadap lingkungan disekitar.',
                    style: TextStyle(
                      fontSize: SizeConfig.text(19),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: SizeConfig.height(148),
                ),
                SizedBox(
                  width: SizeConfig.width(328),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onPressed: () {
                      final reportController = Get.put(ReportUserController());
                      reportController.refresReport();
                      reportController.update();

                      Get.back();
                      Get.back();
                    },
                    child: Text(
                      'Kembali Keberanda',
                      style: TextStyle(fontSize: SizeConfig.text(16)),
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
}
