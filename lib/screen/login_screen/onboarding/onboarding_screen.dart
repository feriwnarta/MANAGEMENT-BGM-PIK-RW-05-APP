import 'package:aplikasi_rw/screen/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({Key key}) : super(key: key);

  PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            children: [
              Onboarding1(
                controller: _controller,
              ),
              Onboarding2(
                controller: _controller,
              ),
              Onboarding3()
            ],
          ),
          // dot
          Container(
            alignment: Alignment(0, 0.88),
            child: SmoothPageIndicator(
              count: 3,
              controller: _controller,
              effect: SlideEffect(
                dotHeight: 12.h,
                dotWidth: 10.w,
                activeDotColor: Color(0xff2094F3),
                dotColor: Color(0xffE0E0E0),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Onboarding1 extends StatelessWidget {
  const Onboarding1({Key key, this.controller}) : super(key: key);

  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffF2F9FF),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: 80.h),
          SvgPicture.asset(
            'assets/img/image-svg/rafiki.svg',
            height: 233.h,
            width: 316.w,
          ),
          SizedBox(height: 103.h),
          Container(
            height: 336.h,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                )),
            child: Column(
              children: [
                SizedBox(
                  height: 40.h,
                ),
                Text(
                  'Berbagi Informasi Apapun',
                  style: TextStyle(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                SizedBox(
                  width: 320.w,
                  height: 72.h,
                  child: Text(
                    'Berbagi informasi melalui unggahan foto,\nvideo dan dapat meninggalkan komentar \nsatu sama lain.',
                    style: TextStyle(fontSize: 16.sp, color: Color(0xff616161)),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 32.h),
                SizedBox(
                  width: 156.w,
                  height: 40.h,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      // minWidth: 156.w,
                      // height: 40.h,
                      backgroundColor: Color(0xff2094F3),

                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    onPressed: () {
                      controller.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    },
                    child: Text(
                      'Selanjutnya',
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Onboarding2 extends StatelessWidget {
  const Onboarding2({Key key, this.controller}) : super(key: key);

  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffF2F9FF),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: 80.h),
          SvgPicture.asset(
            'assets/img/image-svg/onboard2.svg',
            height: 233.h,
            width: 316.w,
          ),
          SizedBox(height: 103.h),
          Container(
            height: 336.h,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                )),
            child: Column(
              children: [
                SizedBox(
                  height: 40.h,
                ),
                Text(
                  'Menjaga Lingkungan',
                  style: TextStyle(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                SizedBox(
                  width: 320.w,
                  height: 72.h,
                  child: Text(
                    'Laporkan masalah yang ada di sekitar\nlingkungan perumahan, baik di tempat\n umum maupun pribadi.',
                    style: TextStyle(fontSize: 16.sp, color: Color(0xff616161)),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 32.h),
                SizedBox(
                  width: 156.w,
                  height: 40.h,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      backgroundColor: Color(0xff2094F3),
                    ),
                    onPressed: () {
                      controller.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    },
                    child: Text(
                      'Selanjutnya',
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Onboarding3 extends StatelessWidget {
  const Onboarding3({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffF2F9FF),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: 80.h),
          SvgPicture.asset(
            'assets/img/image-svg/onboard3.svg',
            height: 233.h,
            width: 316.w,
          ),
          SizedBox(height: 103.h),
          Container(
            height: 336.h,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                )),
            child: Column(
              children: [
                SizedBox(
                  height: 40.h,
                ),
                Text(
                  'Laporkan dan tetap produktif',
                  style: TextStyle(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                SizedBox(
                  width: 320.w,
                  height: 72.h,
                  child: Text(
                    'Laporkan keluhan dan lacak di layar\n ponsel sementara anda bersantai atau\n melakukan produktivitas lainnya.',
                    style: TextStyle(fontSize: 16.sp, color: Color(0xff616161)),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 32.h),
                SizedBox(
                  width: 156.w,
                  height: 40.h,
                  child: TextButton(
                    // minWidth: 156.w,
                    // height: 40.h,
                    onPressed: () {
                      Get.to(() => LoginScreen());
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      backgroundColor: Color(0xff2094F3),
                    ),
                    child: Text(
                      'Masuk',
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//ignore: must_be_immutable
// class OnboardingScreen extends StatelessWidget {
//   double mediaSizeHeight, mediaSizeWidth;

//   @override
//   Widget build(BuildContext context) {
//     mediaSizeHeight =
//         MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
//     mediaSizeWidth = MediaQuery.of(context).size.width;

//     return IntroductionScreen(
//       pages: [
//         PageViewModel(
//             title: '',
//             body: '',
//             image: LottieBuilder.asset('assets/animation/onboard1.json'),
//             footer: Container(
//               color: Colors.white,
//               height: 900,
//             ),
//             decoration: buildPageDecoration(
//                 pageColor: Colors.blue[100].withOpacity(0.5))),
//         PageViewModel(
//             title: 'report it and we will deal with it immediately',
//             body:
//                 'report directly through the application, and we will handle it immediately',
//             image: LottieBuilder.asset('assets/animation/onboard2.json'),
//             // image:
//             //     Image(image: AssetImage('assets/img/image-onboarding/bg2.png')),
//             decoration: buildPageDecoration(
//                 pageColor: Colors.green[100].withOpacity(0.5))),
//         PageViewModel(
//             title: 'payment process via app',
//             body: 'Pay every bill easily by uploading screenshot proof',
//             // image:Image(image: AssetImage('assets/img/image-onboarding/bg3.png')),
//             image: LottieBuilder.asset('assets/animation/onboard3.json'),
//             footer: FlatButton(
//               textColor: Colors.white,
//               padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
//               child: Text(
//                 'Login',
//               ),
//               color: Colors.blue,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20)),
//               onPressed: () {
//                 Navigator.of(context).pushReplacement(MaterialPageRoute(
//                     builder: (context) => LoginScreen(
//                           controllerIpl: TextEditingController(),
//                         )));
//               },
//             ),
//             decoration: buildPageDecoration(
//                 pageColor: Colors.yellow[100].withOpacity(0.5))),
//       ],
//       done: Text(
//         'Login',
//         style: TextStyle(fontFamily: 'poppins', fontSize: 16),
//       ),
//       onDone: () {
//         Navigator.of(context).pushReplacement(
//             MaterialPageRoute(builder: (context) => LoginScreen()));
//       },
//       // showSkipButton: true,
//       // skip: Text(
//       //   'SKIP',
//       //   style: TextStyle(fontFamily: 'poppins', fontSize: 16),
//       // ),
//       // next: Icon(
//       //   Icons.arrow_forward,
//       //   size: 25,
//       // ),
//       // dotsDecorator: buildDotsDecorator(),
//     );
//   }

//   DotsDecorator buildDotsDecorator() {
//     return DotsDecorator(
//         color: Colors.lightBlue,
//         activeColor: Colors.blue,
//         size: Size.square(10),
//         activeSize: Size(mediaSizeWidth * 0.08, 12),
//         activeShape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)));
//   }

//   PageDecoration buildPageDecoration({Color pageColor}) {
//     return PageDecoration(
//         titleTextStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
//         imagePadding: EdgeInsets.only(top: 90),
//         contentPadding: EdgeInsets.all(20),
//         pageColor: pageColor ?? Colors.white,
//         bodyTextStyle: TextStyle(
//           fontSize: 21,
//           fontWeight: FontWeight.bold,
//         ));
//   }
// }
