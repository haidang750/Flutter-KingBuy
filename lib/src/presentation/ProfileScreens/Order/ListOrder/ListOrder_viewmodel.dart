import 'package:projectui/src/presentation/base/base_viewmodel.dart';
import 'package:projectui/src/resource/model/OrderHistoryModel.dart';
import 'package:projectui/src/resource/model/model.dart';

class ListOrderViewModel extends BaseViewModel {
  Future<List<Order>> loadData(int filter, int offset) async {
    // Lấy dữ liệu theo filter, limit = 10, offset
    NetworkState<OrderHistoryModel> result =
    await authRepository.getOrderHistory(filter, 10, offset);
    if (result.isSuccess) {
      print("recordsTotal: ${result.data.recordsTotal}");
      List<Order> orders = result.data.orders;
      return orders;
    } else {
      return [];
    }
  }
}