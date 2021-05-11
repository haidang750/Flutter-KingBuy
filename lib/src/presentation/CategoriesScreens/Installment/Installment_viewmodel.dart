import 'package:projectui/src/presentation/base/base_viewmodel.dart';
import 'package:projectui/src/resource/model/BankModel.dart';
import 'package:projectui/src/resource/model/CreditModel.dart';
import 'package:projectui/src/resource/model/InstallmentModel.dart';
import 'package:projectui/src/resource/model/model.dart';
import 'package:rxdart/rxdart.dart';

class InstallmentViewModel extends BaseViewModel {
  final bankSubject = BehaviorSubject<List<Bank>>();
  final creditSubject = BehaviorSubject<List<Credit>>();

  Stream<List<Bank>> get bankStream => bankSubject.stream;

  Stream<List<Credit>> get creditStream => creditSubject.stream;

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

  Future<int> createInstallment(int productId, int installmentType, int bankId, int installmentCardType, int monthsInstallment, int
  prepayInstallment)
  async {
    NetworkState<InstallmentModel> result = await categoryRepository.createInstallment(productId, installmentType, bankId, installmentCardType, monthsInstallment, prepayInstallment);
    if(result.isSuccess){
      if(result.data.status == 1){
        return result.data.installmentInfo.id;
      }else{
        return -1;
      }
    }else{
      print("Vui lòng kiểm tra lại kết nối Internet!");
      return -1;
    }
  }

  void dispose() {
    bankSubject.close();
    creditSubject.close();
  }
}
