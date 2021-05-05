import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/model/CouponModel.dart';
import 'package:rxdart/rxdart.dart';

class ListCouponsViewModel extends BaseViewModel {
  final nonUseCouponSubject = BehaviorSubject<TypeCoupon>();
  final usedCouponSubject = BehaviorSubject<TypeCoupon>();
  final expiredCouponSubject = BehaviorSubject<TypeCoupon>();

  Stream<TypeCoupon> get nonUseCouponStream => nonUseCouponSubject.stream;

  Stream<TypeCoupon> get usedCouponStream => usedCouponSubject.stream;

  Stream<TypeCoupon> get expiredCouponStream => expiredCouponSubject.stream;

  getAllCoupons() async {
    CouponData coupons = await couponRepository.getAllCoupons();
    nonUseCouponSubject.sink.add(coupons.nonUse);
    usedCouponSubject.sink.add(coupons.used);
    expiredCouponSubject.sink.add(coupons.expired);
  }

  void dispose() {
    nonUseCouponSubject.close();
    usedCouponSubject.close();
    expiredCouponSubject.close();
  }
}
