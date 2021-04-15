import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/ProfileScreens/Order/Order.dart';
import 'package:projectui/src/presentation/widgets/MyListView.dart';
import 'package:projectui/src/presentation/widgets/ShowMoney.dart';
import 'package:projectui/src/resource/model/OrderHistoryModel.dart';

class ListOrder extends StatelessWidget {
  ListOrder({Key key, this.filter}) : super(key: key);
  final int filter;
  final keyListView = GlobalKey<MyListViewState>();
  final orderHistoryViewModel = OrderHistoryViewModel();

  String getStatus(int status) {
    switch (status) {
      case 0:
        return "Đơn hàng chờ xác nhận";
        break;
      case 1:
        return "Đơn hàng chờ vận chuyển";
        break;
      case 2:
        return "Đơn hàng thành công";
        break;
      case 3:
        return "Đơn hàng đã hủy";
        break;
      case 4:
        return "Đơn hàng chờ thanh toán";
        break;
      default:
        return null;
    }
  }

  Widget itemBuilder(List<dynamic> orders, BuildContext context, int index) {
    Order order = orders[index];

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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          order.createdAt,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          getStatus(order.status),
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey),
                        ),
                        ShowMoney(
                          price: order.total,
                          fontSizeLarge: 17,
                          fontSizeSmall: 13,
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.bold,
                          isLineThrough: false,
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
                  builder: (context) => OrderDetail(
                    order: order,
                  ),
                ));
          },
        ),
        Opacity(
          opacity: 1.0,
          child: Container(
            height: 3,
          ),
        )
      ],
    );
  }

  Future<List<Order>> initRequester() async {
    return await orderHistoryViewModel.loadData(filter, 0);
  }

  Future<List<Order>> dataRequester(int currentSize) async {
    return await orderHistoryViewModel.loadData(filter, currentSize);
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.build(
        key: keyListView,
        itemBuilder: itemBuilder,
        dataRequester: dataRequester,
        initRequester: initRequester);
  }
}
