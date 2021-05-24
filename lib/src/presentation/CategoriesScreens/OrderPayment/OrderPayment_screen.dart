import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:projectui/src/presentation/CategoriesScreens/CategoriesScreens.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/widgets/MyLoading.dart';
import 'package:projectui/src/resource/model/InvoiceModel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:toast/toast.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' show Client, Response;

class OrderPayment extends StatefulWidget {
  OrderPayment({this.invoiceData});

  InvoiceData invoiceData;

  @override
  OrderPaymentState createState() => OrderPaymentState();
}

class OrderPaymentState extends State<OrderPayment> with ResponsiveWidget {
  final orderPaymentViewModel = OrderPaymentViewModel();
  final urlPayment = BehaviorSubject<String>();
  bool isLoading;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    setState(() {
      isLoading = false;
    });
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      String url = await orderPaymentViewModel.createPayment(widget.invoiceData.id);
      print("url: $url");
      urlPayment.sink.add(url);
    });
  }

  @override
  void dispose() {
    super.dispose();
    urlPayment.close();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: orderPaymentViewModel,
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
      child: isLoading == false
          ? StreamBuilder(
              stream: urlPayment.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return WebView(
                    initialUrl: snapshot.data,
                    javascriptMode: JavascriptMode.unrestricted,
                    onPageStarted: (url) => checkPayment(url),
                  );
                } else {
                  return MyLoading();
                }
              },
            )
          : Center(child: MyLoading()),
    );
  }

  checkPayment(String url) async {
    if (url.contains("/api/vnpIPN")) {
      setState(() {
        isLoading = !isLoading;
      });
      Client client = Client();
      Response response = await client.get(Uri.parse(url));
      int status = json.decode(response.body)["status"];
      if (status == 1) {
        // trường hợp thanh toán thành công => Chuyển sang màn hình Thanh toán thành công (OrderSuccess) và xóa các sản phẩm trong Cart
        Toast.show("Thanh toán thành công", context, gravity: Toast.CENTER);
        Navigator.push(context, MaterialPageRoute(builder: (context) => OrderSuccess(invoiceData: widget.invoiceData)));
      } else {
        // trường hợp cancel việc thanh toán (status = 0) => Quay lại màn hình Cart và vẫn giữ nguyên các sản phẩm trong Cart
        Toast.show("Đơn hàng bị hủy", context, gravity: Toast.CENTER);
        Navigator.pop(context);
        Navigator.pop(context);
      }
    }
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
