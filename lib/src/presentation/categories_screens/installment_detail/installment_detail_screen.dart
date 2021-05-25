import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/presentation/widgets/my_loading.dart';
import 'package:projectui/src/resource/model/installment_detail_model.dart';
import 'installment_detail_viewmodel.dart';

class InstallmentDetailScreen extends StatefulWidget {
  InstallmentDetailScreen({this.invoiceId});

  int invoiceId;

  @override
  InstallmentDetailScreenState createState() => InstallmentDetailScreenState();
}

class InstallmentDetailScreenState extends State<InstallmentDetailScreen> with ResponsiveWidget {
  InstallmentDetailViewModel installmentDetailViewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: InstallmentDetailViewModel(),
        onViewModelReady: (viewModel) => installmentDetailViewModel = viewModel..init(widget.invoiceId),
        builder: (context, viewModel, child) => Scaffold(
            appBar: AppBar(
              title: Text("Thông tin trả góp"),
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
              ),
            ),
            body: buildUi(context: context)));
  }

  Widget buildScreen() {
    return StreamBuilder(
      stream: installmentDetailViewModel.detailInstallmentStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          InstallmentDetailModel installment = snapshot.data;

          return Column(
            children: [buildPriceInfo(installment), SizedBox(height: 20), buildInstallmentInfo(installment)],
          );
        } else {
          return MyLoading();
        }
      },
    );
  }

  Widget buildPriceInfo(InstallmentDetailModel installment) {
    return Container(
        height: 150,
        padding: EdgeInsets.all(15),
        child: Container(
          height: 120,
          width: MediaQuery.of(context).size.width - 30,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(color: Colors.lightBlueAccent.shade400, borderRadius: BorderRadius.all(Radius.circular(12)), boxShadow: [
            BoxShadow(
              color: Colors.grey.shade600.withOpacity(0.8),
              spreadRadius: 0.5,
              blurRadius: 0.5,
              offset: Offset(1, 1), // changes position of shadow
            ),
          ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildOnePriceInfo("Giá sản phẩm", installment.total),
              buildOnePriceInfo("Trả góp mỗi tháng", installment.payMonthlyInstallment),
              buildOnePriceInfo("Trả trước", installment.prepayInstallmentAmount)
            ],
          ),
        ));
  }

  Widget buildOnePriceInfo(String priceContent, int priceAmount) {
    return Row(
      children: [
        Text(priceContent, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
        Spacer(),
        ShowMoney(
          price: priceAmount,
          fontSizeLarge: 14,
          fontSizeSmall: 11,
          isLineThrough: false,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        )
      ],
    );
  }

  Widget buildInstallmentInfo(InstallmentDetailModel installment) {
    return Container(
        height: 210,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              alignment: Alignment.centerLeft,
              child: Text("THÔNG TIN TRẢ GÓP", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            ),
            buildOneInstallmentInfo("Loại hình trả góp", Text("Trả góp qua thẻ tín dụng", style: TextStyle(fontSize: 15))),
            SizedBox(height: 10),
            buildOneInstallmentInfo("Ngân hàng phát hành thẻ",
                Image.network("${AppEndpoint.BASE_URL}${installment.bankImage}", height: 20, width: 50, fit: BoxFit.cover)),
            SizedBox(height: 10),
            buildOneInstallmentInfo(
                "Loại thẻ", Image.network("${AppEndpoint.BASE_URL}${installment.installmentCardImage}", height: 20, width: 50, fit: BoxFit.cover)),
            SizedBox(height: 10),
            buildOneInstallmentInfo("Gói trả góp", Text("${installment.monthsInstallment.toString()} tháng", style: TextStyle(fontSize: 15))),
            SizedBox(height: 10),
            buildOneInstallmentInfo("Trả trước", Text("${installment.prepayInstallment.toString()} %", style: TextStyle(fontSize: 15)))
          ],
        ));
  }

  Widget buildOneInstallmentInfo(String info, Widget content) {
    return Container(
      height: 20,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [Text(info, style: TextStyle(fontSize: 15)), Spacer(), content],
      ),
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
