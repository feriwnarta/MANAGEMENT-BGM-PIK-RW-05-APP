import 'package:aplikasi_rw/modules/home/models/category_request.dart';
import 'package:aplikasi_rw/modules/home/screens/garbage_collection_screen.dart';
import 'package:aplikasi_rw/modules/home/services/category_request_service.dart';
import 'package:aplikasi_rw/modules/report_screen/screens/add_complaint.dart';
import 'package:aplikasi_rw/modules/theme/sizer.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/utils/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CategoryPermintaan extends StatefulWidget {
  const CategoryPermintaan({Key key}) : super(key: key);

  @override
  State<CategoryPermintaan> createState() => _CategoryPermintaanState();
}

class _CategoryPermintaanState extends State<CategoryPermintaan> {
  StepperController stepperController;

  @override
  void initState() {
    super.initState();
    stepperController = Get.put(StepperController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pilih Kategori',
          style: TextStyle(fontSize: SizeConfig.text(19)),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              children: [
                stepper(stepperController: stepperController),
                IndexedStack(
                  index: stepperController.index.value,
                  children: [
                    category(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget category() {
    return FutureBuilder<List<CategoryRequest>>(
        future: CategoryRequestService.getCategoryRequest(),
        builder: (context, snapshot) => (snapshot.hasData)
            ? Wrap(
                alignment: WrapAlignment.center,
                spacing: SizeConfig.width(20),
                runSpacing: SizeConfig.height(20),
                children: snapshot.data
                    .map<Widget>((category) => InkWell(
                          onTap: () {
                            if (category.category != 'Kantong Sampah') {
                              EasyLoading.showInfo('Dalam Pengembangan');
                              return;
                            }

                            Get.to(
                              () => GarbageCollectionScreen(),
                              transition: Transition.rightToLeft,
                            );
                          },
                          child: SizedBox(
                            width: SizeConfig.width(96),
                            child: Column(
                              children: [
                                CachedNetworkImage(
                                  imageUrl:
                                      '${ServerApp.url}icon/${category.icon}',
                                  width: SizeConfig.image(96),
                                  height: SizeConfig.image(96),
                                  alignment: Alignment.center,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => SizedBox(
                                    height: SizeConfig.height(20),
                                    child: CircularProgressIndicator.adaptive(
                                        value: 0.5),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                                Text(
                                  '${category.category}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: SizeConfig.text(12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              )
            : CircularProgressIndicator.adaptive());
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
              SizedBox(width: SizeConfig.width(8)),
              SvgPicture.asset('assets/img/image-svg/chevron-icon.svg',
                  color: (stepperController.index.value == 0)
                      ? Colors.grey
                      : Colors.blue),
              SizedBox(width: SizeConfig.width(8)),
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
              SizedBox(width: SizeConfig.width(8)),
              SvgPicture.asset('assets/img/image-svg/chevron-icon.svg',
                  color: stepperController.index.value > 1
                      ? Colors.blue
                      : Colors.grey),
              SizedBox(width: SizeConfig.width(8)),
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
              SizedBox(width: SizeConfig.width(8)),
              SvgPicture.asset('assets/img/image-svg/chevron-icon.svg',
                  color: stepperController.index.value == 3
                      ? Colors.blue
                      : Colors.grey),
              SizedBox(width: SizeConfig.width(8)),
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
          style: TextStyle(fontSize: SizeConfig.text(12), color: colorText),
        ),
      ],
    );
  }
}
