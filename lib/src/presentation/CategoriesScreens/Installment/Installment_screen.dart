import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/CategoriesScreens/CategoriesScreens.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/presentation/widgets/MyLoading.dart';
import 'package:projectui/src/resource/model/BankModel.dart';
import 'package:projectui/src/resource/model/CreditModel.dart';
import 'package:projectui/src/resource/model/ListProductsModel.dart';
import 'package:projectui/src/utils/app_utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:toast/toast.dart';

class InstallmentScreen extends StatefulWidget {
  InstallmentScreen({this.product, this.productColor});

  Product product;
  String productColor;

  @override
  InstallmentScreenState createState() => InstallmentScreenState();
}

class InstallmentScreenState extends State<InstallmentScreen> with ResponsiveWidget {
  final installmentViewModel = InstallmentViewModel();
  final currentBank = BehaviorSubject<int>();
  final currentCard = BehaviorSubject<int>();
  final currentInstallmentMonth = BehaviorSubject<int>();
  final currentInstallmentPrepay = BehaviorSubject<int>();
  final installmentEachMonthSubject = BehaviorSubject<int>();
  final prepaySubject = BehaviorSubject<int>();

  @override
  void initState() {
    super.initState();
    installmentViewModel.getBanks();
    installmentViewModel.getCreditList();
    currentBank.sink.add(0);
    currentCard.sink.add(0);
    currentInstallmentMonth.sink.add(0);
    currentInstallmentPrepay.sink.add(0);
    getPrepayMoney();
    getInstallmentPayEachMonth();
  }

