import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../error_message.dart';

import '../../server-app.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'insert_password.dart';

//ignore: must_be_immutable
class OtpScreen extends StatelessWidget {
  String noIpl;
  OtpScreen({this.noIpl});

  TextEditingController num1 = TextEditingController();
  TextEditingController num2 = TextEditingController();
  TextEditingController num3 = TextEditingController();
  TextEditingController num4 = TextEditingController();
  TextEditingController num5 = TextEditingController();
  TextEditingController num6 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('OTP'),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 5.0.h,
            ),
            Form(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 10.0.h,
                    width: 15.0.w,
                    child: TextFormField(
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                        if (value.length == 0) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      controller: num1,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                  Container(
                    height: 10.0.h,
                    width: 15.0.w,
                    child: TextFormField(
                      readOnly: true,
                      enabled: false,
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                        if (value.length == 0) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      onTap: () {
                        FocusScope.of(context)
                            .requestFocus(FocusNode(canRequestFocus: false));
                      },
                      controller: num2,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      // decoration: InputDecoration(
                      //   border: OutlineInputBorder(),
                      //   disabledBorder: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(10.0),
                      //     borderSide: BorderSide(color: Colors.grey),
                      //   ),
                      //   filled: true,
                      // ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                  Container(
                    height: 10.0.h,
                    width: 15.0.w,
                    child: TextFormField(
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                        if (value.length == 0) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      controller: num3,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                  Container(
                    height: 10.0.h,
                    width: 15.0.w,
                    child: TextFormField(
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                        if (value.length == 0) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      controller: num4,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                  Container(
                    height: 10.0.h,
                    width: 15.0.w,
                    child: TextFormField(
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                        if (value.length == 0) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      controller: num5,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ),
                  Container(
                    height: 10.0.h,
                    width: 15.0.w,
                    child: TextFormField(
                      onChanged: (value) {
                        if (value.length == 1) {
                          String otp = num1.text +
                              num2.text +
                              num3.text +
                              num4.text +
                              num5.text +
                              num6.text;
                          checkOtp(noIpl, otp, context);
                        }
                        if (value.length == 0) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                      controller: num6,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  //ignore: must_be_immutable
  Future<String> checkOtp(
      String noIpl, String otp, BuildContext context) async {
    String url = '${ServerApp.url}src/login/verify_otp.php';
    var data = {'otp': otp, 'no_ipl': noIpl};
    var response = await http.post(Uri.parse(url), body: json.encode(data));
    String obj = json.decode(response.body);
    if (obj == 'OK') {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => InsertPassword(),
      ));
    } else {
      ErrorMessage.buildShowDialogAnimation('OTP WRONG', 'OK',
          'assets/animation/error-animation.json', 4.0.h, context);
    }
  }
}
