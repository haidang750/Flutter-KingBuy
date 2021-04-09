import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projectui/src/presentation/ProfileScreens/Coupon/MyCoupon_viewmodel.dart';
import 'package:projectui/src/resource/model/CouponModel.dart';

import 'CouponDetail_screen.dart';

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
  final myCouponViewModel = MyCouponViewModel();

  @override
  void initState() {
    super.initState();
    myCouponViewModel.fetchAllCoupons();
  }

  @override
  void dispose() {
    super.dispose();
    myCouponViewModel.dispose();
  }

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
                  _buildListCoupon(myCouponViewModel.nonUseCouponStream),
                  _buildListCoupon(myCouponViewModel.usedCouponStream),
                  _buildListCoupon(myCouponViewModel.expiredCouponStream),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListCoupon(Stream<TypeCoupon> couponStream) {
    return StreamBuilder(
      stream: couponStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            color: Colors.white,
            child: ListView.builder(
              itemCount: snapshot.data.count,
              itemBuilder: (context, index) {
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    height: 120,
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    child: Row(
                      children: [
                        Container(
                          width: 160,
                          child: Image.network(
                            "https://kingbuy.vn${snapshot.data.coupons[index].imageSource}",
                            fit: BoxFit.fill,
                          ),
                        ),
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.only(top: 5, left: 10),
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data.coupons[index].name,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 10),
                                Text(
                                    "HSD: " +
                                        DateFormat("dd/MM/yyyy").format(snapshot
                                            .data.coupons[index].expiresAt),
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
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CouponDetail(
                            name: snapshot.data.coupons[index].name,
                            description:
                                snapshot.data.coupons[index].description,
                            image: snapshot.data.coupons[index].imageSource,
                          ),
                        ));
                  },
                );
              },
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}