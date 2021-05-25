import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/categories_screens/categories_screens.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/model/model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:toast/toast.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' show Client, Response;

class OrderPaymentViewModel extends BaseViewModel {
  final urlPayment = BehaviorSubject<String>();
  bool isLoading;

  init(InvoiceData invoiceData) async {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    isLoading = false;
    String url = await createPayment(invoiceData.id);
    print("url: $url");
    urlPayment.sink.add(url);
  }

  Future<String> createPayment(int invoiceId) async {
    NetworkState<PaymentModel> result = await categoryRepository.createPayment(invoiceId);
    if(result.data.status == 1){
      return result.data.paymentUrl.url;
    }else{
      return null;
    }
  }

  checkPayment(String url, InvoiceData invoiceData) async {
    if (url.contains("/api/vnpIPN")) {
      isLoading = !isLoading;
      Client client = Client();
      Response response = await client.get(Uri.parse(url));
      int status = json.decode(response.body)["status"];
      if (status == 1) {
        // trường hợp thanh toán thành công => Chuyển sang màn hình Thanh toán thành công (OrderSuccess) và xóa các sản phẩm trong Cart
        Toast.show("Thanh toán thành công", context, gravity: Toast.CENTER);
        Navigator.push(context, MaterialPageRoute(builder: (context) => OrderSuccess(invoiceData: invoiceData)));
      } else {
        // trường hợp cancel việc thanh toán (status = 0) => Quay lại màn hình Cart và vẫn giữ nguyên các sản phẩm trong Cart
        Toast.show("Đơn hàng bị hủy", context, gravity: Toast.CENTER);
        Navigator.pop(context);
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    urlPayment.close();
  }
}