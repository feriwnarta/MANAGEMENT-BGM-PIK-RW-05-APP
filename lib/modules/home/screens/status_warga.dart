import 'package:aplikasi_rw/screen/home_screen/comment_screen.dart';
import 'package:aplikasi_rw/screen/report_screen2/view_image.dart';
import 'package:aplikasi_rw/server-app.dart';
import 'package:aplikasi_rw/services/like_status_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//ignore: must_be_immutable
class StatusWarga extends StatefulWidget {
  String userName,
      uploadTime,
      urlStatusImage,
      fotoProfile,
      caption,
      numberOfLikes,
      idStatus,
      numberOfComments,
      idUser;
  int isLike;

  // Container untuk data
  StatusWarga(
      {this.userName,
      this.uploadTime,
      this.urlStatusImage,
      this.fotoProfile,
      this.caption,
      this.numberOfLikes,
      this.numberOfComments,
      this.idStatus,
      this.idUser,
      this.isLike});

  @override
  _StatusWargaState createState() => _StatusWargaState();
}

class _StatusWargaState extends State<StatusWarga> {
  bool isLoading = true;
  var isLike = false.obs;
  String numberLike = '0';
  final logger = Logger();

  @override
  void initState() {
    super.initState();
  }

  Future<String> updateButtonLike() async {
    int value = await LikeStatusService.isLike(
        idStatus: widget.idStatus, idUser: widget.idUser);

    if (value >= 1) {
      isLike = true.obs;
      return 'OKE';
    } else {
      isLike = false.obs;
      return 'FALSE';
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('update');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // logger.w('rebuild widget' + widget.idStatus);
    return FutureBuilder(
        future: updateButtonLike(),
        builder: (context, snapshot) => (snapshot.hasData)
            ? buildContainerSosmed(context)
            : ShimerSosmed());
  }

  Container buildContainerSosmed(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 2)]),

      // top : 10, left: 10, right: 10
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Column(
        children: [
          Row(children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: CachedNetworkImageProvider(
                    '${ServerApp.url}${widget.fotoProfile}'),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 3),
                    child: Text(
                      widget.userName,
                      style: TextStyle(fontSize: 9.0.sp),
                    ),
                  ),
                  Text(
                    '${widget.uploadTime}',
                    style: TextStyle(fontSize: 9.0.sp),
                  )
                ],
              ),
            )
          ]),

          // // bagian caption
          // Padding(
          //   padding: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 10),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: ReadMoreText(
          //           widget.caption,
          //           trimLines: 3,
          //           trimMode: TrimMode.Line,
          //           trimCollapsedText: 'Read More',
          //           trimExpandedText: 'Read Less',
          //           textAlign: TextAlign.justify,
          //           style: TextStyle(fontSize: 11.0.sp),
          //         ),
          //       )
          //     ],
          //   ),
          // ),

          (widget.urlStatusImage.contains('no_image'))
              ? SizedBox()
              : SizedBox(height: 16.h),

          // Bagian foto
          Row(
            children: [
              Visibility(
                visible:
                    (widget.urlStatusImage.contains('no_image')) ? false : true,
                child: Container(
                  child: Expanded(
                    flex: 1,
                    child: GestureDetector(
                      // child: FadeInImage(
                      //   imageErrorBuilder: (BuildContext context,
                      //       Object exception, StackTrace stackTrace) {
                      //     print('Error Handler');
                      //     return Container(
                      //       height: 40.0.h,
                      //       child: Icon(Icons.error),
                      //     );
                      //   },
                      //   placeholder: AssetImage('assets/img/loading.gif'),
                      //   image: CachedNetworkImageProvider(
                      //     '${widget.urlStatusImage}',
                      //   ),
                      //   fit: BoxFit.cover,
                      //   height: 40.0.h,
                      // ),
                      child: Image(
                        image: CachedNetworkImageProvider(
                          '${widget.urlStatusImage}',
                        ),
                        fit: BoxFit.cover,
                        height: 300.h,
                      ),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ViewImage(
                            urlImage: widget.urlStatusImage,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),

          (widget.caption.isNotEmpty) ? SizedBox(height: 16.h) : SizedBox(),

          (widget.caption.isNotEmpty)
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: ReadMoreText(
                          widget.caption,
                          trimLines: 3,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: 'Read More',
                          trimExpandedText: 'Read Less',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Color(0xff404040),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : SizedBox(),

          // Like Dan comment
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Obx(
                      () => ButtonLike(
                        isLike: isLike.value,
                        widget: widget,
                        numberLike: widget.numberOfLikes,
                      ),
                    ),
                  ],
                ),
                ButtonComment(
                    widget: widget, countComment: widget.numberOfComments)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShimerSosmed extends StatelessWidget {
  const ShimerSosmed({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15.h),
        Row(
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[200],
              child: Container(
                height: 50.h,
                width: 50.w,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 1,
                    )),
              ),
            ),
            SizedBox(width: 2.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[200],
                    child: Container(
                      width: 60.w,
                      height: 10.h,
                      color: Colors.grey,
                    )),
                SizedBox(
                  height: 5.h,
                ),
                Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[200],
                    child: Container(
                      width: 100.w,
                      height: 10.h,
                      color: Colors.grey,
                    )),
              ],
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[200],
            child: Container(
              margin: EdgeInsets.only(left: 10.w),
              width: 340.w,
              height: 10.h,
              color: Colors.grey,
            )),
        SizedBox(height: 10.h),
        Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[200],
            child: Container(
              margin: EdgeInsets.only(left: 10.w),
              width: 340.w,
              height: 10.h,
              color: Colors.grey,
            )),
        SizedBox(height: 10.h),
        Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[200],
            child: Container(
              margin: EdgeInsets.only(left: 10.w),
              width: 340.w,
              height: 10.h,
              color: Colors.grey,
            )),
        SizedBox(height: 10.h),
        Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[200],
            child: Container(
              margin: EdgeInsets.only(left: 10.w),
              width: 340.w,
              height: 10.h,
              color: Colors.grey,
            )),
        SizedBox(height: 10.h),
        Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[200],
            child: Container(
              margin: EdgeInsets.only(left: 10.w),
              width: 340.w,
              height: 10.h,
              color: Colors.grey,
            )),
        SizedBox(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[200],
                    child: Container(
                      margin: EdgeInsets.only(left: 10.w),
                      width: 25.w,
                      height: 15.h,
                      color: Colors.grey,
                    )),
                SizedBox(
                  width: 1.w,
                ),
                Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[200],
                    child: Container(
                      margin: EdgeInsets.only(left: 10.w),
                      width: 25.w,
                      height: 15.h,
                      color: Colors.grey,
                    )),
              ],
            ),
            Row(
              children: [
                Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[200],
                    child: Container(
                      margin: EdgeInsets.only(left: 10.w),
                      width: 25.w,
                      height: 15.h,
                      color: Colors.grey,
                    )),
                SizedBox(
                  width: 1.w,
                ),
                Shimmer.fromColors(
                    baseColor: Colors.grey[300],
                    highlightColor: Colors.grey[200],
                    child: Container(
                      margin: EdgeInsets.only(left: 10.w),
                      width: 25.w,
                      height: 15.h,
                      color: Colors.grey,
                    )),
              ],
            )
          ],
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}

