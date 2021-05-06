import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/ProfileScreens/Coupon/ListCoupons/ListCoupons_viewmodel.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/presentation/widgets/MyLoading.dart';
import 'package:projectui/src/resource/model/CouponModel.dart';

import '../CouponDetail/CouponDetail_screen.dart';

class ListCoupons extends StatefulWidget {
  @override
  ListCouponsState createState() => ListCouponsState();
}

class ListCouponsState extends State<ListCoupons> with ResponsiveWidget {
  final listCouponsViewModel = ListCouponsViewModel();

  @override
  void initState() {
    super.initState();
    listCouponsViewModel.getAllCoupons();
  }

  @override
  void dispose() {
    super.dispose();
    listCouponsViewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: listCouponsViewModel,
        builder: (context, viewModel, child) => Scaffold(
              appBar: AppBar(
                  titleSpacing: 0,
                  title: Text(
                    "Coupon của tôi",
                  )),
              body: buildUi(context: context),
            ));
  }

  Widget buildScreen() {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: <Widget>[
          Container(
            height: 50,
            child: Material(
              color: Colors.white,
              child: TabBar(
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                tabs: [
                  Text(
                    "Chưa sử dụng",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Đã sử dụng",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Đã hết hạn",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                buildListCoupon(listCouponsViewModel.nonUseCouponStream),
                buildListCoupon(listCouponsViewModel.usedCouponStream),
                buildListCoupon(listCouponsViewModel.expiredCouponStream),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListCoupon(Stream<TypeCoupon> couponStream) {
    return StreamBuilder(
      stream: couponStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            color: Colors.white,
            child: ListView.builder(
              itemCount: snapshot.data.count,
              itemBuilder: (context, index) {
                Coupon coupon = snapshot.data.coupons[index];

                return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      height: 120,
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: Row(
                        children: [
                          Container(
                            width: 160,
                            child: Image.network(
                              "${AppEndpoint.BASE_URL}${coupon.imageSource}",
                              fit: BoxFit.fill,
                            ),
                          ),
                          Expanded(
                              child: Container(
                            padding: EdgeInsets.only(top: 5, left: 10),
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    coupon.name,
                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 10),
                                  Text("HSD: " + DateFormat("dd/MM/yyyy").format(coupon.expiresAt),
                                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.primary))
                                ],
                              ),
                            ),
                          ))
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, Routers.Coupon_Detail, arguments: coupon);
                    });
              },
            ),
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
