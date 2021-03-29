// Danh sách khuyến mãi
import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/ProfileScreens/PromotionDetail.dart';

List<Map<String, String>> promotions = [
  {
    "image": "Image 18@2x.png",
    "content": "Khuyến mãi giảm 10% tối đa 300k khi thanh toán qua VNPAY",
    "time": "31/07/2019"
  },
  {
    "image": "Image 18@2x.png",
    "content": "Khuyến mãi giảm 10% tối đa 400k khi thanh toán qua VNPAY",
    "time": "31/07/2019"
  },
  {
    "image": "Image 18@2x.png",
    "content": "Khuyến mãi giảm 10% tối đa 200k khi thanh toán qua VNPAY",
    "time": "31/07/2019"
  },
  {
    "image": "Image 18@2x.png",
    "content": "Khuyến mãi giảm 10% tối đa 200k khi thanh toán qua VNPAY",
    "time": "31/07/2019"
  },
  {
    "image": "Image 18@2x.png",
    "content": "Khuyến mãi giảm 10% tối đa 200k khi thanh toán qua VNPAY",
    "time": "31/07/2019"
  },
  {
    "image": "Image 18@2x.png",
    "content": "Khuyến mãi giảm 10% tối đa 200k khi thanh toán qua VNPAY",
    "time": "31/07/2019"
  },
  {
    "image": "Image 18@2x.png",
    "content": "Khuyến mãi giảm 10% tối đa 200k khi thanh toán qua VNPAY",
    "time": "31/07/2019"
  },
  {
    "image": "Image 18@2x.png",
    "content": "Khuyến mãi giảm 10% tối đa 200k khi thanh toán qua VNPAY",
    "time": "31/07/2019"
  },
];

class Promotion extends StatefulWidget {
  @override
  _PromotionState createState() => _PromotionState();
}

class _PromotionState extends State<Promotion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Khuyến mãi")),
        body: Container(
            padding: EdgeInsets.only(left: 25, top: 0, right: 40),
            child: ListView.builder(
              itemCount: promotions.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    height: 100,
                    padding: EdgeInsets.only(top: 10, bottom: 5),
                    child: Row(
                      children: [
                        Container(
                          width: 145,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/" +
                                      "${promotions[index]["image"]}"),
                                  fit: BoxFit.fill)),
                          // child: Image.asset(
                          //   "assets/" + "${promotions[index]["image"]}",
                          // )),
                        ),
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.only(left: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                promotions[index]["content"],
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 5),
                              Text(promotions[index]["time"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                  ))
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PromotionDetail(
                              promotionDetail: promotions[index]),
                        ));
                  },
                );
              },
            )));
  }
}
