import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/presentation/widgets/my_loading.dart';
import 'package:projectui/src/resource/model/coupon_model.dart';

class SelectCouponScreen extends StatefulWidget {
  @override
  SelectCouponScreenState createState() => SelectCouponScreenState();
}

class SelectCouponScreenState extends State<SelectCouponScreen> with ResponsiveWidget {
  SelectCouponViewModel selectCouponViewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: SelectCouponViewModel(),
        onViewModelReady: (viewModel) => selectCouponViewModel = viewModel..init(),
        builder: (context, viewModel, child) => Scaffold(
              appBar: AppBar(titleSpacing: 0, title: Text("Mã giảm giá"), actions: [
                Builder(
                    builder: (context) => Padding(
                          padding: EdgeInsets.only(right: 10, top: 14, bottom: 10),
                          child: StreamBuilder(
                            stream: selectCouponViewModel.couponSelectedSubject.stream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ButtonTheme(
                                  minWidth: 66,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  disabledColor: Colors.grey.shade500,
                                  buttonColor: AppColors.primary,
                                  child: RaisedButton(
                                      child: Text("Xong", style: TextStyle(fontSize: 16, color: Colors.white)),
                                      onPressed: snapshot.data != -1
                                          ? () {
                                              selectCouponViewModel.onSelectCoupon(context);
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
              body: buildUi(context: context),
            ));
  }

  Widget buildScreen() {
    return buildListCoupon(selectCouponViewModel.nonUseCouponStream);
  }

  Widget buildListCoupon(Stream<TypeCoupon> couponStream) {
    return StreamBuilder(
      stream: couponStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data.count > 0
              ? Container(
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
                                        Row(
                                          children: [
                                            Text(
                                              coupon.name,
                                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                                            ),
                                            Spacer(),
                                            StreamBuilder(
                                              stream: selectCouponViewModel.couponSelectedSubject.stream,
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  return Image.asset(index == snapshot.data ? AppImages.icEnableRadio : AppImages.icDisableRadio,
                                                      height: 20, width: 20);
                                                } else {
                                                  return Container();
                                                }
                                              },
                                            )
                                          ],
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
                            selectCouponViewModel.couponSelectedSubject.sink.add(index);
                          });
                    },
                  ),
                )
              : Center(child: Text("Hiện không có mã giảm giá nào!", style: TextStyle(color: Colors.red)));
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
