import 'package:projectui/src/resource/model/ListProductsModel.dart';
import 'package:projectui/src/resource/model/network_state.dart';
import 'package:projectui/src/resource/repo/auth_repository.dart';

class ViewedProductsViewModel {
  final authRepository = AuthRepository();

  Future<List<Product>> initRequester() async {
    return await loadData(0);
  }

  Future<List<Product>> dataRequester(int currentSize) async {
    return await loadData(currentSize);
  }

  Future<List<Product>> loadData(int offset) async {
    // Lấy dữ liệu theo limit = 6, offset
    NetworkState<ListProductsModel> result =
        await authRepository.getViewedProducts(6, offset);
    if (result.isSuccess) {
      List<Product> products = result.data.products;
      return products;
    } else {
      print("Vui lòng kiểm tra lại kết nối Internet!");
      return [];
    }
  }
}
