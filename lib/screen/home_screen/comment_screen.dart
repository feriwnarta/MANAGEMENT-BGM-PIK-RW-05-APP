import 'package:aplikasi_rw/controller/comment_user_controller.dart';
import 'package:aplikasi_rw/controller/status_user_controller.dart';
import 'package:aplikasi_rw/model/comment_model.dart';
import 'package:aplikasi_rw/services/add_comment_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:sizer/sizer.dart' as sw;
// import 'package:flutter_screenutil/flutter_screenutil.dart';

//ignore: must_be_immutable
class CommentScreen extends StatefulWidget {
  // bloc
  String idStatus;

  CommentScreen({this.idStatus});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController controllerWriteStatus = TextEditingController();
  bool _isValidate = false;
  CommentUserController commentController;
  ScrollController scrollcontroller = ScrollController();
  StatusUserController statusController = Get.find<StatusUserController>();

  void onScroll() {
    if (scrollcontroller.position.maxScrollExtent ==
        scrollcontroller.position.pixels) {
      commentController.getComment(idStatus: widget.idStatus);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scrollcontroller.addListener(onScroll);
  }

  @override
  void initState() {
    super.initState();
    commentController = Get.put(CommentUserController());
  }

  @override
  void dispose() {
    scrollcontroller.dispose();
    Get.delete<CommentUserController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Container(
        padding: EdgeInsets.all(0.6.h),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        height: 60.0.h,
        child: WillPopScope(
          onWillPop: () async {
            commentController.listComment = <CommentModel>[].obs;
            return true;
          },
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(5.0.h),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 10.0.w,
                    ),
                    Text(
                      // '${CommentModel.getAllComment().length} Comment',
                      'comment',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12.0.sp),
                    ),
                    IconButton(
                      icon: Icon(Icons.clear_rounded),
                      onPressed: () {
                        commentController.listComment = <CommentModel>[].obs;
                        commentController.isMaxReached = false.obs;
                        Navigator.of(context).pop();
                      },
                    )
                  ]),
            ),
            body: Stack(children: [
              Container(
                  height: 47.0.h,
                  child: GetX<CommentUserController>(
                    initState: (state) =>
                        commentController.getComment(idStatus: widget.idStatus),
                    builder: (controller) {
                      if (controller.isLoading.value) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: SizedBox(
                              width: 5.0.w,
                              height: 3.0.h,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        );
                      } else {
                        if (controller.listComment.length > 0) {
                          return ListView.builder(
                            physics: ScrollPhysics(),
                            controller: scrollcontroller,
                            shrinkWrap: true,
                            itemCount: (controller.isMaxReached.value)
                                ? controller.listComment.length
                                : controller.listComment.length + 1,
                            itemBuilder: (context, index) => (index <
                                    controller.listComment.length)
                                ? buildColumnComment(
                                    controller.listComment[index].urlImage,
                                    controller.listComment[index].userName,
                                    controller.listComment[index].date,
                                    controller.listComment[index].comment)
                                : (controller.listComment.length == index)
                                    ? SizedBox()
                                    : Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 1.0.h),
                                        child: Center(
                                          child: SizedBox(
                                            width: 10.0.w,
                                            height: 5.0.h,
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                      ),
                          );
                        } else {
                          return Center(
                              child: Text(
                            'No comment',
                            style: TextStyle(fontSize: 13.sp),
                          ));
                        }
                      }
                    },
                  )),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 7.0.h,
                    padding: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 1,
                          spreadRadius: 1)
                    ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 83.0.w,
                          child: TextField(
                            controller: controllerWriteStatus,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.grey[200],
                                hintText: 'write status',
                                errorText: (_isValidate)
                                    ? 'comment can\'t be empty'
                                    : null),
                            style: TextStyle(fontSize: 12.0.sp),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: IconButton(
                              icon: Icon(
                                Icons.arrow_forward,
                                size: 4.0.h,
                              ),
                              onPressed: () async {
                                String m = await AddCommentServices.addComment(
                                    widget.idStatus,
                                    controllerWriteStatus.text,
                                    context);
                                if (m.isCaseInsensitiveContainsAny('SUCCESS')) {
                                  commentController
                                      .refreshComment(widget.idStatus);
                                  await statusController.refreshStatus();
                                  Navigator.of(context).pop();
                                } else {
                                  Get.snackbar(
                                      'message', 'gagal mengirim komen',
                                      snackPosition: SnackPosition.BOTTOM);
                                  Navigator.of(context).pop();
                                }
                                controllerWriteStatus.text = '';
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              }),
                        )
                      ],
                    ),
                  )
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }

  Column buildColumnComment(
      String urlUserComment, String userName, String date, String comment) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(urlUserComment),
            radius: 3.5.h,
          ),
          title: Text(
            userName,
            style: TextStyle(fontSize: 11.0.sp),
          ),
          subtitle: Text(date, style: TextStyle(fontSize: 9.0.sp)),
        ),
        Row(
          children: [
            SizedBox(
              width: 5.0.w,
            ),
            Expanded(
              child: Text(
                comment,
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 12.0.sp),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 1.0.h,
        ),
        Divider(
          thickness: 1,
        )
      ],
    );
  }
}
