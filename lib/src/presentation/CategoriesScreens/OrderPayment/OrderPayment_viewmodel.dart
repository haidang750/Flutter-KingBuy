import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/model/model.dart';

class OrderPaymentViewModel extends BaseViewModel {
  Future<String> createPayment(int invoiceId) async {
    NetworkState<PaymentModel> result = await categoryRepository.createPayment(invoiceId);
    if(result.data.status == 1){
      return result.data.paymentUrl.url;
    }else{
      return null;
    }
  }
}