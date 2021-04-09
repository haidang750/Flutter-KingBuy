// Ảnh 47 - Điều khoản sử dụng
import 'package:flutter/material.dart';

class TermsOfUse extends StatefulWidget {
  @override
  _TermsOfUseState createState() => _TermsOfUseState();
}

class _TermsOfUseState extends State<TermsOfUse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Điều khoản sử dụng")),
        body: Container(
          child: Center(
            child: Text("Điều khoản sử dụng"),
          ),
        ));
  }
}
