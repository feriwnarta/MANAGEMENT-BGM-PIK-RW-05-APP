import 'package:aplikasi_rw/controller/user_login_controller.dart';
import 'package:aplikasi_rw/screen/cordinator/screen/absen_screen/insert_absen.dart';
import 'package:aplikasi_rw/screen/cordinator/screen/complaint_screen/complaint_screen.dart';
import 'package:aplikasi_rw/screen/cordinator/widget/HomeListOfCard.dart';
import 'package:aplikasi_rw/services/chart_worker/update_chart_worker.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'absen_screen/absen_screen.dart';

// import 'package:logger/logger.dart';
class ChangePageController extends GetxController {
  var _index = 0.obs;
}

//ignore: must_be_immutable
class HomeScreenCordinator extends StatelessWidget {
  String name, status;
  HomeScreenCordinator({this.name});

  final UserLoginController userLogin = Get.put(UserLoginController());
  final pageController = Get.put(ChangePageController());
  // final logger = Logger(printer: PrettyPrinter());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<ChangePageController>(
        builder: (controller) => IndexedStack(children: [
          MenuWorkerScreen(
            name: name,
            userLogin: userLogin,
          ),
          ComplaintScreen(),
          Container(
            child: Center(child: Text('On Progress')),
          ),
          Container(
            child: Center(child: Text('On Progress')),
          ),
          // UserWorker()
        ], index: controller._index.value),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF2094F3),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        currentIndex: pageController._index.value,
        iconSize: 16.0.w,
        onTap: (index) {
          pageController._index = index.obs;
          pageController.update();
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/img/image-svg/home.svg',
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon:
                  SvgPicture.asset('assets/img/image-svg/complaint-white.svg'),
              label: 'Complaint'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/img/image-svg/request.svg'),
              label: 'Request'),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/img/image-svg/laporan.svg'),
            label: 'Laporan',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: SvgPicture.asset('assets/img/image-svg/button_absen.svg'),
        onPressed: () {
          Get.to(() => InsertAbsen());
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class MenuWorkerScreen extends StatefulWidget {
  MenuWorkerScreen({Key key, @required this.name, @required this.userLogin})
      : super(key: key);

  final String name;
  final UserLoginController userLogin;

  @override
  _MenuWorkerScreenState createState() => _MenuWorkerScreenState();
}

class _MenuWorkerScreenState extends State<MenuWorkerScreen> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(104.h),
          child: AppBar(
            // title: Text('Contractor'),
            backgroundColor: Color(0xFF2094F3),
            flexibleSpace: Container(
              padding: EdgeInsets.only(top: 48.h, left: 16.w, right: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (widget.userLogin.status.value == 'cordinator')
                            ? 'Hi, ${widget.userLogin.nameCordinator.value}'
                            : 'Hi, ${widget.userLogin.nameContractor.value}',
                        style: TextStyle(
                            fontFamily: 'inter',
                            fontSize: 19.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Sudahkah cek laporan hari ini ?',
                        style: TextStyle(
                          fontFamily: 'inter',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  // SizedBox(
                  //   height: 20.h,
                  //   child: IconButton(
                  //       splashRadius: 15.h,
                  //       icon: SvgPicture.asset('assets/img/image-svg/bell.svg'),
                  //       padding: EdgeInsets.zero,
                  //       onPressed: () {}),
                  // )
                  InkWell(
                    splashColor: Colors.white,
                    borderRadius: BorderRadius.circular(200),
                    radius: 15.h,
                    onTap: () {},
                    child: Badge(
                      badgeColor: Colors.red,
                      // showBadge: () ? true : false,
                      badgeContent: Text(
                        '0',
                        style: TextStyle(color: Colors.white),
                      ),
                      position: BadgePosition.topEnd(top: -15, end: -10),
                      child: SvgPicture.asset('assets/img/image-svg/bell.svg'),
                      animationType: BadgeAnimationType.scale,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: HomeListOfCard());
  }

  Column menu(String name) {
    return Column(
      children: [
        SizedBox(height: 56.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonIconCordinator(
              asset: 'assets/img/image-svg/Group 4.svg',
              title: 'Complaint',
              navigator: ComplaintScreen(
                name: name,
              ),
            ),
            SizedBox(width: 44.w),
            GestureDetector(
              onTap: () => print('tap'),
              child: ButtonIconCordinator(
                asset: 'assets/img/image-svg/Group 5.svg',
                title: 'Request',
                navigator: Scaffold(
                  appBar: AppBar(
                    title: Text(
                      'Request',
                    ),
                  ),
                  body: Center(child: Text('On Progress')),
                ),
              ),
            ),
            SizedBox(width: 44.w),
            ButtonIconCordinator(
              asset: 'assets/img/image-svg/Group 6.svg',
              title: 'Laporan',
              navigator: Scaffold(
                appBar: AppBar(
                  title: Text(
                    'Laporan',
                  ),
                ),
                body: Center(child: Text('On Progress')),
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonIconCordinator(
                asset: 'assets/img/image-svg/Group 7.svg',
                title: 'Absensi',
                navigator: AbsenScreen()),
            SizedBox(
              width: 124.w,
            ),
            SizedBox(
              width: 124.w,
            ),
          ],
        ),
      ],
    );
  }
}

class DotIcon extends StatelessWidget {
  final Color color;
  const DotIcon({this.color, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8.0.h,
      width: 8.0.w,
      decoration: new BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class ChartData {
  String label, x;
  int point;
  int y;
  ChartData({this.label, this.point});
  ChartData.axis({this.x, this.y});
}

class ButtonDropdown extends StatefulWidget {
  ButtonDropdown({Key key, this.items, this.value, this.future})
      : super(key: key);
  final List<String> items;
  final Map<String, String> value;
  Future<Map<String, dynamic>> future;

  @override
  State<ButtonDropdown> createState() => _ButtonDropdownState();
}

class _ButtonDropdownState extends State<ButtonDropdown> {
  final logger = Logger();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        // Initial Value
        value: null,
        isDense: true,
        underline: null,
        // Down Arrow Icon
        icon: const Icon(Icons.keyboard_arrow_down),
        // Array list of items
        items: widget.items.map((String items) {
          return DropdownMenuItem(
            value: items,
            child: Text(items),
          );
        }).toList(),

        // After selecting the desired option,it will
        // change button value to selected value
        onChanged: (String category) async {
          widget.future =
              UpdateChartWorkerServices.updateChart(category: category);
          // widget.future = await UpdateChartWorkerServices.updateChart(category: category);
        },
      ),
    );
  }
}

//ignore: must_be_immutable
class ButtonIconCordinator extends StatelessWidget {
  ButtonIconCordinator({Key key, this.asset, this.title, this.navigator})
      : super(key: key);
  String asset, title;
  Widget navigator;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(children: [
          Center(
              child: Container(
                  height: 80.w, width: 80.w, child: SvgPicture.asset(asset))),
          Center(
            child: Material(
                color: Colors.transparent,
                child: SizedBox(
                  height: 80.w,
                  width: 80.w,
                  child: new InkWell(
                    borderRadius: BorderRadius.circular(5),
                    splashColor: Colors.grey[100].withOpacity(0.5),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => navigator,
                      ));
                    },
                  ),
                )),
          )
        ]),
        SizedBox(height: 8.h),
        Container(
          width: 69.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontFamily: 'inter',
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class ListOfCard extends StatefulWidget {
  const ListOfCard({Key key}) : super(key: key);

  @override
  State<ListOfCard> createState() => _ListOfCardState();
}

class _ListOfCardState extends State<ListOfCard> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
