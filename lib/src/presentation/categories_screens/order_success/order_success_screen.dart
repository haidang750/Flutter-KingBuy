import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/categories_screens/categories_screens.dart';
import 'package:projectui/src/presentation/navigation/navigation.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/model/invoice_model.dart';
import 'package:projectui/src/utils/app_utils.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../routers.dart';

class OrderSuccess extends StatefulWidget {
  OrderSuccess({this.invoiceData});

  InvoiceData invoiceData;

  @override
  OrderSuccessState createState() => OrderSuccessState();
}

class OrderSuccessState extends State<OrderSuccess> with ResponsiveWidget {
  OrderSuccessViewModel orderSuccessViewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: OrderSuccessViewModel(),
        onViewModelReady: (viewModel) => orderSuccessViewModel = viewModel..init(context),
        builder: (context, viewModel, child) => Scaffold(
            appBar: AppBar(
                title: Text("Đặt hàng thành công", style: TextStyle(color: AppColors.black, fontSize: 16)),
                titleSpacing: 0,
                leading: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: Icon(Icons.arrow_back, color: AppColors.black),
                      onPressed: () {
                        Navigator.pushNamed(context, Routers.Navigation);
                        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                          MainTabControlDelegate.getInstance().tabJumpTo(4);
                        });
                      },
                    );
                  },
                ),
                backgroundColor: AppColors.white),
            body: buildUi(context: context)));
  }

  Widget buildScreen() {
    return Container(
      padding: EdgeInsets.fromLTRB(25, 20, 25, 35),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 50,
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text("Mã đơn hàng: "),
                  Text(widget.invoiceData.invoiceCode, style: TextStyle(fontWeight: FontWeight.bold)),
                  Spacer(),
                  GestureDetector(
                      child: Icon(Icons.copy, size: 26, color: Colors.red),
                      onTap: () {
                        AppUtils.copyToClipboard(context, widget.invoiceData.invoiceCode);
                      })
                ],
              ),
            ),
            QrImage(
              data: widget.invoiceData.invoiceCode,
              version: QrVersions.auto,
              size: 180.0,
            ),
            SizedBox(height: 10),
            Text("Cảm ơn quý khách đã đặt hàng thành công!"),
            Text("Khách hàng nếu cần thêm thông tin vui lòng liên hệ hotline 1900.6810", textAlign: TextAlign.center),
            SizedBox(height: 70),
            buildButton(AppColors.primary, "ĐẶT HÀNG THÊM", () => Navigator.pushNamed(context, Routers.Navigation)),
            SizedBox(height: 7),
            buildButton(AppColors.grey, "XEM LẠI ĐƠN HÀNG", () => Navigator.pushNamed(context, Routers.Order_Detail, arguments: widget.invoiceData)),
            SizedBox(height: 25),
            GestureDetector(
                child: Text("Về trang chủ"),
                onTap: () {
                  Navigator.pushNamed(context, Routers.Navigation);
                })
          ],
        ),
      ),
    );
  }

  Widget buildButton(Color buttonColor, String buttonContent, Function action) {
    return GestureDetector(
      child: Container(
        height: 40,
        width: MediaQuery.of(context).size.width * 0.65,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: buttonColor, borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Text(buttonContent, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400)),
      ),
      onTap: action,
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
