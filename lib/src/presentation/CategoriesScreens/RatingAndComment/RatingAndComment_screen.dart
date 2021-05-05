import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/CategoriesScreens/CategoriesScreens.dart';
import 'package:projectui/src/presentation/base/base_widget.dart';

class RatingAndComment extends StatefulWidget {
  @override
  RatingAndCommentState createState() => RatingAndCommentState();
}

class RatingAndCommentState extends State<RatingAndComment> with ResponsiveWidget {
  final ratingAndCommentViewModel = RatingAndCommentViewModel();

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: ratingAndCommentViewModel,
        builder: (context, viewModel, child) => Scaffold(
            appBar: AppBar(
                title: Text("Đánh giá & Bình "
                    "luận"),
                titleSpacing: 0),
            body: buildUi(context: context)));
  }

  Widget buildScreen() {
    return Center(child: Text("Đánh giá & Bình luận"));
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
