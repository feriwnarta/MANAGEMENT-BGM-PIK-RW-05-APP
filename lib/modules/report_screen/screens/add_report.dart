// import 'dart:io';
// import 'package:aplikasi_rw/controller/report_controller.dart';
// import 'package:aplikasi_rw/server-app.dart';
// import 'package:aplikasi_rw/services/category_detail_services.dart';
// import 'package:aplikasi_rw/services/category_services.dart';
// import 'package:aplikasi_rw/services/klasifikasi_category_services.dart';
// import 'package:aplikasi_rw/utils/UserSecureStorage.dart';
// import 'package:aplikasi_rw/model/category_model.dart';
// import 'package:aplikasi_rw/services/report_services.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:im_stepper/stepper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:sizer/sizer.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:aplikasi_rw/screen/loading_send_screen.dart';
// import 'google_maps_screen.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:aplikasi_rw/controller/report_user_controller.dart';

// class AddReport extends StatefulWidget {
//   @override
//   State<AddReport> createState() => _AddReportState();
// }

// class _AddReportState extends State<AddReport> {
//   int activeStep = 0;
//   final _picker = ImagePicker();
//   PickedFile pickedFile;
//   String imagePath = '';
//   PickedFile imageFile;
//   // bool isVisibility = false;
//   bool isVisibilityGuid = true;
//   String idCategory, address;
//   Color color = Colors.white;
//   String idUser;
//   Future _future;
//   String title = 'Pilih Kategori';

//   TextEditingController controllerDescription = TextEditingController();
//   TextEditingController controllerAdditionalLocation = TextEditingController();
//   TextEditingController controllerFeedBack = TextEditingController();

//   final _formKeyError = GlobalKey<FormState>();
//   String categoryPicked;
//   String idCategoryDetail;
//   String icon;
//   bool check = false;
//   // var selectedIndex = [];
//   // List<String> klasifikasiPicked = [];
//   // List<String> nameKlasifikasi = [];

//   // flutter maps
//   double latitude, longitude;

//   final reportController = Get.put(ReportController());
//   final controllerReport = Get.put(ReportUserController());

