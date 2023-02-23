import 'package:aplikasi_rw/routes/app_routes.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//ignore: must_be_immutable
class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({Key key}) : super(key: key);

  PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            children: [
              Onboarding1(
                controller: _controller,
                image: 'assets/img/image-svg/rafiki.svg',
                title: 'Berbagi Informasi Apapun',
                subtitle:
                    'Berbagi informasi melalui unggahan foto,\nvideo dan dapat meninggalkan komentar \nsatu sama lain.',
                onPressed: () {
                  _controller.nextPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                  );
                },
                buttonText: 'Selanjutnya',
              ),
              Onboarding1(
                controller: _controller,
                image: 'assets/img/image-svg/onboard2.svg',
                title: 'Menjaga Lingkungan',
                subtitle:
                    'Laporkan masalah yang ada di sekitar\nlingkungan perumahan, baik di tempat\n umum maupun pribadi.',
                onPressed: () {
                  _controller.nextPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                  );
                },
                buttonText: 'Selanjutnya',
              ),
              Onboarding1(
                controller: _controller,
                image: 'assets/img/image-svg/onboard3.svg',
                title: 'Laporkan dan tetap produktif',
                subtitle:
                    'Laporkan keluhan dan lacak di layar ponsel sementara anda bersantai atau melakukan produktivitas lainnya.',
                onPressed: () {
                  Get.offNamed(RouteName.auth);
                },
                buttonText: 'Masuk',
              ),
            ],
          ),
          // dot
          Container(
            alignment: Alignment(0, 0.88),
            child: SmoothPageIndicator(
              count: 3,
              controller: _controller,
              effect: SlideEffect(
                dotHeight: SizeConfig.height(12),
                dotWidth: SizeConfig.width(10),
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
  const Onboarding1(
      {Key key,
      this.controller,
      this.image,
      this.title,
      this.subtitle,
      this.buttonText,
      this.onPressed})
      : super(key: key);

  final PageController controller;

  final String image, title, subtitle, buttonText;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));
    return Container(
      color: Color(0xffF2F9FF),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: SizeConfig.height(80)),
          SvgPicture.asset(
            image,
            height: SizeConfig.height(233),
            width: SizeConfig.width(316),
          ),
          SizedBox(height: SizeConfig.height(103)),
          Container(
            height: SizeConfig.height(336),
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
                  height: SizeConfig.height(40),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: SizeConfig.text(19),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: SizeConfig.height(16),
                ),
                SizedBox(
                  width: SizeConfig.width(320),
                  height: SizeConfig.height(72),
                  child: Text(
                    subtitle,
                    style: TextStyle(
                        fontSize: SizeConfig.text(16),
                        color: Color(0xff616161)),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: SizeConfig.height(32)),
                SizedBox(
                  width: SizeConfig.width(156),
                  height: SizeConfig.height(40),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      // minWidth: 156.w,
                      // height: 40.h,
                      backgroundColor: Color(0xff2094F3),

                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    onPressed: onPressed,
                    child: Text(
                      buttonText,
                      style: TextStyle(
                          color: Colors.white, fontSize: SizeConfig.text(16)),
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
