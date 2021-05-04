import 'package:flutter/material.dart';

class RatingAndComment extends StatefulWidget {
  @override
  RatingAndCommentState createState() => RatingAndCommentState();
}

class RatingAndCommentState extends State<RatingAndComment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Đánh giá & Bình luận"), titleSpacing: 0), body: Center(child: Text("Đánh giá & Bình luận")));
  }
}