//   @override
//   void initState() {
//     _future = UserSecureStorage.getIdUser();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     latitude = null;
//     longitude = null;
//     categoryPicked = null;
//     idCategoryDetail = null;
//     // klasifikasiPicked = [];
//     pickedFile = null;
//     // selectedIndex = [];
//     // Get.delete<ReportController>();
//     controllerAdditionalLocation.clear();
//     controllerDescription.clear();
//     controllerFeedBack.clear();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         title: Text(
//           'Buat Komplain',
//           style: TextStyle(color: Colors.black, fontSize: 19.sp),
//         ),
//         // centerTitle: true,
//         backgroundColor: Colors.white,
//         brightness: Brightness.light,
//         iconTheme: IconThemeData(color: Colors.black),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             IconStepper(
//               enableNextPreviousButtons: false,
//               activeStepColor: Colors.blue[400],
//               enableStepTapping: false,
//               activeStepBorderPadding: 1,
//               activeStepBorderWidth: 1,
//               icons: [
//                 Icon(
//                   Icons.camera_alt,
//                   color: Colors.white,
//                   size: 1,
//                 ),
//                 Icon(
//                   Icons.category,
//                   color: Colors.white,
//                   size: 1,
//                 ),
//                 Icon(
//                   FontAwesomeIcons.clipboardCheck,
//                   color: Colors.white,
//                   size: 2,
//                 )
//               ],
//               activeStep: activeStep,
//               onStepReached: (index) {
//                 setState(() {
//                   activeStep = index;
//                 });
//               },
//             ),
//             (activeStep == 0)
//                 ? stepCamera()
//                 : (activeStep == 1)
//                     ? stepKategory()
//                     : stepCompleted(),
//             SizedBox(height: 2.0.h),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 (activeStep == 0)
//                     ? Container(
//                         width: 20.0.w,
//                       )
//                     : (activeStep == 1)
//                         ? (idCategory == null)
//                             ? SizedBox(
//                                 width: 40.0.w,
//                                 child: RaisedButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       if (activeStep != 0) {
//                                         activeStep--;
//                                         reportController.selectedIndex =
//                                             <int>[].obs;
//                                         reportController.klasifikasiPicked =
//                                             <String>[].obs;
//                                         reportController.isVisibility =
//                                             true.obs;
//                                       }
//                                     });
//                                   },
//                                   color: Colors.blue[400],
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10)),
//                                   child: Text(
//                                     'Kembali',
//                                     style: TextStyle(
//                                         fontSize: 11.0.sp, color: Colors.white),
//                                   ),
//                                 ),
//                               )
//                             : (idCategoryDetail != null)
//                                 ? SizedBox(
//                                     width: 40.0.w,
//                                     child: RaisedButton(
//                                       onPressed: () {
//                                         setState(() {
//                                           idCategoryDetail = null;
//                                           reportController.selectedIndex =
//                                               <int>[].obs;
//                                           reportController.klasifikasiPicked =
//                                               <String>[].obs;
//                                           reportController.nameKlasifikasi =
//                                               <String>[].obs;
//                                           title = 'Detail Komplain';
//                                         });
//                                       },
//                                       color: Colors.blue[400],
//                                       shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(10)),
//                                       child: Text(
//                                         'Kembali',
//                                         style: TextStyle(
//                                             fontSize: 11.0.sp,
//                                             color: Colors.white),
//                                       ),
//                                     ),
//                                   )
//                                 : SizedBox(
//                                     width: 40.0.w,
//                                     child: RaisedButton(
//                                       onPressed: () {
//                                         setState(() {
//                                           idCategory = null;
//                                           title = 'Pilih Kategori';
//                                           reportController.selectedIndex =
//                                               <int>[].obs;
//                                           reportController.klasifikasiPicked =
//                                               <String>[].obs;
//                                           reportController.nameKlasifikasi =
//                                               <String>[].obs;
//                                           print(reportController
//                                               .selectedIndex.length);
//                                         });
//                                       },
//                                       color: Colors.blue[400],
//                                       shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(10)),
//                                       child: Text(
//                                         'Kembali',
//                                         style: TextStyle(
//                                             fontSize: 11.0.sp,
//                                             color: Colors.white),
//                                       ),
//                                     ),
//                                   )
//                         : (activeStep == 2)
//                             ? SizedBox(
//                                 width: 40.0.w,
//                               )
//                             : SizedBox(
//                                 width: 40.0.w,
//                                 child: RaisedButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       if (activeStep != 0) {
//                                         activeStep--;
//                                       }
//                                     });
//                                   },
//                                   color: Colors.blue[400],
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10)),
//                                   child: Text(
//                                     'Kembali',
//                                     style: TextStyle(
//                                         fontSize: 11.0.sp, color: Colors.white),
//                                   ),
//                                 ),
//                               ),
//                 (reportController.isVisibility.value)
//                     ? SizedBox()
//                     : SizedBox(
//                         width: 30.0.w,
//                       ),
//                 Visibility(
//                   visible: (reportController.isVisibility.value),
//                   child: SizedBox(
//                     width: 40.0.w,
//                     child: RaisedButton(
//                       onPressed: () async {
//                         setState(() {
//                           if (activeStep == 0) {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => MapSample(),
//                                 )).then((value) {
//                               if (value != null) {
//                                 latitude = value[0];
//                                 longitude = value[1];
//                                 address = value[2];
//                                 print(address);
//                                 if (activeStep == 0) {
//                                   setState(() {
//                                     activeStep++;
//                                     reportController.isVisibility = false.obs;
//                                   });
//                                 }
//                               }
//                             });
//                           }
//                           if (activeStep == 1) {
//                             if (latitude != null) {
//                               if (reportController
//                                   .klasifikasiPicked.isNotEmpty) {
//                                 activeStep++;
//                               } else {
//                                 Get.snackbar(
//                                     'Message', 'Detail report must be selected',
//                                     backgroundColor: Colors.blue,
//                                     colorText: Colors.white,
//                                     overlayBlur: 2);
//                                 reportController.isVisibility = true.obs;
//                               }
//                             }
//                             // if (activeStep == 1 &&
//                             //     reportController.klasifikasiPicked.isEmpty) {
//                             //   // setState(() {
//                             //   reportController.isVisibility = false.obs;
//                             //   // });
//                             // }
//                           } else if (activeStep == 2) {
//                             FocusScope.of(context).requestFocus(FocusNode());
//                             if (_formKeyError.currentState.validate()) {
//                               String stringKlasifikasi = "";
//                               reportController.klasifikasiPicked
//                                   .forEach((element) {
//                                 stringKlasifikasi += element + ',';
//                               });
//                               ReportServices.sendDataReport(
//                                       description: controllerDescription.text,
//                                       category: categoryPicked,
//                                       idUser: idUser,
//                                       imgPath: imagePath,
//                                       idCategory: idCategory,
//                                       latitude: latitude.toString(),
//                                       longitude: longitude.toString(),
//                                       idKlasifikasiCategory: stringKlasifikasi,
//                                       address: address,
//                                       status: 'listed')
//                                   .then((value) {
//                                 showLoading(context);
//                                 value.send().then((value) {
//                                   http.Response.fromStream(value).then((value) {
//                                     String message = json.decode(value.body);
//                                     if (message != null && message.isNotEmpty) {
//                                       Navigator.of(context)
//                                           .popUntil((route) => route.isFirst);
//                                       // bloc.add(ReportEventRefresh());
//                                       reportController.klasifikasiPicked =
//                                           <String>[].obs;
//                                       reportController.klasifikasiPicked =
//                                           <String>[].obs;
//                                       reportController.selectedIndex =
//                                           <int>[].obs;
//                                       reportController.activeStep = 0;
//                                       reportController.selectedIndex =
//                                           <int>[].obs;
//                                       reportController.isVisibility = false.obs;
//                                     }
//                                   });
//                                   controllerReport
//                                       .refresReport()
//                                       .then((value) {});
//                                 });
//                               });
//                             }
//                           }
//                         });
//                       },
//                       color: Colors.blue[400],
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10)),
//                       child: Text(
//                         (activeStep) != 2 ? 'Lanjut' : 'Kirim',
//                         style:
//                             TextStyle(fontSize: 11.0.sp, color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 3.0.h,
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   FutureBuilder stepCompleted() {
//     return FutureBuilder<String>(
//       future: _future,
//       builder: (context, snapshot) {
//         switch (snapshot.connectionState) {
//           case ConnectionState.done:
//             idUser = snapshot.data;
//             return Container(
//               // color: Colors.white,
//               child: Form(
//                 key: _formKeyError,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       width: 95.0.w,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Details Foto',
//                             style: TextStyle(
//                                 fontSize: 16.sp, fontWeight: FontWeight.w500),
//                           ),
//                           SizedBox(height: 9.h),
//                           Container(
//                             height: 70.h,
//                             width: 70.w,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(4),
//                               image: DecorationImage(
//                                   image: FileImage(File(imagePath)),
//                                   fit: BoxFit.cover,
//                                   repeat: ImageRepeat.noRepeat),
//                             ),
//                           ),
//                           SizedBox(height: 16.h),
//                           Row(
//                             children: [
//                               SvgPicture.asset(
//                                   'assets/img/location-marker.svg'),
//                               Expanded(
//                                 child: Text(
//                                   '$address',
//                                   style: TextStyle(
//                                     fontSize: 12.sp,
//                                     color: Color(0xff9E9E9E),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                           SizedBox(height: 32.h),
//                           Text(
//                             '$categoryPicked',
//                             style: TextStyle(
//                               fontSize: 16.sp,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           SizedBox(height: 16.h),
//                           Row(
//                             children: [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text('Komplain',
//                                       style: TextStyle(
//                                           fontSize: 14.sp,
//                                           fontWeight: FontWeight.w500,
//                                           color: Color(
//                                             0xff616161,
//                                           ))),
//                                   SizedBox(
//                                     height: 8.h,
//                                   ),
//                                   Container(
//                                     width: 300,
//                                     child: ListView.builder(
//                                       itemCount: reportController
//                                           .nameKlasifikasi.length,
//                                       shrinkWrap: true,
//                                       physics: ScrollPhysics(),
//                                       itemBuilder: (context, index) => Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             '  * ${reportController.nameKlasifikasi[index]}',
//                                             style: TextStyle(
//                                                 color: Color(0xff9E9E9E),
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           )
//                         ],
//                         // Column(
//                         //   crossAxisAlignment: CrossAxisAlignment.start,
//                         //   children: [
//                         //     Row(
//                         //       children: [
//                         //         Container(
//                         //           padding: EdgeInsets.symmetric(
//                         //               horizontal: 20, vertical: 5),
//                         //           child: Text(
//                         //             'Details',
//                         //             style: TextStyle(
//                         //                 color: Colors.blueAccent[100],
//                         //                 fontWeight: FontWeight.bold),
//                         //           ),
//                         //           decoration: BoxDecoration(
//                         //               color: Colors.white,
//                         //               borderRadius:
//                         //                   BorderRadius.circular(10)),
//                         //         ),
//                         //         SizedBox(
//                         //           width: 19.0.w,
//                         //         ),
//                         //         Container(
//                         //             height: 10.0.h,
//                         //             width: 10.0.w,
//                         //             decoration: BoxDecoration(
//                         //                 image: DecorationImage(
//                         //                     image: NetworkImage(
//                         //                         '${ServerApp.url}icon/$icon')))),
//                         //         SizedBox(
//                         //           width: 1.5.w,
//                         //         ),
//                         //         Text('$categoryPicked',
//                         //             style: TextStyle(
//                         //                 fontSize: 10.0.sp,
//                         //                 color: Colors.white,
//                         //                 fontWeight: FontWeight.bold)),
//                         //       ],
//                         //     ),
//                         //     SizedBox(height: 1.0.h),
//                         //     Text(
//                         //       'Complaint',
//                         //       style: TextStyle(
//                         //           fontSize: 9.0.sp,
//                         //           color: Colors.white,
//                         //           fontWeight: FontWeight.bold),
//                         //     ),
//                         //     SizedBox(
//                         //       height: 1.5.h,
//                         //     ),
//                         //     ListView.builder(
//                         //       itemCount:
//                         //           reportController.nameKlasifikasi.length,
//                         //       shrinkWrap: true,
//                         //       physics: ScrollPhysics(),
//                         //       itemBuilder: (context, index) => Column(
//                         //         children: [
//                         //           Row(
//                         //             children: [
//                         //               Icon(FontAwesomeIcons.exclamationCircle,
//                         //                   color: Colors.red),
//                         //               SizedBox(width: 1.0.w),
//                         //               Text(
//                         //                 '${reportController.nameKlasifikasi[index]}',
//                         //                 style: TextStyle(
//                         //                     color: Colors.white,
//                         //                     fontWeight: FontWeight.bold),
//                         //               ),
//                         //             ],
//                         //           ),
//                         //           SizedBox(
//                         //             height: 1.0.h,
//                         //           )
//                         //         ],
//                         //       ),
//                         //     ),
//                         //     SizedBox(height: 1.5.h)
//                         //   ],
//                         // ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 2.0.h,
//                     ),
//                     Text(
//                       'Deskripsi Masalah',
//                       style:
//                           TextStyle(fontFamily: 'poppins', fontSize: 11.0.sp),
//                     ),
//                     SizedBox(height: 4.h),
//                     // SizedBox(
//                     //   height: 2.0.h,
//                     // ),
//                     // Container(
//                     //   width: 95.0.w,
//                     //   padding: EdgeInsets.all(15),
//                     //   decoration: BoxDecoration(
//                     //     borderRadius: BorderRadius.circular(10),
//                     //     color: Colors.blue[200].withOpacity(0.5),
//                     //   ),
//                     //   child: Text(
//                     //     'Description problem dapat berisi detail permasalahan',
//                     //     softWrap: true,
//                     //     maxLines: 2,
//                     //     style: TextStyle(color: Colors.blue, fontSize: 11.0.sp),
//                     //   ),
//                     // ),
//                     // SizedBox(height: 2.0.h),
//                     // Text('Problem :'),
//                     // SizedBox(height: 1.0.h),
//                     SizedBox(
//                       width: 95.0.w,
//                       child: TextFormField(
//                         maxLines: 10,
//                         maxLength: 2000,
//                         controller: controllerDescription,
//                         keyboardType: TextInputType.name,
//                         style: TextStyle(fontSize: 12.0.sp),
//                         validator: (description) => (description.isEmpty)
//                             ? 'form problem tidak boleh kosong'
//                             : (description.length < 5)
//                                 ? 'minimal kata harus lebih dari 5 karakter'
//                                 : null,
//                         decoration: InputDecoration(
//                             errorMaxLines: 3,
//                             hintText:
//                                 'contoh: pohon di cluster Ebony dekat rumah pak udin hampir rubuh',
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(10))),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 2.0.h,
//                     ),
//                     // Text(
//                     //   'Additional Location Description',
//                     //   style:
//                     //       TextStyle(fontFamily: 'poppins', fontSize: 11.0.sp),
//                     // ),
//                     // SizedBox(
//                     //   height: 2.0.h,
//                     // ),
//                     // Container(
//                     //   width: 90.0.w,
//                     //   padding: EdgeInsets.all(15),
//                     //   decoration: BoxDecoration(
//                     //     borderRadius: BorderRadius.circular(10),
//                     //     color: Colors.blue[200].withOpacity(0.5),
//                     //   ),
//                     //   child: Text(
//                     //     'Additional location description, dapat berisi informasi tambahan mengenai lokasi laporan. Seperti nama gedung, nama jalan, atau ciri khusus dekat sekitar. dll',
//                     //     softWrap: true,
//                     //     maxLines: 5,
//                     //     style: TextStyle(color: Colors.blue, fontSize: 11.0.sp),
//                     //   ),
//                     // ),
//                     // SizedBox(height: 2.0.h),
//                     // Text('Location :'),
//                     // SizedBox(height: 1.0.h),
//                     // SizedBox(
//                     //   width: 90.0.w,
//                     //   child: TextFormField(
//                     //     maxLines: 10,
//                     //     maxLength: 2000,
//                     //     controller: controllerAdditionalLocation,
//                     //     keyboardType: TextInputType.name,
//                     //     style: TextStyle(fontSize: 12.0.sp),
//                     //     validator: (description) => (description.isEmpty)
//                     //         ? 'form additional location tidak boleh kosong'
//                     //         : (description.length < 10)
//                     //             ? 'minimal kata harus lebih 10 karakter'
//                     //             : null,
//                     //     decoration: InputDecoration(
//                     //         errorMaxLines: 3,
//                     //         hintText:
//                     //             'contoh: lokasi dekat dengan gedung cisadane. samping warung sembako',
//                     //         border: OutlineInputBorder(
//                     //             borderRadius: BorderRadius.circular(10))),
//                     //   ),
//                     // ),
//                     // SizedBox(
//                     //   height: 2.0.h,
//                     // ),
//                     // Text(
//                     //   'Feedback',
//                     //   style:
//                     //       TextStyle(fontFamily: 'poppins', fontSize: 11.0.sp),
//                     // ),
//                     // SizedBox(
//                     //   height: 2.0.h,
//                     // ),
//                     // Container(
//                     //   width: 90.0.w,
//                     //   padding: EdgeInsets.all(15),
//                     //   decoration: BoxDecoration(
//                     //     borderRadius: BorderRadius.circular(10),
//                     //     color: Colors.blue[200].withOpacity(0.5),
//                     //   ),
//                     //   child: Text(
//                     //     'Feedback merupakan bagian saran dan kritik untuk pengelola, agar setiap permasalahan dapat ditangani dengan baik',
//                     //     softWrap: true,
//                     //     maxLines: 5,
//                     //     style: TextStyle(color: Colors.blue, fontSize: 11.0.sp),
//                     //   ),
//                     // ),
//                     // SizedBox(height: 2.0.h),
//                     // Text('Feedback :'),
//                     // SizedBox(height: 1.0.h),
//                     // SizedBox(
//                     //   width: 90.0.w,
//                     //   child: TextFormField(
//                     //     maxLines: 10,
//                     //     maxLength: 2000,
//                     //     controller: controllerFeedBack,
//                     //     keyboardType: TextInputType.name,
//                     //     style: TextStyle(fontSize: 12.0.sp),
//                     //     // validator: (description) => (description.isEmpty)
//                     //     //     ? 'form feedback tidak boleh kosong'
//                     //     //     : (description.length < 50)
//                     //     //         ? 'minimal kata harus lebih dari 50 karakter'
//                     //     //         : null,
//                     //     decoration: InputDecoration(
//                     //         errorMaxLines: 3,
//                     //         hintText:
//                     //             'contoh: dimohon pengelola setiap tempat yang rawan diberikan cctv',
//                     //         border: OutlineInputBorder(
//                     //             borderRadius: BorderRadius.circular(10))),
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ),
//             );
//           default:
//             if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
//             return Container(
//               child: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             );
//         }
//       },
//     );
//   }

