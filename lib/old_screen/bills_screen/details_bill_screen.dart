import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsBillScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65.0.h,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      child: Column(
        children: [
          buildContainerHeader(context),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 7.0.w),
            height: 50.0.h,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 1.h,
                  ),
                  Text(
                    'Detail Bill',
                    style: TextStyle(
                        fontSize: 17.0.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  ListView.builder(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 7,
                      itemBuilder: (context, index) => Padding(
                            padding: EdgeInsets.only(bottom: 1.5.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Payment ${index + 1}',
                                  style: TextStyle(
                                      fontSize: 13.0.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${(index + 1) * 100000} IDR',
                                  style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 13.0.sp),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(
                                  width: 10.0.w,
                                )
                              ],
                            ),
                          )),
                  Divider(
                    thickness: 1,
                  ),
                  SizedBox(
                    height: 1.0.h,
                  ),
                  Row(
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                            fontSize: 14.0.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 30.0.w,
                      ),
                      Text('2.800.000 IDR',
                          style: TextStyle(fontSize: 14.0.sp)),
                    ],
                  ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  SizedBox(
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
                        'Pay',
                        style: TextStyle(fontSize: 11.0.sp),
                      ),
                      onPressed: () {},
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildContainerHeader(BuildContext context) {
    return Container(
      height: 8.0.h,
      width: 100.0.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          gradient: LinearGradient(
              colors: [Color(0xff3ABBFD), Color(0xff2297F4)],
              begin: Alignment.topLeft,
              end: Alignment.topRight)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'My Bill Detail',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17.0.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 40.0.w),
          IconButton(
              icon: Icon(
                Icons.clear_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              })
        ],
      ),
    );
  }
}
