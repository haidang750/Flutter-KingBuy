import 'package:projectui/src/resource/model/ProductModel.dart';
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
    NetworkState<ProductModel> result =
        await authRepository.getViewedProducts(6, offset);
    if (result.isSuccess) {
      List<Product> promotions = result.data.products;
      return promotions;
    } else {
      return [];
    }
  }
}
