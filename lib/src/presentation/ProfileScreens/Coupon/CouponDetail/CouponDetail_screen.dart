// Chi tiết khuyến mãi
import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/presentation.dart';

class CouponDetail extends StatefulWidget {
  CouponDetail({this.name, this.description, this.image});

  String name;
  String description;
  String image;

  @override
  CouponDetailState createState() => CouponDetailState();
}

class CouponDetailState extends State<CouponDetail> with ResponsiveWidget {
  final couponDetailViewModel = CouponDetailViewModel();

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: couponDetailViewModel,
        builder: (context, viewModel, child) =>
            Scaffold(appBar: AppBar(titleSpacing: 0, title: Text("Chi tiết coupon")), body: buildUi(context: context)));
  }

  Widget buildScreen() {
    return Container(
      child: ListView(
        children: [
          Container(
            height: 240,
            padding: EdgeInsets.fromLTRB(20, 10, 5, 0),
            child: Image.network("https://kingbuy.vn${widget.image}", fit: BoxFit.fill),
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.only(left: 20, right: 10),
            child: Text(
              widget.name,
              style: TextStyle(fontSize: 17, color: AppColors.primary, fontWeight: FontWeight.w700, height: 1.3),
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.only(left: 20, right: 10),
            child: Text(
              widget.description,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, height: 1.3),
            ),
          ),
          SizedBox(height: 10),
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
