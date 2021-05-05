// Ảnh 43 - Lịch sử đặt hàng
import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/ProfileScreens/Order/ListOrder/ListOrder_screen.dart';
import 'package:projectui/src/presentation/presentation.dart';

List<String> status = [
  "Quản lý đơn hàng",
  "Đơn hàng chờ xác nhận",
  "Đơn hàng chờ vận chuyển",
  "Đơn hàng thành công",
  "Đơn hàng đã hủy",
  "Đơn hàng chờ thanh toán",
  "Đơn hàng trả góp"
];

class OrderHistory extends StatefulWidget {
  @override
  OrderHistoryState createState() => OrderHistoryState();
}

class OrderHistoryState extends State<OrderHistory> with ResponsiveWidget {
  final orderHistoryViewModel = OrderHistoryViewModel();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: orderHistoryViewModel,
        builder: (context, viewModel, child) =>
            Scaffold(appBar: AppBar(titleSpacing: 0, title: Text("Lịch sử đặt hàng")), body: buildUi(context: context)));
  }

  Widget buildScreen() {
    return Column(
      children: [
        buildListStatus(),
        Container(
          height: 8,
          color: Colors.grey.shade300,
        ),
        Expanded(
          child: Container(color: Colors.grey.shade300, child: buildListOrder()),
        )
      ],
    );
  }

  Widget buildListStatus() {
    return Container(
      height: 90,
      padding: EdgeInsets.only(left: 15, top: 15, bottom: 15),
      child: Container(
          child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: status.length,
        itemBuilder: (context, index) {
          return buildOneStatus(index);
        },
      )),
    );
  }

  Widget buildOneStatus(int index) {
    return GestureDetector(
      child: Container(
        width: 140,
        height: 100,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        child: Card(
          color: currentIndex == index ? Colors.blue : Colors.white,
          child: Text(
            status[index],
            style: TextStyle(fontSize: 17, color: currentIndex == index ? Colors.white : Colors.black),
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
  }

  Widget buildListOrder() {
    return ListOrder(
      filter: currentIndex - 1,
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