//   Column stepKategory() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           height: 2.0.h,
//         ),
//         Container(
//           margin: EdgeInsets.symmetric(horizontal: 3.0.w),
//           child: Text(
//             title,
//             style: TextStyle(fontFamily: 'Poppins', fontSize: 11.0.sp),
//           ),
//         ),
//         SizedBox(height: 2.0.h),
//         Container(
//           height: 50.0.h,
//           child: FutureBuilder<List<CategoryModel>>(
//               future: CategoryServices.getCategory(),
//               builder: (_, snapshot) {
//                 switch (snapshot.connectionState) {
//                   case ConnectionState.waiting:
//                     return Container(
//                         child: Center(child: CircularProgressIndicator()));
//                   case ConnectionState.done:
//                     return (idCategory == null)
//                         ? gridViewCategory(snapshot.data)
//                         : viewKlasifikasiCategory(idCategory);
//                   default:
//                     if (snapshot.hasError)
//                       return new Text('Error: ${snapshot.error}');
//                     return Container(
//                       child: Center(
//                         child: CircularProgressIndicator(),
//                       ),
//                     );
//                 }
//               }),
//         ),
//       ],
//     );
//   }

//   StreamBuilder<List<KlasifikasiCategory>> viewKlasifikasiCategory(
//       String idCategory) {
//     return StreamBuilder<List<KlasifikasiCategory>>(
//         stream: KlasifikasiCategoryServices.getKlasifikasiCategory(idCategory),
//         builder: (context, snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.waiting:
//               return Container(
//                   child: Center(child: CircularProgressIndicator()));
//             case ConnectionState.done:
//               return ListView.builder(
//                   physics: ScrollPhysics(),
//                   shrinkWrap: true,
//                   itemCount: snapshot.data.length,
//                   itemBuilder: (context, index) {
//                     return buildCheckboxListTile(
//                         snapshot.data[index].klasifikasi,
//                         index,
//                         snapshot.data[index].idKlasifikasi);
//                   });
//             default:
//               if (snapshot.hasError)
//                 return new Text('Error: ${snapshot.error}');
//               return Container(
//                 child: Center(
//                   child: CircularProgressIndicator(),
//                 ),
//               );
//           }
//         });
//   }

