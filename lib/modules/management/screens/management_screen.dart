import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import '../../contractor/screens/complaint/complaint_screen.dart';
import './home_management_screen.dart';

class ManagementScreen extends StatefulWidget {
  ManagementScreen({Key key}) : super(key: key);

  @override
  _ManagementScreenState createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  int _index = 0;

  final _screen = [
    HomeManagementScreen(),
    ComplaintScreen(),
    Container(
      color: Colors.white,
      child: Center(child: Text('On Progress')),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: IndexedStack(
          children: _screen,
          index: _index,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)]),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            // iconSize: 6.0.w,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.black54,
            currentIndex: _index,
            onTap: (index) {
              setState(() {
                _index = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/img/image-svg/home-management.svg',
                  color: (_index == 0) ? Colors.blue : Colors.black54,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/img/image-svg/complaint.svg',
                    color: (_index == 1) ? Colors.blue : Colors.black54,
                  ),
                  label: 'Report'),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/img/image-svg/report.svg',
                  color: (_index == 2) ? Colors.blue : Colors.black54,
                ),
                label: 'Report',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
