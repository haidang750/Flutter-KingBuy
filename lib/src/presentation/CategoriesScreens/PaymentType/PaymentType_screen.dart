import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/widgets/MyLoading.dart';
import 'package:projectui/src/resource/model/CartModel.dart';
import 'package:rxdart/rxdart.dart';

import 'PaymentType_viewmodel.dart';

class PaymentTypeScreen extends StatefulWidget {
  @override
  PaymentTypeScreenState createState() => PaymentTypeScreenState();
}

class PaymentTypeScreenState extends State<PaymentTypeScreen> with ResponsiveWidget {
  final paymentTypeViewModel = PaymentTypeViewModel();
  final selectedPaymentType = BehaviorSubject<int>();

  @override
  void initState() {
    super.initState();
    selectedPaymentType.sink.add(-1);
  }

  @override
  void dispose() {
    super.dispose();
    selectedPaymentType.close();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: paymentTypeViewModel,
        builder: (context, viewModel, child) => Scaffold(
            appBar: AppBar(title: Text("Phương thức thanh toán", style: TextStyle(fontSize: 18)), titleSpacing: 0, actions: [
              Builder(
                  builder: (context) => Padding(
                        padding: EdgeInsets.only(right: 10, top: 14, bottom: 10),
                        child: StreamBuilder(
                          stream: selectedPaymentType.stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ButtonTheme(
                                minWidth: 66,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                disabledColor: Colors.grey.shade500,
                                buttonColor: AppColors.primary,
                                child: RaisedButton(
                                    child: Text("Xong",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        )),
                                    onPressed: snapshot.data != -1
                                        ? () {
                                            CartModel.of(context).setPaymentMethod(selectedPaymentType.stream.value);
                                            Navigator.pop(context, selectedPaymentType.stream.value);
                                          }
                                        : null),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ))
            ]),
            body: buildUi(context: context)));
  }

  Widget buildScreen() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          buildOnePaymentType(AppImages.icBankPackage, "Thanh toán bằng tiền mặt khi nhận hàng", 1),
          buildOnePaymentType(AppImages.icBankPayment, "Chuyển khoản ngân hàng", 2),
          buildOnePaymentType(AppImages.icBankSurface, "Thanh toán bằng thẻ Visa / Master Card", 3)
        ],
      ),
    );
  }

  Widget buildOnePaymentType(String image, String content, int index) {
    return StreamBuilder(
      stream: selectedPaymentType.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: Container(
              height: 50,
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Image.asset(image, height: 20, width: 20),
                  SizedBox(width: 5),
                  Text(content),
                  Spacer(),
                  Image.asset(index == snapshot.data ? AppImages.icEnableRadio : AppImages.icDisableRadio, height: 20, width: 20)
                ],
              ),
            ),
            onTap: () {
              selectedPaymentType.sink.add(index);
            },
          );
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