//   Obx buildCheckboxListTile(
//       String klasifikasi, int index, String idKlasifikasi) {
//     return Obx(
//       () => CheckboxListTile(
//         controlAffinity: ListTileControlAffinity.leading,
//         activeColor: Colors.blue,
//         value: reportController.selectedIndex.contains(index),
//         title: Text(
//           klasifikasi,
//           textAlign: TextAlign.left,
//         ),
//         onChanged: (value) {
//           if (reportController.selectedIndex.contains(index)) {
//             reportController.selectedIndex.remove(index);
//             reportController.klasifikasiPicked.remove(idKlasifikasi);
//             reportController.nameKlasifikasi.remove(klasifikasi);
//             if (reportController.klasifikasiPicked.isEmpty) {
//               reportController.isVisibility = false.obs;
//               print(reportController.isVisibility.value);
//             }
//             print(reportController.klasifikasiPicked);
//           } else {
//             reportController.selectedIndex.add(index);
//             reportController.klasifikasiPicked.add(idKlasifikasi);
//             reportController.nameKlasifikasi.add(klasifikasi);
//             reportController.isVisibility = true.obs;
//             print(reportController.klasifikasiPicked);
//             print(reportController.isVisibility.value);
//           }
//           // setState(() {
//           //   if (selectedIndex.contains(index)) {
//           //     selectedIndex.remove(index);
//           //     klasifikasiPicked.remove(idKlasifikasi);
//           //     nameKlasifikasi.remove(klasifikasi);
//           //     if (klasifikasiPicked.isEmpty) {
//           //       isVisibility = false;
//           //     }
//           //     print(klasifikasiPicked);
//           //   } else {
//           //     selectedIndex.add(index);
//           //     klasifikasiPicked.add(idKlasifikasi);
//           //     nameKlasifikasi.add(klasifikasi);
//           //     isVisibility = true;
//           //     print(klasifikasiPicked);
//           //   }
//           // });
//         },
//       ),
//     );
//   }

