import 'dart:io';
import 'package:aplikasi_rw/bloc/tempat_tulis_status_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//ignore: must_be_immutable
class AddPayment extends StatelessWidget {
  PickedFile imageFile; // akan dikirim kedatabase
  final _picker = ImagePicker();
  TempatTulisStatusBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<TempatTulisStatusBloc>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Payment')),
      body: BlocBuilder<TempatTulisStatusBloc, TempatTulisStatusState>(
        builder: (context, state) => Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 1.0.w, vertical: 1.0.h),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(10)),
                        hintText: 'name payment'),
                    style: TextStyle(fontSize: 11.0.sp),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 1.0.w, vertical: 1.0.h),
                  child: TextField(
                    maxLines: 10,
                    decoration: InputDecoration(
                        hintText: 'description',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    style: TextStyle(fontSize: 11.0.sp),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 1.5.w),
                  child: Text(
                    'Upload proof of transfer',
                    style: TextStyle(color: Colors.grey, fontSize: 11.0.sp),
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
                                    // setState(() {
                                    //   isVisible = false;
                                    //   imageFile = null;
                                    // });
                                    bloc.add(TulisStatusEvent(
                                        isVisibility: false, imageFile: null));
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
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                          icon: Icon(
                            FontAwesomeIcons.camera,
                            color: Colors.blue,
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
                            color: Colors.blue,
                          ),
                          label: Text(''),
                          onPressed: () {
                            getImage(ImageSource.gallery);
                          })
                    ],
                  ),
                ),
                SizedBox(
                  height: (state.isVisible) ? 10.0.h : 20.0.h,
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
                      child: Text(
                        'Post',
                        style: TextStyle(fontSize: 12.0.sp),
                      ),
                      onPressed: () {
                        // mengirim title report
                        // mengirim content report
                        // mengirim gambar report
                        // generate notickets (bulan, tanggal, urutan ticket)

                        // status yang dikirim pertama kali adalah listed
                      },
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

  void getImage(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source);

    if (pickedFile != null) {
      bloc.add(TulisStatusEvent(isVisibility: true, imageFile: pickedFile));
    }
  }
}
