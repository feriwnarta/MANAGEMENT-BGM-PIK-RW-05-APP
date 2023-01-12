import 'package:aplikasi_rw/modules/report_screen/screens/add_complaint.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// import 'package:table_calendar/table_calendar.dart';

enum SubMenu { Request, Complaint }

class SubMenuReport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 800));
    SubMenu menuRequest = SubMenu.Complaint;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff2196F3),
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
        title: Text(
          'Warga peduli lingkungan',
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: MenuPeduliLingkungan(),
      ),
    );
  }
}

class MenuPeduliLingkungan extends StatefulWidget {
  const MenuPeduliLingkungan({Key key}) : super(key: key);

  @override
  State<MenuPeduliLingkungan> createState() => _MenuPeduliLingkunganState();
}

class _MenuPeduliLingkunganState extends State<MenuPeduliLingkungan> {
  RxBool isActive = true.obs;
  final AssetImage image =
      AssetImage('assets/img/citizen_menu/peduli-lingkungan-umum.jpg');

  final AssetImage image2 =
      AssetImage('assets/img/citizen_menu/peduli-lingkungan-umum.jpg');

  @override
  void didChangeDependencies() {
    precacheImage(image, context);
    precacheImage(image2, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 32.h,
        ),
        Obx(
          () => GestureDetector(
            onTap: () => isActive.value = !isActive.value,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 12.h),
              decoration: (isActive.value)
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: Color(0xff2094F3),
                      ))
                  : BoxDecoration(),
              child: Row(
                children: [
                  Container(
                    width: 70.w,
                    height: 72.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: image,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                  SizedBox(
                    width: 221.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          'Peduli Lingkungan Umum',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        AutoSizeText(
                          'Kepedulian lingkungan yang di tujukan untuk area lingkungan umum yang ada di Bukit Golf Mediterania RW 05.',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff616161),
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 16.h,
        ),
        Obx(
          () => GestureDetector(
            onTap: () => isActive.value = !isActive.value,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 12.h),
              decoration: (!isActive.value)
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: Color(0xff2094F3),
                      ))
                  : BoxDecoration(),
              child: Row(
                children: [
                  Container(
                    width: 70.w,
                    height: 72.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: image2,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                  SizedBox(
                    width: 221.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          'Peduli Lingkungan Pribadi',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        AutoSizeText(
                          'Kepedulian lingkungan yang di tujukan untuk area lingkungan pribadi warga Bukit Golf Mediterania RW 05. ',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff616161),
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 360.h,
        ),
        SizedBox(
          width: 328.w,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            )),
            onPressed: () {
              if (isActive.value) {
                Get.to(() => AddComplaint());
              }
            },
            child: Text(
              'Selanjutnya',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
          ),
        )
      ],
    );
  }
}

//ignore: must_be_immutable
class RadioMenu extends StatefulWidget {
  RadioMenu({
    Key key,
    @required SubMenu menuRequest,
  })  : menuRequest = menuRequest,
        super(key: key);

  SubMenu menuRequest;
  SubMenu menuComplaint = SubMenu.Complaint;

  Color colorBorderComplaint = Colors.grey[300];
  Color colorFontComplaint = Colors.black;
  Color colorBorderReq = Colors.grey[300];
  Color colorFontReq = Colors.black;

  // ReportBloc bloc;

  @override
  _RadioMenuState createState() => _RadioMenuState();
}

class _RadioMenuState extends State<RadioMenu> {
  @override
  void initState() {
    super.initState();
    widget.menuRequest = SubMenu.Complaint;
    widget.colorBorderComplaint = Colors.blue;
    widget.colorFontComplaint = Colors.blue;
  }

  @override
  void dispose() {
    // widget.bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // widget.bloc = BlocProvider.of<ReportBloc>(context);

    return Column(
      children: [
        radioButtonComplaint(),
        radioButtonReq(),
        SizedBox(
          height: 400.h,
        ),
        TextButton(
          style: TextButton.styleFrom(
            // highlightColor: Colors.blue[100],
            padding: EdgeInsets.symmetric(horizontal: 150.w, vertical: 13.h),
            backgroundColor: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            'Lanjut',
            style: TextStyle(color: Colors.white, fontSize: 13.0.sp),
          ),
          onPressed: () {
            if (widget.menuRequest == SubMenu.Complaint) {
              Get.to(() => AddComplaint());
            } else if (widget.menuRequest == SubMenu.Request) {
              EasyLoading.showToast('On Progress');
            }

            // Get.to(() => CameraComplaint());
          },
        )
      ],
    );
  }

  GestureDetector radioButtonComplaint() {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.menuRequest = SubMenu.Complaint;
          widget.colorBorderComplaint = Colors.blue;
          widget.colorFontComplaint = Colors.blue;
          if (widget.colorFontReq == Colors.blue) {
            widget.colorFontReq = Colors.black;
            widget.colorBorderReq = Colors.grey[300];
          }
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 24.h),
        decoration: BoxDecoration(
            border: Border.all(color: widget.colorBorderComplaint),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Radio(
                  groupValue: widget.menuRequest,
                  value: SubMenu.Complaint,
                  onChanged: (SubMenu value) {
                    setState(() {
                      widget.menuRequest = value;
                      widget.colorBorderComplaint = Colors.blue;
                      widget.colorFontComplaint = Colors.blue;
                      if (widget.colorFontReq == Colors.blue) {
                        widget.colorFontReq = Colors.black;
                        widget.colorBorderReq = Colors.grey[300];
                      }
                    });
                  },
                ),
                Text('Peduli lingkungan',
                    style: TextStyle(
                        fontSize: 14.sp, color: widget.colorFontComplaint))
              ],
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Laporan ini di tunjukan untuk permasalahan yang terjadi di area lingkungan pribadi',
                  style: TextStyle(
                      fontSize: 12.sp, color: widget.colorFontComplaint),
                )),
            SizedBox(
              height: 15.h,
            )
          ],
        ),
      ),
    );
  }

  GestureDetector radioButtonReq() {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.menuRequest = SubMenu.Request;
          widget.colorBorderReq = Colors.blue;
          widget.colorFontReq = Colors.blue;
          if (widget.colorFontReq == Colors.blue) {
            widget.colorFontComplaint = Colors.black;
            widget.colorBorderComplaint = Colors.grey[300];
          }
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 12.h),
        decoration: BoxDecoration(
            border: Border.all(color: widget.colorBorderReq),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Radio(
                  groupValue: widget.menuRequest,
                  value: SubMenu.Request,
                  onChanged: (SubMenu value) {
                    setState(() {
                      widget.menuRequest = value;
                      widget.colorBorderReq = Colors.blue;
                      widget.colorFontReq = Colors.blue;
                      if (widget.colorFontComplaint == Colors.blue) {
                        widget.colorBorderComplaint = Colors.black;
                        widget.colorFontComplaint = Colors.grey[300];
                      }
                    });
                  },
                ),
                Text('Permintaan',
                    style:
                        TextStyle(fontSize: 14.sp, color: widget.colorFontReq))
              ],
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Laporan ini ditunjukan untuk permasalahan yang terjadi di area lingkungan RW 05',
                  style: TextStyle(fontSize: 12.sp, color: widget.colorFontReq),
                )),
            SizedBox(
              height: 15.h,
            )
          ],
        ),
      ),
    );
  }
}