//   FutureBuilder<List<CategoryDetailModel>> gridViewCategoryDetail() {
//     return FutureBuilder<List<CategoryDetailModel>>(
//         future: CategoryDetailServices.getCategoryDetail(idCategory),
//         builder: (context, snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.waiting:
//               return Container(
//                   child: Center(child: CircularProgressIndicator()));
//             case ConnectionState.done:
//               return GridView.builder(
//                 shrinkWrap: true,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 4,
//                   // childAspectRatio: 0.05.w / 0.05.h
//                   // childAspectRatio: 100.0.h / 1100,
//                   childAspectRatio: 100.0.h / 1100,
//                   // crossAxisSpacing: 0.05.h,
//                   // mainAxisSpacing: 0.02.h
//                 ),
//                 itemCount: snapshot.data.length,
//                 itemBuilder: (context, index) {
//                   return Column(
//                     children: [
//                       SizedBox(
//                         height: 10.0.h,
//                         width: 20.0.w,
//                         child: Card(
//                           elevation: 7,
//                           color: Colors.white,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20)),
//                           child: Container(
//                               child: IconButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       idCategoryDetail =
//                                           snapshot.data[index].idCategoryDetail;
//                                       title = 'Klasifikasi Report';
//                                     });
//                                   },
//                                   icon: CachedNetworkImage(
//                                     imageUrl:
//                                         '${ServerApp.url}/icon/${snapshot.data[index].iconDetail}',
//                                   ))),
//                         ),
//                       ),
//                       Column(
//                         children: [
//                           Text(
//                             snapshot.data[index].namecategoryDetail,
//                             style: TextStyle(
//                                 fontSize: 9.0.sp, fontFamily: 'poppins'),
//                             softWrap: true,
//                             maxLines: 3,
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       )
//                     ],
//                   );
//                 },
//               );
//             default:
//               if (snapshot.hasError)
//                 return new Text('Error: ${snapshot.error}');
//               return Container();
//           }
//         });
//   }

