import 'package:flutter/material.dart';

Map<String, dynamic> coupons = {
  "Chưa sử dụng": [
    {
      "image": "Image 18.png",
      "content": "Giảm 15% giá trị đơn hàng",
      "status": "HSD: 19/07/2019"
    },
    {
      "image": "Image 18.png",
      "content": "Giảm 20% giá trị đơn hàng",
      "status": "HSD: 22/07/2019"
    },
    {
      "image": "Image 18.png",
      "content": "Giảm 25% giá trị đơn hàng",
      "status": "HSD: 31/07/2019"
    },
    {
      "image": "Image 18.png",
      "content": "Giảm 35% giá trị đơn hàng",
      "status": "HSD: 04/08/2019"
    },
    {
      "image": "Image 18.png",
      "content": "Giảm 35% giá trị đơn hàng",
      "status": "HSD: 04/08/2019"
    }
  ],
  "Đã sử dụng": [
    {
      "image": "Image 18.png",
      "content": "Giảm 20% giá trị đơn hàng",
      "status": "Đã sử dụng"
    },
    {
      "image": "Image 18.png",
      "content": "Giảm 25% giá trị đơn hàng",
      "status": "Đã sử dụng"
    },
    {
      "image": "Image 18.png",
      "content": "Giảm 35% giá trị đơn hàng",
      "status": "Đã sử dụng"
    }
  ],
  "Đã hết hạn": [
    {
      "image": "Image 18.png",
      "content": "Giảm 30% giá trị đơn hàng",
      "status": "HSD: 02/07/2019"
    },
    {
      "image": "Image 18.png",
      "content": "Giảm 10% giá trị đơn hàng",
      "status": "HSD: 01/05/2019"
    },
  ]
};

class MyCoupon extends StatefulWidget {
  @override
  _MyCouponState createState() => _MyCouponState();
}

class _MyCouponState extends State<MyCoupon> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Coupon của tôi",
      )),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              child: Material(
                color: Colors.white,
                child: TabBar(
                  indicatorColor: Colors.red.shade600,
                  indicatorWeight: 3,
                  tabs: [
                    Text(
                      "Chưa sử dụng",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    Text(
                      "Đã sử dụng",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    Text(
                      "Đã hết hạn",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Tab1(),
                  Tab2(),
                  Tab3(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Chưa sử dụng
class Tab1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: coupons.values.elementAt(0).length,
        itemBuilder: (context, index) {
          List<dynamic> coupon1 = coupons.values.elementAt(0);
          return Container(
            height: 120,
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Row(
              children: [
                Image.asset("assets/${coupon1[index]["image"]}"),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(top: 5, left: 10),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coupon1[index]["content"],
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 10),
                        Text(coupon1[index]["status"],
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w500))
                      ],
                    ),
                  ),
                ))
              ],
            ),
          );
        },
      ),
    );
  }
}

// Đã sử dụng
class Tab2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: coupons.values.elementAt(1).length,
        itemBuilder: (context, index) {
          List<dynamic> coupon2 = coupons.values.elementAt(1);
          return Container(
            height: 120,
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Row(
              children: [
                Image.asset("assets/${coupon2[index]["image"]}"),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(top: 5, left: 10),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coupon2[index]["content"],
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 10),
                        Text(coupon2[index]["status"],
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade600))
                      ],
                    ),
                  ),
                ))
              ],
            ),
          );
        },
      ),
    );
  }
}

// Đã hết hạn
class Tab3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: coupons.values.elementAt(2).length,
        itemBuilder: (context, index) {
          List<dynamic> coupon3 = coupons.values.elementAt(2);
          return Container(
            height: 120,
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Row(
              children: [
                Image.asset("assets/${coupon3[index]["image"]}"),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(top: 5, left: 10),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coupon3[index]["content"],
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 10),
                        Text(coupon3[index]["status"],
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade600))
                      ],
                    ),
                  ),
                ))
              ],
            ),
          );
        },
      ),
    );
  }
}