//ignore: must_be_immutable
class ButtonLike extends StatefulWidget {
  ButtonLike({
    Key key,
    @required this.isLike,
    @required this.widget,
    @required this.numberLike,
  }) : super(key: key);

  bool isLike;
  StatusWarga widget;
  String numberLike = '0';

  @override
  _ButtonLikeState createState() => _ButtonLikeState();
}

class _ButtonLikeState extends State<ButtonLike> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Row(
        children: [
          IconButton(
            splashColor: Colors.transparent,
            splashRadius: 1,
            icon: SvgPicture.asset(
              'assets/img/image-svg/like-icon.svg',
              color: (widget.isLike) ? Colors.red : Color(0xff424242),
            ),
            // Icon(
            //   Icons.thumb_up_alt_outlined,
            //   color: (widget.isLike) ? Colors.red : Colors.black,
            // ),
            onPressed: () {
              print('button like clicked');
              if (!widget.isLike) {
                LikeStatusService.addLike(
                        idStatus: widget.widget.idStatus,
                        idUser: widget.widget.idUser)
                    .then((value) {
                  if (value == 'OK') {
                    LikeStatusService.getLike(
                            idStatus: widget.widget.idStatus,
                            idUser: widget.widget.idUser)
                        .then((value) {
                      print('jmlah' + value);
                      if (value != null) {
                        setState(() {
                          widget.isLike = true;
                          widget.numberLike = value;
                        });
                      }
                    });
                  }
                });
              } else {
                LikeStatusService.deleteLike(
                        idStatus: widget.widget.idStatus,
                        idUser: widget.widget.idUser)
                    .then((value) {
                  if (value == 'OK') {
                    LikeStatusService.getLike(
                            idStatus: widget.widget.idStatus,
                            idUser: widget.widget.idUser)
                        .then((like) {
                      print('jmlah' + value);
                      if (like != null) {
                        setState(() {
                          print(like);
                          widget.isLike = false;
                          widget.numberLike = like;
                        });
                      }
                    });
                  }
                });
              }
            },
          ),
          (widget.numberLike == '0')
              ? Text('Suka',
                  style: TextStyle(color: Color(0xff404040), fontSize: 10.sp))
              : Text(widget.numberLike,
                  style: TextStyle(color: Color(0xff404040), fontSize: 10.sp))
        ],
      ),
    );
  }
}

class ButtonComment extends StatefulWidget {
  ButtonComment({
    Key key,
    @required this.widget,
    @required this.countComment,
  }) : super(key: key);

  final StatusWarga widget;
  final String countComment;

  @override
  _ButtonCommentState createState() => _ButtonCommentState();
}

class _ButtonCommentState extends State<ButtonComment> {
  // var count = '0'.obs;
  // Timer _timer;

  @override
  void initState() {
    // print('DITEEEEEEEEEEEEEEEEEEEEEEEEEEEEESSSSSSSSSSSSSSSSSS');
    super.initState();
    // getCountComment();
    // _timer = Timer.periodic(Duration(seconds: 5), (timer) {
    //   getCountComment();
    // });
  }

  @override
  void dispose() {
    // Future.delayed(Duration(seconds: 2));
    // if (_timer.isActive) _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // getCountComment();

    return Row(
      children: [
        Material(
          color: Colors.transparent,
          child: IconButton(
            splashColor: Colors.transparent,
            icon: SvgPicture.asset('assets/img/image-svg/comment-icon.svg'),
            onPressed: () {
              showModalBottomSheet(
                  barrierColor: Colors.black.withOpacity(0.4),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  isScrollControlled: true,
                  context: context,
                  // push id comment
                  builder: (context) => CommentScreen(
                        idStatus: widget.widget.idStatus,
                      ));
            },
          ),
        ),
        (widget.countComment == '0')
            ? Text('Komentar',
                style: TextStyle(color: Color(0xff404040), fontSize: 10.sp))
            : Text(widget.countComment,
                style: TextStyle(color: Color(0xff404040), fontSize: 10.sp))
      ],
    );
  }

  void getCountComment() {
    if (widget.countComment != null) {
      // setState(() {
      // count = widget.countComment.obs;
      // });
    }
  }
}
