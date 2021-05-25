import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/categories_screens/categories_screens.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/widgets/my_loading.dart';
import 'package:projectui/src/resource/model/invoice_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class OrderPayment extends StatefulWidget {
  OrderPayment({this.invoiceData});

  InvoiceData invoiceData;

  @override
  OrderPaymentState createState() => OrderPaymentState();
}

class OrderPaymentState extends State<OrderPayment> with ResponsiveWidget {
  OrderPaymentViewModel orderPaymentViewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: OrderPaymentViewModel(),
        onViewModelReady: (viewModel) => orderPaymentViewModel = viewModel..init(widget.invoiceData),
        builder: (context, viewModel, child) => Scaffold(
            appBar: AppBar(
                title: Text("Thanh toán"),
                titleSpacing: 0,
                leading: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    );
                  },
                )),
            body: buildUi(context: context)));
  }

  Widget buildScreen() {
    return Container(
      child: orderPaymentViewModel.isLoading == false
          ? StreamBuilder(
              stream: orderPaymentViewModel.urlPayment.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return WebView(
                    initialUrl: snapshot.data,
                    javascriptMode: JavascriptMode.unrestricted,
                    onPageStarted: (url) {
                      orderPaymentViewModel.checkPayment(url, widget.invoiceData);
                      setState(() {});
                    },
                  );
                } else {
                  return MyLoading();
                }
              },
            )
          : Center(child: MyLoading()),
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
