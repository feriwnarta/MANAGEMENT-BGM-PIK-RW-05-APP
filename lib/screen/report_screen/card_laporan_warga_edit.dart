import 'dart:io';

import 'package:aplikasi_rw/bloc/tempat_tulis_status_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//ignore: must_be_immutable
class CardLaporanWargaEdit extends StatelessWidget {
  // data laporan
  final String noTickects;
  String imageReportUrl =
      'https://cloud.jpnn.com/photo/arsip/normal/2021/12/25/jalan-protokol-di-jalan-basuki-rahmad-kota-palembang-sumsel-2ris.jpg';

  CardLaporanWargaEdit({this.noTickects});

  // picked file
  PickedFile imageFile;
  final _picker = ImagePicker();
  bool isVisible = false;

  final appBar = AppBar(
    brightness: Brightness.light,
    title: Text(
      'Edit Report',
      style: TextStyle(fontFamily: 'poppins'),
    ),
  );

  // bloc
  TempatTulisStatusBloc bloc;

  // visibility
  bool isVisibility = true;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<TempatTulisStatusBloc>(context);
    isVisible = true;

    return BlocBuilder<TempatTulisStatusBloc, TempatTulisStatusState>(
      builder: (context, state) => Scaffold(
        appBar: appBar,
        body: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1.0.w),
                  child: SizedBox(
                    height: 6.0.h,
                    child: Padding(
                      padding: EdgeInsets.only(top: 1.0.h),
                      child: Card(
                        elevation: 2,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 1.5.h),
                              child: Text(
                                'No tickets',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.0.sp),
                              ),
                            ),
                            Text(noTickects,
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.0.sp)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 1.0.w, vertical: 1.0.h),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(10)),
                        hintText: 'title',
                        hintStyle: TextStyle(fontSize: 13.0.sp)),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 1.0.w, vertical: 1.0.h),
                  child: TextField(
                    maxLines: 10,
                    decoration: InputDecoration(
                        hintText: 'contents of the report',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintStyle: TextStyle(fontSize: 13.0.sp)),
                  ),
                ),
                Divider(
                  thickness: 1,
                ),
                Visibility(
                  visible: isVisibility,
                  child: Column(
                    children: [
                      Divider(
                        thickness: 1,
                        height: 5,
                      ),
                      Container(
                        width: 100.0.w,
                        color: Colors.white,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 2.0.w),
                              child: Image(
                                alignment: Alignment.center,
                                repeat: ImageRepeat.noRepeat,
                                image: (state.imageFile != null)
                                    ? FileImage(File(state.imageFile.path))
                                    : NetworkImage(imageReportUrl),
                                height: 8.0.h,
                                width: 20.0.w,
                              ),
                            ),

                            //  button hapus gambar
                            Padding(
                              padding: EdgeInsets.only(left: 1.5.w),
                              child: ElevatedButton(
                                  // elevation: 0,

                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.blueGrey[100],
                                  ),
                                  child: Text(
                                    'Hapus',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11.0.sp),
                                  ),
                                  onPressed: () {
                                    // url foto dari container foto status dikosongin
                                    // widget container ini akan di hide
                                    bloc.add(TulisStatusEvent(
                                        isVisibility: false, imageFile: null));
                                    isVisibility = !isVisibility;
                                  }),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        height: 1.0.h,
                      ),
                    ],
                  ),
                ),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                          icon: Icon(
                            FontAwesomeIcons.camera,
                            color: Colors.blue,
                            size: 4.0.h,
                          ),
                          label: Text(''),
                          onPressed: () {
                            getImage(ImageSource.camera);
                          }),
                      VerticalDivider(
                        color: Colors.grey,
                        width: 50,
                        thickness: 1,
                        indent: 15,
                        endIndent: 10,
                      ),
                      TextButton.icon(
                          icon: Icon(
                            FontAwesomeIcons.solidImage,
                            size: 4.0.h,
                            color: Colors.blue,
                          ),
                          label: Text(''),
                          onPressed: () {
                            getImage(ImageSource.gallery);
                          })
                    ],
                  ),
                ),
                Divider(
                  thickness: 1,
                  height: 2.0.h,
                ),
                Center(
                  child: SizedBox(
                    width: 90.0.w,
                    height: 6.0.h,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                      child: Text('Post'),
                      onPressed: () {
                        // mengirim title report
                        // mengirim content report
                        // mengirim gambar report
                        // generate notickets (bulan, tanggal, urutan ticket)

                        // ambil banyak tiket yang sudah dibuat untuk dimasukan keurutan ticket
                        // status yang dikirim pertama kali adalah listed
                      },
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

  void getImage(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source);

    if (pickedFile != null) {
      // imageFile = pickedFile;
      // isVisible = true;
      bloc.add(TulisStatusEvent(imageFile: pickedFile, isVisibility: true));
      // isVisibility = bloc.state.isVisible;
      isVisibility = true;
    }
  }
}
