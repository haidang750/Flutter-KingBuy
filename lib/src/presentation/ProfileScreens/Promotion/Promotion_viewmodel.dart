import 'package:projectui/src/resource/model/network_state.dart';
import 'package:projectui/src/resource/repo/auth_repository.dart';
import 'package:rxdart/rxdart.dart';
import '../../../resource/model/PromotionModel.dart';

class PromotionViewModel {
  final authRepository = AuthRepository();

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
