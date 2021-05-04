import 'package:flutter/material.dart';

class BorderTextField extends StatefulWidget {
  BorderTextField(
      {this.height = 50,
        this.color = Colors.white,
      this.textPaddingLeft = 10,
      this.textPaddingRight = 5,
      this.borderWidth = 1.0,
      this.borderColor,
      this.borderRadius,
      this.textController,
      this.fontSize,
      this.fontWeight = FontWeight.normal,
      this.textColor = Colors.black,
      this.keyboardType = TextInputType.text,
      this.inputBorder = InputBorder.none,
      this.hintText,
      this.hintTextFontSize,
      this.hintTextFontWeight,
      this.textAlign = TextAlign.left});
  double height;
  Color color;
  double textPaddingLeft;
  double textPaddingRight;
  double borderWidth;
  Color borderColor;
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
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      padding: EdgeInsets.only(
          left: widget.textPaddingLeft, right: widget.textPaddingRight),
      decoration: BoxDecoration(
          color: widget.color,
          border:
              Border.all(width: widget.borderWidth, color: widget.borderColor),
          borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius))),
      child: TextField(
        controller: widget.textController,
        style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: widget.fontWeight,
            color: widget.textColor),
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
            border: widget.inputBorder,
            hintText: widget.hintText,
            hintStyle: TextStyle(
                fontSize: widget.hintTextFontSize,
                fontWeight: widget.hintTextFontWeight)),
        textAlign: widget.textAlign,
      ),
    );
  }
}
