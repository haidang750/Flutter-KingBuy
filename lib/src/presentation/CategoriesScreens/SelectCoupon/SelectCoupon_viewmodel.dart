import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/model/CouponModel.dart';
import 'package:rxdart/rxdart.dart';

class SelectCouponViewModel extends BaseViewModel {
  final nonUseCouponSubject = BehaviorSubject<TypeCoupon>();

  Stream<TypeCoupon> get nonUseCouponStream => nonUseCouponSubject.stream;

  getAllCoupons() async {
    CouponData coupons = await couponRepository.getAllCoupons();
    nonUseCouponSubject.sink.add(coupons.nonUse);
  }

  void dispose() {
    nonUseCouponSubject.close();
  }
}
