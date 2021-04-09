// Ảnh 43 - Lịch sử đặt hàng
import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/ProfileScreens/Order/OrderDetail_screen.dart';

Map<dynamic, dynamic> orders = {
  "Quản lý đơn hàng": [
    {
      "time": "10:30 - Thứ ba, 04/06/2019",
      "status": "Đang chờ xác nhận",
      "total": "61.120.000"
    },
    {
      "time": "17:05 - Thứ hai, 03/06/2019",
      "status": "Đã giao hàng",
      "total": "75.150.000"
    },
    {
      "time": "12:30 - Chủ nhật, 02/06/2019",
      "status": "Đã giao hàng",
      "total": "90.000.000"
    },
    {
      "time": "16:30 - Thứ hai, 03/06/2019",
      "status": "Đã giao hàng",
      "total": "10.500.000"
    }
  ],
  "Đơn hàng chờ thanh toán": [
    {
      "time": "10:30 - Thứ ba, 04/06/2019",
      "status": "Đang chờ thanh toán",
      "total": "61.120.000"
    },
    {
      "time": "17:05 - Thứ hai, 03/06/2019",
      "status": "Đang chờ thanh toán",
      "total": "75.150.000"
    },
  ],
  "Đơn hàng chờ vận chuyển": [
    {
      "time": "10:30 - Thứ ba, 04/06/2019",
      "status": "Đang chờ vận chuyển",
      "total": "61.120.000"
    },
    {
      "time": "17:05 - Thứ hai, 03/06/2019",
      "status": "Đã chờ vận chuyển",
      "total": "75.150.000"
    },
    {
      "time": "12:30 - Chủ nhật, 02/06/2019",
      "status": "Đã vận chuyển",
      "total": "90.000.000"
    }
  ],
  "Đơn hàng có khuyến mãi": [
    {
      "time": "10:30 - Thứ ba, 04/06/2019",
      "status": "Đang giao hàng",
      "total": "61.120.000"
    },
  ]
};

class OrderHistory extends StatefulWidget {
  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Lịch sử đặt hàng")),
        body: Column(
          children: [
            Container(
              height: 90,
              padding: EdgeInsets.only(left: 15, top: 15, bottom: 15),
              child: Container(
                  child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Container(
                      width: 140,
                      height: 100,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                      child: Card(
                        color:
                            currentIndex == index ? Colors.blue : Colors.white,
                        child: Text(
                          orders.keys.elementAt(index),
                          style: TextStyle(
                              fontSize: 17,
                              color: currentIndex == index
                                  ? Colors.white
                                  : Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  );
                },
              )),
            ),
            Container(
              height: 5,
              color: Colors.grey.shade300,
            ),
            Expanded(
              child: Container(
                  color: Colors.grey.shade300,
                  child: ListView.builder(
                    itemCount: orders.values.elementAt(currentIndex).length,
                    itemBuilder: (context, index) {
                      List<dynamic> order =
                          orders.values.elementAt(currentIndex);

                      return Column(
                        children: [
                          GestureDetector(
                            child: Container(
                                height: 100,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                color: Colors.white,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            order[index]["time"],
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            order[index]["status"],
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey),
                                          ),
                                          Text(
                                            order[index]["total"],
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red.shade700),
                                          )
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      size: 16,
                                    )
                                  ],
                                )),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        OrderDetail(order: order[index])),
                              );
                            },
                          ),
                          Opacity(opacity: 1.0, child: Container(height: 3))
                        ],
                      );
                    },
                  )),
            )
          ],
        ));
  }
}
