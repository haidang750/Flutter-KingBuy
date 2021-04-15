import 'package:projectui/src/resource/model/CouponModel.dart';
import 'package:projectui/src/resource/repo/Coupon_Repository.dart';
import 'package:rxdart/rxdart.dart';

class MyCouponViewModel {
  final _couponRepository = CouponRepository();

  final nonUseCouponSubject = BehaviorSubject<TypeCoupon>();
  final usedCouponSubject = BehaviorSubject<TypeCoupon>();
  final expiredCouponSubject = BehaviorSubject<TypeCoupon>();

  Stream<TypeCoupon> get nonUseCouponStream => nonUseCouponSubject.stream;
  Sink<TypeCoupon> get nonUseCouponSink => nonUseCouponSubject.sink;

  Stream<TypeCoupon> get usedCouponStream => usedCouponSubject.stream;
  Sink<TypeCoupon> get usedCouponSink => usedCouponSubject.sink;

  Stream<TypeCoupon> get expiredCouponStream => expiredCouponSubject.stream;
  Sink<TypeCoupon> get expiredCouponSink => expiredCouponSubject.sink;

  getAllCoupons() async {
    CouponData coupons = await _couponRepository.getAllCoupons();
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