  @override
  void dispose() {
    super.dispose();
    currentBank.close();
    currentCard.close();
    currentInstallmentMonth.close();
    currentInstallmentPrepay.close();
    installmentEachMonthSubject.close();
    prepaySubject.close();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: installmentViewModel,
        builder: (context, viewModel, child) =>
            Scaffold(appBar: AppBar(title: Text("Đặt mua trả góp"), titleSpacing: 0), body: buildUi(context: context)));
  }

  Widget buildScreen() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          buildProductInfo(),
          Container(
            height: 10,
            color: AppColors.grey2,
          ),
          buildInstallmentType(),
          buildBanks(),
          buildCards(),
          buildInstallmentMonths(),
          buildInstallmentPrepay(),
          buildPrice(),
          SizedBox(height: 10),
          buildButton(),
          SizedBox(height: 30)
        ],
      ),
    );
  }

  Widget buildProductInfo() {
    return Container(
      height: 120,
      color: AppColors.white,
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          MyNetworkImage(url: "${AppEndpoint.BASE_URL}${widget.product.imageSource}", height: 80, width: 80),
          SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width - 130,
                  child: Text(widget.product.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              Row(
                children: [
                  Text("Màu sắc: ", style: TextStyle(fontSize: 16)),
                  SizedBox(width: 2),
                  Text(widget.productColor, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildTitle(int number, String title) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            height: 24,
            width: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColors.blue, borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Text(number.toString(), style: TextStyle(fontSize: 17, color: AppColors.buttonContent)),
          ),
          SizedBox(width: 10),
          Text(title, style: TextStyle(fontSize: 16))
        ],
      ),
    );
  }

  Widget buildInstallmentType() {
    return Container(
        color: AppColors.white,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            buildTitle(1, "Chọn loại hình trả góp"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildOneInstallmentType(20, AppColors.blue, "Trả góp qua thẻ tín dụng"),
                SizedBox(width: 15),
                buildOneInstallmentType(15, AppColors.grey2, "Trả góp qua công ty tài chính")
              ],
            ),
            SizedBox(height: 10)
          ],
        ));
  }

  Widget buildOneInstallmentType(double textPadding, Color borderColor, String typeContent) {
    return Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: textPadding),
        width: MediaQuery.of(context).size.width * 0.43,
        alignment: Alignment.center,
        decoration: BoxDecoration(border: Border.all(width: 1, color: borderColor), borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Text(typeContent, style: TextStyle(fontSize: 16), textAlign: TextAlign.center));
  }

  Widget buildBanks() {
    return Container(
        color: AppColors.white,
        padding: EdgeInsets.only(left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitle(2, "Chọn ngân hàng phát hành thẻ"),
            StreamBuilder(
              stream: Rx.combineLatest2(installmentViewModel.bankStream, currentBank.stream, (stream1, stream2) => stream1),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Bank> banks = snapshot.data;

                  return Container(
                    height: 60,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: banks.length,
                        itemBuilder: (context, index) => Row(
                              children: [
                                GestureDetector(
                                  child: Container(
                                      height: 60,
                                      width: MediaQuery.of(context).size.width * 0.25,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1, color: index == currentBank.stream.value ? AppColors.blue : AppColors.grey2),
                                          borderRadius: BorderRadius.all(Radius.circular(10))),
                                      child: MyNetworkImage(url: "${AppEndpoint.BASE_URL}${banks[index].imageSource}")),
                                  onTap: () {
                                    currentBank.sink.add(index);
                                  },
                                ),
                                SizedBox(width: 15)
                              ],
                            )),
                  );
                } else {
                  return MyLoading();
                }
              },
            ),
            SizedBox(height: 10)
          ],
        ));
  }

  Widget buildCards() {
    return Container(
        color: AppColors.white,
        padding: EdgeInsets.only(left: 15),
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitle(3, "Chọn thẻ"),
            StreamBuilder(
              stream: Rx.combineLatest2(installmentViewModel.creditStream, currentCard.stream, (stream1, stream2) => stream1),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Credit> credits = snapshot.data;

                  return Container(
                    height: 60,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: credits.length,
                        itemBuilder: (context, index) => Row(
                              children: [
                                GestureDetector(
                                  child: Container(
                                      height: 60,
                                      width: MediaQuery.of(context).size.width * 0.25,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1, color: index == currentCard.stream.value ? AppColors.blue : AppColors.grey2),
                                          borderRadius: BorderRadius.all(Radius.circular(10))),
                                      child: MyNetworkImage(url: "${AppEndpoint.BASE_URL}${credits[index].imageSource}")),
                                  onTap: () {
                                    currentCard.sink.add(index);
                                  },
                                ),
                                SizedBox(width: 15)
                              ],
                            )),
                  );
                } else {
                  return MyLoading();
                }
              },
            ),
            SizedBox(height: 10)
          ],
        ));
  }

  Widget buildInstallmentMonths() {
    return Container(
        color: AppColors.white,
        padding: EdgeInsets.only(left: 15),
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitle(4, "Chọn gói trả trước"),
            StreamBuilder(
              stream: currentInstallmentMonth.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    height: 50,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.product.installmentMonths.length,
                        itemBuilder: (context, index) => Row(
                              children: [
                                GestureDetector(
                                  child: Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width * 0.25,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1, color: index == snapshot.data ? AppColors.blue : AppColors.grey2),
                                          borderRadius: BorderRadius.all(Radius.circular(10))),
                                      child: Text("${widget.product.installmentMonths[index]} tháng",
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                                  onTap: () {
                                    currentInstallmentMonth.sink.add(index);
                                    getInstallmentPayEachMonth();
                                    getPrepayMoney();
                                  },
                                ),
                                SizedBox(width: 15)
                              ],
                            )),
                  );
                } else {
                  return MyLoading();
                }
              },
            ),
            SizedBox(height: 10)
          ],
        ));
  }

  Widget buildInstallmentPrepay() {
    return Container(
        color: AppColors.white,
        padding: EdgeInsets.only(left: 15),
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitle(5, "Trả trước"),
            StreamBuilder(
              stream: currentInstallmentPrepay.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    height: 50,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.product.installmentPrepay.length,
                        itemBuilder: (context, index) => Row(
                              children: [
                                GestureDetector(
                                  child: Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width * 0.25,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1, color: index == snapshot.data ? AppColors.blue : AppColors.grey2),
                                          borderRadius: BorderRadius.all(Radius.circular(10))),
                                      child: Text("${widget.product.installmentPrepay[index]}%",
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                                  onTap: () {
                                    currentInstallmentPrepay.sink.add(index);
                                    getInstallmentPayEachMonth();
                                    getPrepayMoney();
                                  },
                                ),
                                SizedBox(width: 15)
                              ],
                            )),
                  );
                } else {
                  return MyLoading();
                }
              },
            ),
            SizedBox(height: 10)
          ],
        ));
  }

  Widget buildPrice() {
    return Container(
        height: 130,
        color: AppColors.white,
        padding: EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.center,
        child: Container(
          height: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Giá sản phẩm", style: TextStyle(fontSize: 14)),
                  Spacer(),
                  ShowMoney(
                    price: widget.product.salePrice,
                    isLineThrough: false,
                    fontWeight: FontWeight.normal,
                    fontSizeLarge: 14,
                    fontSizeSmall: 11,
                  )
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text("Trả góp mỗi tháng", style: TextStyle(fontSize: 14)),
                  Spacer(),
                  StreamBuilder(
                    stream: installmentEachMonthSubject.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ShowMoney(
                          price: snapshot.data,
                          isLineThrough: false,
                          fontWeight: FontWeight.normal,
                          fontSizeLarge: 14,
                          fontSizeSmall: 11,
                        );
                      } else {
                        return Text("");
                      }
                    },
                  )
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text("Trả trước", style: TextStyle(fontSize: 14)),
                  Spacer(),
                  StreamBuilder(
                    stream: prepaySubject.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ShowMoney(
                          price: snapshot.data,
                          isLineThrough: false,
                          fontWeight: FontWeight.normal,
                          fontSizeLarge: 14,
                          fontSizeSmall: 11,
                        );
                      } else {
                        return Text("");
                      }
                    },
                  )
                ],
              ),
              SizedBox(height: 8),
              Container(height: 0.5, color: AppColors.grey3),
              SizedBox(height: 8),
              Row(
                children: [
                  Text("TỔNG", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  Spacer(),
                  ShowMoney(
                    price: widget.product.salePrice,
                    isLineThrough: false,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSizeLarge: 14,
                    fontSizeSmall: 11,
                  )
                ],
              ),
            ],
          ),
        ));
  }

  getInstallmentPayEachMonth() {
    installmentEachMonthSubject.sink.add(((widget.product.salePrice - prepaySubject.stream.value) /
            double.parse(widget.product.installmentMonths[currentInstallmentMonth.stream.value]))
        .round());
    prepaySubject.sink
        .add((widget.product.salePrice * double.parse(widget.product.installmentPrepay[currentInstallmentPrepay.stream.value]) / 100).round());
  }

  getPrepayMoney() {
    prepaySubject.sink
        .add((widget.product.salePrice * double.parse(widget.product.installmentPrepay[currentInstallmentPrepay.stream.value]) / 100).round());
    installmentEachMonthSubject.sink.add(((widget.product.salePrice - prepaySubject.stream.value) /
            double.parse(widget.product.installmentMonths[currentInstallmentMonth.stream.value]))
        .round());
  }

  Widget buildButton() {
    return GestureDetector(
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width - 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.all(Radius.circular(25))),
        child: Text("Chọn trả góp", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.buttonContent)),
      ),
      onTap: () async {
        if (await AppUtils.checkLogin()) {
          showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  insetPadding: EdgeInsets.symmetric(horizontal: 50),
                  child: Container(
                    height: 110,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Bạn xác nhận đặt hàng nhé?",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Button Hủy
                            GestureDetector(
                                child: Container(
                                  height: 30,
                                  width: 80,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: AppColors.disableButton, borderRadius: BorderRadius.all(Radius.circular(15))),
                                  child: Text(
                                    "Chờ đã",
                                    style: TextStyle(color: AppColors.buttonContent, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                }),
                            SizedBox(
                              width: 30,
                            ),
                            // Button Đăng nhập
                            GestureDetector(
                              child: Container(
                                height: 30,
                                width: 80,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.all(Radius.circular(15))),
                                child: Text("Đồng ý", style: TextStyle(color: AppColors.buttonContent, fontWeight: FontWeight.w500)),
                              ),
                              onTap: () async {
                                int productId = widget.product.id;
                                int installmentType = 1;
                                int bankId = installmentViewModel.bankSubject.stream.value[currentBank.stream.value].id;
                                int installmentCardType = installmentViewModel.creditSubject.stream.value[currentCard.stream.value].id;
                                int monthsInstallment = int.parse(widget.product.installmentMonths[currentInstallmentMonth.stream.value]);
                                int prepayInstallment = int.parse(widget.product.installmentPrepay[currentInstallmentPrepay.stream.value]);

                                int invoiceId = await installmentViewModel.createInstallment(
                                    productId, installmentType, bankId, installmentCardType, monthsInstallment, prepayInstallment);

                                // Nếu đặt mua trả góp thành công thì dùng invoiceId cho API detailInstallment
                                if (invoiceId != -1) {
                                  Toast.show("Thành công", context, gravity: Toast.CENTER);
                                  Navigator.pushNamed(context, Routers.Installment_Detail, arguments: invoiceId);
                                } else {
                                  Toast.show("Đặt mua trả góp không thành công", context, gravity: Toast.CENTER);
                                }
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              });
        } else {
          AppUtils.myShowDialog(context, widget.product.id, widget.product.videoLink);
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
