import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/profile_screens/promotion/promotion.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/utils/app_utils.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../resource/model/promotion_model.dart';

class ListPromotionViewModel extends BaseViewModel {
  final promotionSubject = BehaviorSubject<List<Promotion>>();

  Stream<List<Promotion>> get promotionStream => promotionSubject.stream;

  init() {
    getPromotion();
  }

  getPromotion() async {
    List<Promotion> promotions = await AppUtils.getPromotion();
    promotionSubject.sink.add(promotions);
  }

  onTapPromotion(String image, String title, String description) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PromotionDetail(image: image, title: title, description: description),
        ));
  }

  @override
  void dispose() {
    promotionSubject.close();
    super.dispose();
  }
}
