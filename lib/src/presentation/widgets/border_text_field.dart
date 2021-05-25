import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:rxdart/rxdart.dart';

class BorderTextField extends StatefulWidget {
  BorderTextField(
      {this.height = 50,
      this.color = Colors.white,
      this.textPaddingLeft = 10,
      this.textPaddingRight = 5,
      this.transformText = 0,
      this.borderWidth = 1.0,
      this.borderColor,
      this.isChangeBorderColor = false,
      this.borderRadius,
      this.textController,
      this.fontSize,
      this.fontWeight = FontWeight.normal,
      this.textColor = Colors.black,
      this.keyboardType = TextInputType.text,
      this.inputBorder = InputBorder.none,
      this.hintText,
      this.hintTextFontSize,
      this.hintTextFontWeight = FontWeight.normal,
      this.textAlign = TextAlign.left});

  double height;
  Color color;
  double textPaddingLeft;
  double textPaddingRight;
  double transformText;
  double borderWidth;
  Color borderColor;
  bool isChangeBorderColor;
  double borderRadius;
  TextEditingController textController;
  double fontSize;
  FontWeight fontWeight;
  Color textColor;
  TextInputType keyboardType;
  InputBorder inputBorder;
  String hintText;
  double hintTextFontSize;
  FontWeight hintTextFontWeight;
  TextAlign textAlign;

  @override
  BorderTextFieldState createState() => BorderTextFieldState();
}

class BorderTextFieldState extends State<BorderTextField> {
  final borderColorSubject = BehaviorSubject<Color>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    borderColorSubject.sink.add(widget.borderColor);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    borderColorSubject.close();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: borderColorSubject.stream,
        builder: (context, snapshot) => snapshot.hasData
            ? Container(
                height: widget.height,
                padding: EdgeInsets.only(left: widget.textPaddingLeft, right: widget.textPaddingRight),
                decoration: BoxDecoration(
                    color: widget.color,
                    border: Border.all(width: widget.borderWidth, color: snapshot.data),
                    borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius))),
                child: Container(
                    transform: Matrix4.translationValues(0.0, widget.transformText, 0.0),
                    child: TextField(
                      controller: widget.textController,
                      style: TextStyle(fontSize: widget.fontSize, fontWeight: widget.fontWeight, color: widget.textColor),
                      keyboardType: widget.keyboardType,
                      onTap: widget.isChangeBorderColor
                          ? () {
                              borderColorSubject.sink.add(AppColors.blue);
                            }
                          : null,
                      decoration: InputDecoration(
                          border: widget.inputBorder,
                          hintText: widget.hintText,
                          hintStyle: TextStyle(
                              color: AppColors.hintText, fontSize: widget.hintTextFontSize, fontWeight: widget.hintTextFontWeight)),
                      textAlign: widget.textAlign,
                    )))
            : Container());
  }
}
