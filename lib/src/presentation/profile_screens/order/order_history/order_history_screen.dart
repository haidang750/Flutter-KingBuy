// Ảnh 43 - Lịch sử đặt hàng
import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/profile_screens/order/list_order/list_order_screen.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/presentation/widgets/my_loading.dart';

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
  OrderHistoryViewModel orderHistoryViewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: OrderHistoryViewModel(),
        onViewModelReady: (viewModel) => orderHistoryViewModel = viewModel..init(),
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
    return StreamBuilder(
      stream: orderHistoryViewModel.filterSubject.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Container(
                width: 150,
                height: 90,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                color: snapshot.data + 1 == index ? Colors.blue : Colors.white,
                child: Text(
                  status[index],
                  style: TextStyle(fontSize: 17, color: snapshot.data + 1 == index ? Colors.white : Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            onTap: () {
              orderHistoryViewModel.filterSubject.sink.add(index - 1);
            },
          );
        } else {
          return MyLoading();
        }
      },
    );
  }

  Widget buildListOrder() {
    return StreamBuilder(
      stream: orderHistoryViewModel.filterSubject.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListOrder(filter: snapshot.data);
        } else {
          return MyLoading();
        }
      },
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
