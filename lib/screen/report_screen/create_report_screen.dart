import 'dart:io';

import 'package:aplikasi_rw/bloc/tempat_tulis_status_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//ignore: must_be_immutable
class CreateReportScreen extends StatelessWidget {
  PickedFile imageFile; // akan dikirim kedatabase
  final _picker = ImagePicker();

  // data yang akan dikirim kedatabase
  TextEditingController controllerTitle, controllerContent;

  // bloc
  TempatTulisStatusBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<TempatTulisStatusBloc>(context);

    return BlocBuilder<TempatTulisStatusBloc, TempatTulisStatusState>(
      builder: (context, state) => Container(
        height: (state.isVisible) ? 78.0.h : 65.0.h,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              'Add Report',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0.sp),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.clear_rounded,
                color: Colors.white,
                size: 4.0.h,
              ),
              onPressed: () {
                imageFile = null;
                bloc.add(TulisStatusEvent(imageFile: null));
                Navigator.of(context).pop();
              },
            ),
          ),
          body: ListView(
            children: [
              Column(
                children: [
                  // list tile data user
                  Container(
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 3.5.h,
                        backgroundImage: NetworkImage(
                            'http://rawakalong.desa.id/wp-content/uploads/2019/02/person2.jpg'),
                      ),
                      title: Text(
                        'Citra Susanti',
                        style:
                            TextStyle(fontFamily: 'poppins', fontSize: 12.0.sp),
                      ),
                      subtitle: Text('BLOK XY NO 21',
                          style: TextStyle(fontSize: 9.0.sp)),
                    ),
                  ),

                  Divider(
                    thickness: 1,
                    height: 1.0.h,
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.5.w)
                        .copyWith(top: 1.0.h),
                    child: SizedBox(
                      height: 6.5.h,
                      child: TextField(
                        controller: controllerTitle,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(10)),
                            hintText: 'title'),
                        style: TextStyle(fontSize: 12.0.sp),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.5.w)
                        .copyWith(top: 1.0.h),
                    child: SizedBox(
                      height: 23.0.h,
                      child: TextField(
                        controller: controllerContent,
                        maxLines: 10,
                        decoration: InputDecoration(
                            hintText: 'contents of the report',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                        style: TextStyle(fontSize: 12.0.sp),
                      ),
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
                              size: 3.5.h,
                            ),
                            label: Text(''),
                            onPressed: () {
                              getImage(ImageSource.camera);
                            }),
                        VerticalDivider(
                          color: Colors.grey,
                          width: 10.0.w,
                          thickness: 1,
                          indent: 15,
                          endIndent: 10,
                        ),
                        TextButton.icon(
                            icon: Icon(
                              FontAwesomeIcons.solidImage,
                              color: Colors.blue,
                              size: 3.5.h,
                            ),
                            label: Text(''),
                            onPressed: () {
                              getImage(ImageSource.gallery);
                            })
                      ],
                    ),
                  ),

                  Visibility(
                    visible: state.isVisible,
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
                                      : AssetImage(''),
                                  height: 10.0.h,
                                  width: 22.0.w,
                                ),
                              ),

                              //  button hapus gambar
                              Padding(
                                padding: EdgeInsets.only(left: 5.0.w),
                                child: ElevatedButton(
                                    // elevation: 0,
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.blueGrey[100],
                                    ),
                                    child: Text(
                                      'Hapus',
                                      style: TextStyle(
                                          fontSize: 11.0.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    onPressed: () {
                                      // url foto dari container foto status dikosongin
                                      // widget container ini akan di hide
                                      // setState(() {
                                      //   isVisible = false;
                                      //   imageFile = null;
                                      // });
                                      bloc.add(TulisStatusEvent(
                                          isVisibility: false,
                                          imageFile: null));
                                    }),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          height: 10,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
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

                        // status yang dikirim pertama kali adalah listed
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void getImage(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source);

    if (pickedFile != null) {
      bloc.add(TulisStatusEvent(isVisibility: true, imageFile: pickedFile));
    }
  }
}
