import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:projectui/src/configs/configs.dart';

class MyNetworkImage extends StatefulWidget {
  MyNetworkImage({this.height, this.width, this.url, this.sizePlaceHolder = 30, this.sizeErrorBuilder = 36});
  double height;
  double width;
  String url;
  double sizePlaceHolder;
  double sizeErrorBuilder;

  @override
  MyNetworkImageState createState() => MyNetworkImageState();
}

class MyNetworkImageState extends State<MyNetworkImage> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: widget.height,
      width: widget.width,
      fit: BoxFit.fill,
      imageUrl: Uri.encodeFull(widget.url),
      placeholder: (context, url) => Center(
        child: SpinKitCircle(
          color: Colors.blue,
          size: widget.sizePlaceHolder,
        ),
      ),
      errorWidget: (context, url, error) => Image.asset(AppImages.errorImage, fit: BoxFit.fill)
    );
  }
}
