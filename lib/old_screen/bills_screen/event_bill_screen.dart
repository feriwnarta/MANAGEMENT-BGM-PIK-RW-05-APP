import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//ignore: must_be_immutable
class EventBillScrenn extends StatelessWidget {
  double mediaSizeHeight, mediaSizeWidth;
  final Color background;

  final String urlHeroImage, titleEvent, price, dueDate;

  EventBillScrenn(
      {this.urlHeroImage,
      this.titleEvent,
      this.price,
      this.dueDate,
      this.background});

  @override
  Widget build(BuildContext context) {
    mediaSizeHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    mediaSizeWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Container(
        height: 62.0.h,
        width: 100.0.w,
        decoration: BoxDecoration(
            color: background, borderRadius: BorderRadius.vertical()),
        child: Column(
          children: [
            CachedNetworkImage(
              width: 100.0.w,
              height: 35.0.h,
              fit: BoxFit.cover,
              repeat: ImageRepeat.noRepeat,
              imageUrl: urlHeroImage,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            SizedBox(height: 2.0.h),
            Center(
              child: Text(
                titleEvent,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.0.sp,
                    fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            SizedBox(
              height: 1.0.h,
            ),
            Material(
              borderRadius: BorderRadius.circular(20),
              elevation: 7,
              child: Container(
                width: 80.0.w,
                height: 15.0.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          )),
                      height: 7.5.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Contribution Amount',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 11.0.sp),
                          ),
                          VerticalDivider(
                            indent: 10,
                            endIndent: 10,
                            color: Colors.black,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('$price IDR',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11.0.sp)),
                              Text(dueDate,
                                  style: TextStyle(
                                      fontSize: 9.0.sp,
                                      color: Colors.grey[700]))
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 1.0.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 30.0.w,
                          height: 4.0.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shadowColor: Colors.red,
                                elevation: 0,
                                foregroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                side: BorderSide(color: background)),
                            child: Text(
                              'See Details',
                              style: TextStyle(
                                  color: background, fontSize: 11.0.sp),
                            ),
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(
                          width: 30.0.w,
                          height: 4.0.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                foregroundColor: background,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                side: BorderSide(color: background)),
                            child: Text(
                              'Pay',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 11.0.sp),
                            ),
                            onPressed: () {},
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
