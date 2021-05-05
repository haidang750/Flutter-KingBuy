import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/model/network_state.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../resource/model/PromotionModel.dart';

class ListPromotionViewModel extends BaseViewModel {
  final promotionSubject = BehaviorSubject<List<Promotion>>();

  Stream<List<Promotion>> get promotionStream => promotionSubject.stream;

  getPromotion() async {
    NetworkState<PromotionModel> result =
        await authRepository.getPromotion(10, 0);
    if (result.isSuccess) {
      List<Promotion> promotions = result.data.promotions;
      promotionSubject.sink.add(promotions);
    }
  }

  void dispose() {
    promotionSubject.close();
  }
}
