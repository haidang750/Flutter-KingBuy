import 'package:projectui/src/presentation/base/base_viewmodel.dart';
import 'package:projectui/src/utils/app_utils.dart';

class OrderDetailViewModel extends BaseViewModel {
  String getStatus(int status) {
    return AppUtils.getStatus(status);
  }

  String getPaymentType(int paymentType) {
    switch (paymentType) {
      case 1:
        return "COD";
        break;
      case 2:
        return "Banking";
        break;
      case 3:
        return "VISA";
        break;
      case 4:
        return "Point Rewards";
        break;
      case 5:
        return "Installment";
        break;
      default:
        return null;
    }
  }
}