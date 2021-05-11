import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/model/InstallmentDetailModel.dart';
import 'package:projectui/src/resource/model/model.dart';
import 'package:rxdart/rxdart.dart';

class InstallmentDetailViewModel extends BaseViewModel {
  final detailInstallmentSubject = BehaviorSubject<InstallmentDetailModel>();

  Stream<InstallmentDetailModel> get detailInstallmentStream => detailInstallmentSubject.stream;

  detailInstallment(int invoiceId) async {
    NetworkState<InstallmentDetailModel> result = await categoryRepository.detailInstallment(invoiceId);
    if (result.isSuccess) {
      InstallmentDetailModel installmentDetail = result.data;
      detailInstallmentSubject.sink.add(installmentDetail);
    } else {
      print("Vui lòng kiểm tra lại kết nối Internet!");
    }
  }

  void dispose() {
    detailInstallmentSubject.close();
  }
}