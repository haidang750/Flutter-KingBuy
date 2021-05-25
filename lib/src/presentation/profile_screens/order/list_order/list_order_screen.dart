import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/profile_screens/order/order.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/presentation/widgets/my_list_view.dart';
import 'package:projectui/src/presentation/widgets/show_money.dart';
import 'package:projectui/src/resource/model/invoice_model.dart';

class ListOrder extends StatefulWidget {
  ListOrder({this.filter});

  int filter;

  @override
  ListOrderState createState() => ListOrderState();
}

class ListOrderState extends State<ListOrder> with ResponsiveWidget {
  ListOrderViewModel listOrderViewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: ListOrderViewModel(),
        onViewModelReady: (viewModel) => listOrderViewModel = viewModel,
        builder: (context, viewModel, child) => buildUi(context: context));
  }

  Widget buildScreen() {
    return KeyedSubtree(
        key: UniqueKey(), child: MyListView.build(itemBuilder: itemBuilder, dataRequester: dataRequester, initRequester: initRequester));
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
                          listOrderViewModel.getStatus(invoice.status),
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
