import 'package:projectui/src/presentation/base/base_viewmodel.dart';
import 'package:projectui/src/resource/model/invoice_model.dart';
import 'package:projectui/src/resource/model/order_history_model.dart';
import 'package:projectui/src/resource/model/model.dart';

class ListOrderViewModel extends BaseViewModel {
  Future<List<InvoiceData>> loadData(int filter, int offset) async {
    // Lấy dữ liệu theo filter, limit = 10, offset
    NetworkState<OrderHistoryModel> result =
    await authRepository.getOrderHistory(filter, 10, offset);
    if (result.isSuccess) {
      List<InvoiceData> invoices = result.data.invoices;
      return invoices;
    } else {
      return [];
    }
  }

  String getStatus(int status) {
    switch (status) {
      case 0:
        return "Đơn hàng chờ xác nhận";
        break;
      case 1:
        return "Đơn hàng chờ vận chuyển";
        break;
      case 2:
        return "Đơn hàng thành công";
        break;
      case 3:
        return "Đơn hàng đã hủy";
        break;
      case 4:
        return "Đơn hàng chờ thanh toán";
        break;
      default:
        return null;
    }
  }
}