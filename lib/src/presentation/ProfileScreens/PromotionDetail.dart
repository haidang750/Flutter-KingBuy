// Chi tiết khuyến mãi
import 'package:flutter/material.dart';

class PromotionDetail extends StatelessWidget {
  PromotionDetail({this.promotionDetail});
  final Map<String, String> promotionDetail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chi tiết khuyến mãi")),
      body: Container(
        child: ListView(
          children: [
            Container(
              height: 220,
              padding: EdgeInsets.fromLTRB(20, 10, 5, 0),
              child: Image.asset("assets/${promotionDetail["image"]}",
                  fit: BoxFit.fill),
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.only(left: 20, right: 10),
              child: Text(
                promotionDetail["content"],
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.red.shade800,
                    fontWeight: FontWeight.w700,
                    height: 1.3),
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.only(left: 20, right: 10),
              child: Text(
                "Khuyến mãi giảm 20% tối đa 200.000 đồng khi thanh toán qua VNPAY tại Điện Máy Xanh hoặc Thế Giới Di Động này các bạn ơi! Nhanh chóng tham khảo ngay để không bỏ lỡ cơ hội để sắm đồng hồ, laptop mà mình thích với giá tốt nhất thì còn gì bằng nữa." +
                    "\n" +
                    "Thanh toán qua VNPAY.",
                style: TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w400, height: 1.3),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.only(left: 20, right: 10),
              child: Text(
                "Thời gian diễn ra từ ngày: 21/06/2020 - 15/08/2020" +
                    "\n" +
                    "Dưới đây là các thông tin chi tiết, hãy cùng mình tham khảo.",
                style: TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w400, height: 1.3),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.only(left: 20, right: 10),
              child: Text(
                "Các sản phẩm áp dụng:" +
                    "\n" +
                    "Một số sản phẩm đồng hồ." +
                    "\n" +
                    "Một số sản phẩm laptop." +
                    "\n" +
                    "Một số sản phẩm Beko.",
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
