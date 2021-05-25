import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/base/base_viewmodel.dart';
import 'package:projectui/src/resource/model/bank_model.dart';
import 'package:projectui/src/resource/model/credit_model.dart';
import 'package:projectui/src/resource/model/installment_model.dart';
import 'package:projectui/src/resource/model/model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:toast/toast.dart';

import '../../routers.dart';

class InstallmentViewModel extends BaseViewModel {
  final currentBank = BehaviorSubject<int>();
  final currentCard = BehaviorSubject<int>();
  final currentInstallmentMonth = BehaviorSubject<int>();
  final currentInstallmentPrepay = BehaviorSubject<int>();
  final installmentEachMonthSubject = BehaviorSubject<int>();
  final prepaySubject = BehaviorSubject<int>();
  final bankSubject = BehaviorSubject<List<Bank>>();
  final creditSubject = BehaviorSubject<List<Credit>>();

  init(Product product) {
    getBanks();
    getCreditList();
    currentBank.sink.add(0);
    currentCard.sink.add(0);
    currentInstallmentMonth.sink.add(0);
    currentInstallmentPrepay.sink.add(0);
    getPrepayMoney(product);
    getInstallmentPayEachMonth(product);
  }

  Stream<List<Bank>> get bankStream => bankSubject.stream;

  Stream<List<Credit>> get creditStream => creditSubject.stream;

  getInstallmentPayEachMonth(Product product) {
    installmentEachMonthSubject.sink.add(
        ((product.salePrice - prepaySubject.stream.value) / double.parse(product.installmentMonths[currentInstallmentMonth.stream.value])).round());
    prepaySubject.sink.add((product.salePrice * double.parse(product.installmentPrepay[currentInstallmentPrepay.stream.value]) / 100).round());
  }

  getPrepayMoney(Product product) {
    prepaySubject.sink.add((product.salePrice * double.parse(product.installmentPrepay[currentInstallmentPrepay.stream.value]) / 100).round());
    installmentEachMonthSubject.sink.add(
        ((product.salePrice - prepaySubject.stream.value) / double.parse(product.installmentMonths[currentInstallmentMonth.stream.value])).round());
  }

  getBanks() async {
    NetworkState<BankModel> result = await categoryRepository.getBanks();
    if (result.isSuccess) {
      List<Bank> banks = result.data.banks;
      bankSubject.sink.add(banks);
    } else {
      print("Vui lòng kiểm tra lại kết nối Internet!");
      bankSubject.sink.add([]);
    }
  }

  getCreditList() async {
    NetworkState<CreditModel> result = await categoryRepository.getCreditList();
    if (result.isSuccess) {
      List<Credit> credits = result.data.credits;
      creditSubject.sink.add(credits);
    } else {
      print("Vui lòng kiểm tra lại kết nối Internet!");
      creditSubject.sink.add([]);
    }
  }

  selectBank(int index) {
    currentBank.sink.add(index);
  }

  selectCard(int index) {
    currentCard.sink.add(index);
  }

  selectInstallmentMonths(int index, Product product) {
    currentInstallmentMonth.sink.add(index);
    getInstallmentPayEachMonth(product);
    getPrepayMoney(product);
  }

  selectInstallmentPrepay(int index, Product product) {
    currentInstallmentPrepay.sink.add(index);
    getInstallmentPayEachMonth(product);
    getPrepayMoney(product);
  }

  Future<int> createInstallment(
      int productId, int installmentType, int bankId, int installmentCardType, int monthsInstallment, int prepayInstallment) async {
    NetworkState<InstallmentModel> result =
        await categoryRepository.createInstallment(productId, installmentType, bankId, installmentCardType, monthsInstallment, prepayInstallment);
    if (result.isSuccess) {
      if (result.data.status == 1) {
        return result.data.installmentInfo.id;
      } else {
        return -1;
      }
    } else {
      print("Vui lòng kiểm tra lại kết nối Internet!");
      return -1;
    }
  }

  handleConfirmInstallment(Product product) async {
    int productId = product.id;
    int installmentType = 1;
    int bankId = bankSubject.stream.value[currentBank.stream.value].id;
    int installmentCardType = creditSubject.stream.value[currentCard.stream.value].id;
    int monthsInstallment = int.parse(product.installmentMonths[currentInstallmentMonth.stream.value]);
    int prepayInstallment = int.parse(product.installmentPrepay[currentInstallmentPrepay.stream.value]);

    int invoiceId = await createInstallment(productId, installmentType, bankId, installmentCardType, monthsInstallment, prepayInstallment);

    // Nếu đặt mua trả góp thành công thì dùng invoiceId cho API detailInstallment
    if (invoiceId != -1) {
      Toast.show("Thành công", context, gravity: Toast.CENTER);
      Navigator.pushNamed(context, Routers.Installment_Detail, arguments: invoiceId);
    } else {
      Toast.show("Đặt mua trả góp không thành công", context, gravity: Toast.CENTER);
    }
  }

  @override
  void dispose() {
    super.dispose();
    currentBank.close();
    currentCard.close();
    bankSubject.close();
    creditSubject.close();
    currentInstallmentMonth.close();
    currentInstallmentPrepay.close();
    installmentEachMonthSubject.close();
    prepaySubject.close();
  }
}
