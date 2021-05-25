import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/model/cart_model.dart';
import 'package:rxdart/rxdart.dart';

class PaymentTypeViewModel extends BaseViewModel {
  final selectedPaymentType = BehaviorSubject<int>();

  init() {
    selectedPaymentType.sink.add(-1);
  }

  onSelectPaymentType() {
    CartModel.of(context).setPaymentMethod(selectedPaymentType.stream.value);
    Navigator.pop(context, selectedPaymentType.stream.value);
  }

  @override
  void dispose() {
    super.dispose();
    selectedPaymentType.close();
  }
}