import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/categories_screens/categories_screens.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/resource/model/data.dart';
import 'package:provider/provider.dart';

class WritingComment extends StatefulWidget {
  WritingComment({this.productId});

  int productId;

  @override
  WritingCommentState createState() => WritingCommentState();
}

class WritingCommentState extends State<WritingComment> with ResponsiveWidget {
  WritingCommentViewModel writingCommentViewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: WritingCommentViewModel(),
        onViewModelReady: (viewModel) => writingCommentViewModel = viewModel..init(),
        builder: (context, viewModel, child) => Scaffold(appBar: buildAppBar(), body: buildUi(context: context)));
  }

  Widget buildAppBar() {
    return AppBar(title: Text("Viết đánh giá"), titleSpacing: 0, actions: [
      Padding(
        padding: EdgeInsets.only(right: 10, top: 14, bottom: 10),
        child: StreamBuilder(
          stream: writingCommentViewModel.ratingSubject.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ButtonTheme(
                  minWidth: 66,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  disabledColor: Colors.grey,
                  buttonColor: AppColors.primary,
                  child: RaisedButton(
                      child: Text("GỬI", style: TextStyle(fontSize: 16, color: AppColors.white)),
                      onPressed: snapshot.data == 0
                          ? null
                          : () {
                              writingCommentViewModel.sendComment(widget.productId);
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
    writingCommentViewModel.nameUserSubject.sink.add(userData.profile.name);
    writingCommentViewModel.phoneNumberUserSubject.sink.add(userData.profile.phoneNumber);

    return Container(
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
                    onRatingUpdate: (value) => writingCommentViewModel.ratingSubject.sink.add(value)),
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
            textController: writingCommentViewModel.commentController,
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
