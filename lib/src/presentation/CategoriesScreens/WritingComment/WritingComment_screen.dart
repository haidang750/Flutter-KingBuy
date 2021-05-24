import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/CategoriesScreens/CategoriesScreens.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/resource/model/Data.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:toast/toast.dart';

class WritingComment extends StatefulWidget {
  WritingComment({this.productId});

  int productId;

  @override
  WritingCommentState createState() => WritingCommentState();
}

class WritingCommentState extends State<WritingComment> with ResponsiveWidget {
  final writingCommentViewModel = WritingCommentViewModel();
  final productDetailViewModel = ProductDetailViewModel();
  final commentController = TextEditingController();
  final ratingSubject = BehaviorSubject<double>();
  final nameUserSubject = BehaviorSubject<String>();
  final phoneNumberUserSubject = BehaviorSubject<String>();

  @override
  void initState() {
    super.initState();
    ratingSubject.sink.add(0.0);
  }

  @override
  void dispose() {
    super.dispose();
    ratingSubject.close();
    nameUserSubject.close();
    phoneNumberUserSubject.close();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: writingCommentViewModel,
        builder: (context, viewModel, child) => Scaffold(appBar: buildAppBar(), body: buildUi(context: context)));
  }

  Widget buildAppBar() {
    return AppBar(title: Text("Viết đánh giá"), titleSpacing: 0, actions: [
      Padding(
        padding: EdgeInsets.only(right: 10, top: 14, bottom: 10),
        child: StreamBuilder(
          stream: ratingSubject.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ButtonTheme(
                  minWidth: 66,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  disabledColor: Colors.grey,
                  buttonColor: AppColors.primary,
                  child: RaisedButton(
                      child: Text("GỬI",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.white,
                          )),
                      onPressed: snapshot.data == 0
                          ? null
                          : () async {
                              int status = await writingCommentViewModel.userRatingProduct(widget.productId, nameUserSubject.stream.value,
                                  phoneNumberUserSubject.stream.value, commentController.text, ratingSubject.stream.value);
                              if (status == 1) {
                                await productDetailViewModel.ratingInfoByProduct(context, widget.productId);
                                await productDetailViewModel.getReviewByProduct(context, widget.productId);
                                SchedulerBinding.instance.addPostFrameCallback((_) {
                                  Toast.show("Đánh giá đã được gửi đi", context, gravity: Toast.CENTER);
                                  Navigator.pop(context);
                                });
                              } else {
                                Toast.show("Đánh giá thất bại", context, gravity: Toast.CENTER);
                              }
                            }));
            } else {
              return Container();
            }
          },
        ),
      ),
    ]);
  }

  Widget buildScreen() {
    Data userData = Provider.of<Data>(context, listen: true);
    nameUserSubject.sink.add(userData.profile.name);
    phoneNumberUserSubject.sink.add(userData.profile.phoneNumber);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Đánh giá của bạn", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: 40,
                      itemBuilder: (context, _) => Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                          ),
                      onRatingUpdate: (value) => ratingSubject.sink.add(value)),
                ],
              ),
            ),
            BorderTextField(
              height: 100,
              color: AppColors.white,
              textPaddingLeft: 5,
              textPaddingRight: 5,
              transformText: -10,
              borderWidth: 0,
              borderColor: AppColors.white,
              borderRadius: 0,
              textController: commentController,
              fontSize: 14,
              hintText: "Nhập Bình luận/Nhận xét tại đây",
              hintTextFontSize: 14,
            ),
            Container(height: 0.5, color: AppColors.grey),
            SizedBox(height: 30),
            Text(userData.profile.name, style: TextStyle(fontSize: 14)),
            SizedBox(height: 6),
            Container(height: 0.5, color: AppColors.grey),
            SizedBox(height: 17),
            Text(userData.profile.phoneNumber, style: TextStyle(fontSize: 14)),
            SizedBox(height: 6),
            Container(height: 0.5, color: AppColors.grey)
          ],
        ),
      ),
    );
  }

  @override
  Widget buildDesktop(BuildContext context) {
    // TODO: implement buildDesktop
    return buildScreen();
  }

  @override
  Widget buildMobile(BuildContext context) {
    // TODO: implement buildMobile
    return buildScreen();
  }

  @override
  Widget buildTablet(BuildContext context) {
    // TODO: implement buildTablet
    return buildScreen();
  }
}
