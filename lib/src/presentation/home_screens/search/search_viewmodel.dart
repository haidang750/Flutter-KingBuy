import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/categories_screens/category_detail/category_detail_screen.dart';
import 'package:projectui/src/presentation/categories_screens/category_detail/category_detail_viewmodel.dart';
import 'package:projectui/src/presentation/categories_screens/product_detail/product_detail_screen.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/model/list_products_model.dart';
import 'package:projectui/src/utils/app_shared.dart';
import 'package:rxdart/rxdart.dart';

class SearchViewModel extends BaseViewModel {
  final searchController = TextEditingController();
  final searchContentSubject = BehaviorSubject<String>();
  final listSearchSubject = BehaviorSubject<List<String>>();
  final searchedProductSubject = BehaviorSubject<List<Product>>();

  init() {
    searchController.text = "";
    searchContentSubject.sink.add(searchController.text);
    getListSearch();
    searchedProductSubject.sink.add([]);
  }

  getListSearch() async {
    listSearchSubject.sink.add(await AppShared.getListSearch());
  }

  onChangeSearchContent(String value) async {
    searchContentSubject.sink.add(value);
    CategoryDetailViewModel searchedCategoryDetailViewModel = CategoryDetailViewModel(searchWord: value, productCategoryId: 0, brandId: 0, limit: 6);

    List<Product> searchedProduct = await searchedCategoryDetailViewModel.loadDataSearchedProduct(0);
    searchedProductSubject.sink.add(searchedProduct);
  }

  onSubmitSearchContent(String value) {
    // Lưu từ khóa đã search vào Local
    if (value != "") {
      if (listSearchSubject.stream.value == null) {
        List<String> listSearch = [];
        listSearch.add(value);
        listSearchSubject.sink.add(listSearch);
        AppShared.setListSearch(listSearchSubject.stream.value);
      } else {
        List<String> listSearch = listSearchSubject.stream.value;
        listSearch.add(value);
        listSearchSubject.sink.add(listSearch);
        AppShared.setListSearch(listSearchSubject.stream.value);
      }
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryDetail(searchContent: searchController.text)));
  }

  onDeleteSearchHistory() {
    listSearchSubject.sink.add(null);
    AppShared.setListSearch(null);
  }

  onTapOneSearchResult(Product product) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductDetail(
                product: product,
                productId: product.id,
                productVideoLink: product.videoLink)));
  }

  @override
  void dispose() {
    super.dispose();
    listSearchSubject.close();
    searchedProductSubject.close();
    searchContentSubject.close();
  }
}
