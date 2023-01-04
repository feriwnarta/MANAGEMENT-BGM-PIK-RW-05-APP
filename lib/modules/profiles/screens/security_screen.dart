import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/state_manager.dart';

class SecurityScreen extends StatelessWidget {
  SecurityScreen({Key key}) : super(key: key);

  RxBool isObsecureNew = true.obs;
  RxBool isObsecureNow = true.obs;
  RxBool isObsecureReNew = true.obs;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));

    return Scaffold(
      appBar: AppBar(
        title: Text('Ganti Password'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                SizedBox(
                  height: 16.h,
                ),
                AutoSizeText(
                  'Kata sandi Anda harus panjangnya 8 hingga 72 karakter, tidak mengandung email nama Anda, tidak umum digunakan dan mudah ditebak',
                  style: TextStyle(
                    fontSize: 12.sp,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  stepGranularity: 10,
                  minFontSize: 10,
                ),
                SizedBox(
                  height: 32.h,
                ),
                Obx(
                  () => Form(
                    child: Column(
                      children: [
                        TextFormField(
                          obscureText: isObsecureNow.value,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: (isObsecureNow.value)
                                  ? Icon(Icons.visibility_off_outlined)
                                  : Icon(Icons.visibility),
                              onPressed: () {
                                isObsecureNow.value = !isObsecureNow.value;
                              },
                            ),
                            icon: SvgPicture.asset(
                                'assets/img/image-svg/key.svg'),
                            hintText: 'Kata sandi sekarang',
                            hintStyle: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                        SizedBox(
                          height: 32.h,
                        ),
                        TextFormField(
                          obscureText: isObsecureNew.value,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: (isObsecureNew.value)
                                  ? Icon(Icons.visibility_off_outlined)
                                  : Icon(Icons.visibility),
                              onPressed: () {
                                isObsecureNew.value = !isObsecureNew.value;
                              },
                            ),
                            icon: SvgPicture.asset(
                                'assets/img/image-svg/key.svg'),
                            hintText: 'Kata sandi baru',
                            hintStyle: TextStyle(fontSize: 14.sp),
                          ),
                        ),
                        SizedBox(
                          height: 32.h,
                        ),
                        TextFormField(
                          obscureText: isObsecureReNew.value,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: (isObsecureReNew.value)
                                  ? Icon(Icons.visibility_off_outlined)
                                  : Icon(Icons.visibility),
                              onPressed: () {
                                isObsecureReNew.value = !isObsecureReNew.value;
                              },
                            ),
                            icon: SvgPicture.asset(
                                'assets/img/image-svg/key.svg'),
                            hintText: 'Ulangi kata sandi baru',
                            hintStyle: TextStyle(fontSize: 14.sp),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 318.h,
                ),
                SizedBox(
                  width: 328.w,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    )),
                    child: Text(
                      'Simpan',
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w500),
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
