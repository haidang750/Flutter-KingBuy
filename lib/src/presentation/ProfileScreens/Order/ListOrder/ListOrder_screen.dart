import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/ProfileScreens/Order/Order.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/presentation/widgets/MyListView.dart';
import 'package:projectui/src/presentation/widgets/ShowMoney.dart';
import 'package:projectui/src/resource/model/InvoiceModel.dart';
import 'package:projectui/src/resource/model/OrderHistoryModel.dart';

class ListOrder extends StatefulWidget {
  ListOrder({this.filter});

  int filter;

  @override
  ListOrderState createState() => ListOrderState();
}

class ListOrderState extends State<ListOrder> with ResponsiveWidget {
  final listOrderViewModel = ListOrderViewModel();

  @override
  Widget build(BuildContext context) {
    return BaseWidget(viewModel: listOrderViewModel, builder: (context, viewModel, child) => buildUi(context: context));
  }

  Widget buildScreen() {
    return KeyedSubtree(
        key: UniqueKey(), child: MyListView.build(itemBuilder: itemBuilder, dataRequester: dataRequester, initRequester: initRequester));
  }

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

  Widget itemBuilder(List<dynamic> invoices, BuildContext context, int index) {
    InvoiceData invoice = invoices[index];

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
                          invoice.createdAt,
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          getStatus(invoice.status),
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: Colors.grey),
                        ),
                        ShowMoney(
                          price: invoice.total,
                          fontSizeLarge: 17,
                          fontSizeSmall: 13,
                          color: AppColors.primary,
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
            Navigator.pushNamed(context, Routers.Order_Detail, arguments: invoice);
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

  Future<List<InvoiceData>> initRequester() async {
    return await listOrderViewModel.loadData(widget.filter, 0);
  }

  Future<List<InvoiceData>> dataRequester(int currentSize) async {
    return await listOrderViewModel.loadData(widget.filter, currentSize);
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
