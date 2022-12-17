import 'dart:io';
import 'package:aplikasi_rw/bloc/tempat_tulis_status_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//ignore: must_be_immutable
class EditPaymentScreen extends StatelessWidget {
  // no payment dan foto screenshoot
  String noPayment;
  String urlFotoProof =
      'https://media.karousell.com/media/photos/products/2019/12/25/bukti_transfer_trf__1577263390_4882166a_progressive.jpg';

  EditPaymentScreen({this.noPayment});

  // picked file
  PickedFile imageFile;
  final _picker = ImagePicker();
  // visibility
  bool isVisibility = true;
  final appBar = AppBar(
    title: Text('Edit Payment'),
  );

  // bloc
  TempatTulisStatusBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<TempatTulisStatusBloc>(context);

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
                              padding: EdgeInsets.symmetric(horizontal: 1.5.w),
                              child: Text(
                                'No Payment',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0.sp),
                              ),
                            ),
                            Text(noPayment,
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0.sp)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 1.0.h),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(10)),
                        hintText: 'name payment'),
                    style: TextStyle(fontSize: 12.0.sp),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 1.0.h),
                  child: TextField(
                    maxLines: 10,
                    decoration: InputDecoration(
                        hintText: 'description',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintStyle: TextStyle(fontSize: 12.0.sp)),
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
                                    : NetworkImage(urlFotoProof),
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
                            color: Colors.blue,
                            size: 4.0.h,
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
                  height: 15,
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
                        style: TextStyle(fontSize: 11.0.sp),
                      ),
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
      isVisibility = true;
    }
  }
}
