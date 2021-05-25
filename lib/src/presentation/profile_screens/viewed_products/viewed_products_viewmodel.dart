import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/base/base_viewmodel.dart';
import 'package:projectui/src/presentation/widgets/my_grid_view.dart';
import 'package:projectui/src/resource/model/list_products_model.dart';
import 'package:projectui/src/resource/model/viewed_product_local_storage.dart';
import 'package:projectui/src/resource/model/network_state.dart';
import 'package:projectui/src/utils/app_utils.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class ViewedProductsViewModel extends BaseViewModel {
  final keyGridView = GlobalKey<MyGridViewState>();
  final checkLoginSubject = BehaviorSubject<bool>();
  final viewedProductsLocalSubject = BehaviorSubject<List<Product>>();

  Stream<List<Product>> get viewedProductsLocalStream => viewedProductsLocalSubject.stream;

  init(BuildContext context) {
    checkLoginToGetViewedProducts(context);
  }

  checkLoginToGetViewedProducts(BuildContext context) async {
    List<int> idViewedProducts = Provider.of<ViewedProductLocalStorage>(context, listen: false).idViewedProducts;
    bool isLogin = await AppUtils.checkLogin();

    if (isLogin == false) getViewedProductsLocal(idViewedProducts);
    checkLoginSubject.sink.add(isLogin);
  }

  getViewedProductsLocal(List<int> productIds) async {
    if (productIds.length != 0) {
      List<Product> result = await AppUtils.getViewedProductsLocal(productIds);
      viewedProductsLocalSubject.sink.add(result);
    } else {
      viewedProductsLocalSubject.sink.add([]);
    }
  }

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

  @override
  void dispose() {
    super.dispose();
    checkLoginSubject.close();
    viewedProductsLocalSubject.close();
  }
}
