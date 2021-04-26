// Chi tiết khuyến mãi
import 'package:flutter/material.dart';

class PromotionDetail extends StatefulWidget {
  PromotionDetail({this.image, this.title, this.description});
  String image;
  String title;
  String description;

  @override
  PromotionDetailState createState() => PromotionDetailState();
}

class PromotionDetailState extends State<PromotionDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(titleSpacing: 0, title: Text("Chi tiết khuyến mãi")),
      body: Container(
        child: ListView(
          children: [
            Container(
              height: 220,
              padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: Image.network(
                "https://kingbuy.vn${widget.image}",
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Text(
                widget.title,
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.red.shade800,
                    fontWeight: FontWeight.w700,
                    height: 1.3),
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Text(
                widget.description,
                style: TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w400, height: 1.3),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