//   GridView gridViewCategory(List<CategoryModel> category) {
//     return GridView.builder(
//       shrinkWrap: true,
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3,
//           // childAspectRatio: 0.05.w / 0.05.h
//           // childAspectRatio: 100.0.h / 1100,
//           childAspectRatio: 3 / 3,
//           crossAxisSpacing: 0.5.w,
//           mainAxisSpacing: 0.7.h),
//       itemCount: category.length,
//       itemBuilder: (context, index) {
//         return SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 10.0.h,
//                 width: 20.0.w,
//                 child: Card(
//                   elevation: 7,
//                   color: Colors.white,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20)),
//                   child: Container(
//                       child: IconButton(
//                           onPressed: () {
//                             setState(() {
//                               idCategory = '${category[index].idCategory}';
//                               categoryPicked = '${category[index].category}';
//                               icon = '${category[index].icon}';
//                               title = 'Detail Komplain';
//                             });
//                             reportController.isVisibility = true.obs;
//                           },
//                           icon: Image.network(
//                               '${ServerApp.url}/icon/${category[index].icon}'))),
//                 ),
//               ),
//               Column(
//                 children: [
//                   Text(
//                     category[index].category,
//                     style: TextStyle(fontSize: 9.0.sp, fontFamily: 'poppins'),
//                     softWrap: true,
//                     maxLines: 3,
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Container stepCamera() {
//     return Container(
//       child: Column(
//         children: [
//           Visibility(
//             visible: reportController.isVisibility.value,
//             child: Container(
//               height: 55.0.h,
//               // color: Colors.grey,
//               decoration: BoxDecoration(
//                   image: DecorationImage(
//                       image: FileImage(File(imagePath)),
//                       fit: BoxFit.cover,
//                       repeat: ImageRepeat.noRepeat)),
//             ),
//           ),
//           SizedBox(height: 2.0.h),
//           Visibility(
//             visible: isVisibilityGuid,
//             child: Container(
//               width: 90.0.w,
//               padding: EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                   color: Colors.blue[400],
//                   borderRadius: BorderRadius.circular(10)),
//               child: Text(
//                 'Klik icon camera untuk memfoto langsung laporan, atau icon gallery untuk langsung memilih gambar yang ada di gallery',
//                 style: TextStyle(
//                     fontSize: 12.0.sp,
//                     color: Colors.white,
//                     fontFamily: 'PT Sans Narrow'),
//               ),
//             ),
//           ),
//           SizedBox(height: 2.0.h),
//           Container(
//             height: 7.0.h,
//             width: 50.0.w,
//             decoration: BoxDecoration(
//                 color: Colors.green[300],
//                 borderRadius: BorderRadius.circular(10)),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Material(
//                   color: Colors.transparent,
//                   borderRadius: BorderRadius.circular(100),
//                   child: Padding(
//                     padding: EdgeInsets.only(right: 1.5.w),
//                     child: IconButton(
//                       icon: Icon(
//                         Icons.camera_alt,
//                         size: 5.0.h,
//                         color: Colors.white,
//                       ),
//                       onPressed: () {
//                         getImage(ImageSource.camera).whenComplete(() {
//                           if (pickedFile != null) {
//                             setState(() {
//                               reportController.isVisibility = true.obs;
//                               isVisibilityGuid = false;
//                             });
//                           }
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//                 Material(
//                   color: Colors.transparent,
//                   borderRadius: BorderRadius.circular(100),
//                   child: Padding(
//                     padding: EdgeInsets.only(right: 1.5.w),
//                     child: IconButton(
//                       icon: Icon(
//                         Icons.image,
//                         size: 5.0.h,
//                         color: Colors.white,
//                       ),
//                       onPressed: () {
//                         getImage(ImageSource.gallery).whenComplete(() {
//                           if (pickedFile != null) {
//                             setState(() {
//                               reportController.isVisibility = true.obs;
//                               isVisibilityGuid = false;
//                             });
//                           }
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   String validatorTextField(String text) {
//     if (text.isEmpty) {
//       return 'Form tidak boleh kosong';
//     } else if (text.length < 50) {
//       return 'Minimal kata 50 karakter';
//     } else {
//       return null;
//     }
//   }

//   Future getImage(ImageSource source) async {
//     pickedFile = await _picker.getImage(source: source, imageQuality: 50);
//     if (pickedFile != null) {
//       imagePath = pickedFile.path;
//     }
//   }
// }
