import 'package:projectui/src/presentation/base/base_viewmodel.dart';
import 'package:projectui/src/resource/model/ListProductsModel.dart';
import 'package:projectui/src/resource/model/network_state.dart';

class ViewedProductsViewModel extends BaseViewModel {
  Future<List<Product>> initRequester() async {
    return await loadData(0);
  }

  Future<List<Product>> dataRequester(int currentSize) async {
    return await loadData(currentSize);
  }

  Future<List<Product>> loadData(int offset) async {
    NetworkState<ListProductsModel> result = await authRepository.getViewedProducts(10, offset);

    if (result.isSuccess) {
      List<Product> products = result.data.products;
      return products;
    } else {
      print("Vui lòng kiểm tra lại kết nối Internet!");
      return [];
    }
  }
}
