import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/model/cart_model.dart';
import 'package:projectui/src/resource/model/coupon_model.dart';
import 'package:rxdart/rxdart.dart';

class SelectCouponViewModel extends BaseViewModel {
  final couponSelectedSubject = BehaviorSubject<int>();
  final nonUseCouponSubject = BehaviorSubject<TypeCoupon>();

  Stream<TypeCoupon> get nonUseCouponStream => nonUseCouponSubject.stream;

  init() {
    getAllCoupons();
    couponSelectedSubject.sink.add(-1);
  }

  getAllCoupons() async {
    CouponData coupons = await couponRepository.getAllCoupons();
    nonUseCouponSubject.sink.add(coupons.nonUse);
  }

  onSelectCoupon(BuildContext context) {
    Coupon selectedCoupon = nonUseCouponSubject.stream.value.coupons[couponSelectedSubject.stream.value];
    CartModel.of(context).setCoupon(selectedCoupon.id);
    Navigator.pop(context, selectedCoupon);
  }

  @override
  void dispose() {
    super.dispose();
    couponSelectedSubject.close();
    nonUseCouponSubject.close();
  }
}
