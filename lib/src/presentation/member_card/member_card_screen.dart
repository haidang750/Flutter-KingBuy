import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/member_card/member_card.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/routers.dart';
import 'package:projectui/src/resource/model/member_card_model.dart';

class MemberCardScreen extends StatefulWidget {
  @override
  MemberCardScreenState createState() => MemberCardScreenState();
}

class MemberCardScreenState extends State<MemberCardScreen> with ResponsiveWidget {
  MemberCardViewModel memberCardViewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        mainScreen: true,
        viewModel: MemberCardViewModel(),
        onViewModelReady: (viewModel) => memberCardViewModel = viewModel..init(),
        builder: (context, viewModel, child) => Scaffold(
            appBar: AppBar(
                title: Text("Thẻ thành viên", style: TextStyle(color: AppColors.black)),
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.white),
            body: buildUi(context: context)));
  }

  Widget buildScreen() {
    return StreamBuilder(
      stream: memberCardViewModel.memberCardStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          MemberCard memberCard = snapshot.data;

          return Column(
            children: [
              SizedBox(height: 13),
              Center(
                child: Container(
                  height: 180,
                  width: MediaQuery.of(context).size.width - 40,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Container(
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: BarcodeWidget(
                      barcode: Barcode.code128(useCode128A: false, useCode128B: false),
                      data: memberCard.memberCardNumber,
                      height: 95,
                      width: MediaQuery.of(context).size.width - 110,
                      textPadding: 15,
                      style: TextStyle(fontSize: 17, letterSpacing: 4, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 22),
              Text("COUPON CHƯA SỬ DỤNG (${memberCard.couponNoneUse.count})", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 25),
              GestureDetector(
                  child: Text("Xem tất cả coupon", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  onTap: () {
                    Navigator.pushNamed(context, Routers.List_Coupons);
                  })
            ],
          );
        } else {
          return Container();
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
