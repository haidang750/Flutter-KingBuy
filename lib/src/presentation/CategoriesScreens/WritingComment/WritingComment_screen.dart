import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/CategoriesScreens/CategoriesScreens.dart';
import 'package:projectui/src/presentation/base/base.dart';

class WritingComment extends StatefulWidget {
  @override
  WritingCommentState createState() => WritingCommentState();
}

class WritingCommentState extends State<WritingComment> with ResponsiveWidget {
  final writingCommentViewModel = WritingCommentViewModel();

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: writingCommentViewModel,
        builder: (context, viewModel, child) =>
            Scaffold(appBar: AppBar(title: Text("Viết đánh giá"), titleSpacing: 0), body: buildUi(context: context)));
  }

  Widget buildScreen() {
    return Center(child: Text("Viết đánh giá"));
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
