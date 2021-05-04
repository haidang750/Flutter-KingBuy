import 'package:flutter/material.dart';

class WritingComment extends StatefulWidget {
  @override
  WritingCommentState createState() => WritingCommentState();
}

class WritingCommentState extends State<WritingComment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Viết đánh giá"), titleSpacing: 0), body: Center(child: Text("Viết đánh giá")));
  }
}
