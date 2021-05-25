import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/categories_screens/category_utils/price_range.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/model/brand_model.dart';
import 'package:projectui/src/resource/model/category_model.dart';
import 'package:projectui/src/resource/model/searched_product_model.dart';
import 'package:projectui/src/resource/model/network_state.dart';
import 'package:projectui/src/utils/app_utils.dart';
import 'package:rxdart/rxdart.dart';
import '../../../resource/model/list_products_model.dart';

class CategoryDetailViewModel extends BaseViewModel {
  List<PriceRange> priceRanges = [
    PriceRange(id: 1, name: "0 - 10 triệu", from: 0, to: 10000000),
    PriceRange(id: 2, name: "10 - 20 triệu", from: 10000000, to: 20000000),
    PriceRange(id: 3, name: "20 - 50 triệu", from: 20000000, to: 50000000),
    PriceRange(id: 4, name: "50 - 100 triệu", from: 50000000, to: 100000000),
  ];
  final currentCategorySubject = BehaviorSubject<int>();
  final searchController = TextEditingController();
  final searchSubject = BehaviorSubject<String>();
  final categoryIdSubject = BehaviorSubject<int>(); // Dùng trong màn hình [Chi tiết danh mục]/[Danh sách sản phẩm]

// Dưới đây là danh sách các biến dùng cho Filter Screen
  final priceFromController = TextEditingController();
  final priceToController = TextEditingController();
  final idCategorySubject = BehaviorSubject<int>(); // Dùng để thay đổi UI (ClipPath) khi nhấn chọn category khác (theo id)
  final nameCategorySubject = BehaviorSubject<String>(); // Dùng để quản lý giá trị tên danh mục mà ta chọn để lọc
  final idBrandSubject = BehaviorSubject<int>(); // Dùng để thay đổi UI (ClipPath) khi nhấn chọn brand khác (theo id)
  final nameBrandSubject = BehaviorSubject<String>(); // Dùng để quản lý giá trị tên thương hiệu mà ta chọn để lọc
  final idPriceSubject = BehaviorSubject<int>(); // Dùng để thay đổi UI (ClipPath) khi nhấn chọn priceRange khác (theo id)
  final namePriceRangeSubject = BehaviorSubject<String>(); // Dùng để quản lý giá trị range giá mà ta chọn để lọc
  List<Category> listCategories = []; // Dùng để lưu toàn bộ categories lấy về từ API
  List<Brand> listBrands = []; // Dùng để lưu toàn bộ brands lấy về từ API
  List<Category> listCategoriesPartition = []; // Dùng để lưu các category lấy ra từ listCategories
  List<Brand> listBrandsPartition = []; // Dùng để lưu các brand lấy ra từ listBrands
  final listCategoriesSubject = BehaviorSubject<List<Category>>(); // Dùng cho StreamBuilder của Danh mục/GridView.builder
  final listBrandsSubject = BehaviorSubject<List<Brand>>(); // Dùng cho StreamBuilder của Thương hiệu/GridView.builder
  final listPriceRangesSubject = BehaviorSubject<List<PriceRange>>();
  final categoryButtonSubject = BehaviorSubject<String>(); // Dùng cho StreamBuilder của Danh mục/Button Xem thêm-Rút gọn
  final brandButtonSubject = BehaviorSubject<String>(); // Dùng cho StreamBuilder của Thương hiệu/Button Xem thêm-Rút gọn
  final applyButtonSubject = BehaviorSubject<bool>();
  List<String> filterOptions = []; // Dùng để lưu các các option filter đã lựa chọn (tên Danh mục, tên Brand, range giá)
  final filterOptionsSubject = BehaviorSubject<List<String>>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  init(Category category, String searchContent) {
    if (searchContent == null) {
      categoryIdSubject.add(category.id);
    }
    searchController.text = searchContent ?? "";
    getListCategories();
    getListBrands();
    searchSubject.sink.add(searchController.text);
    currentCategorySubject.sink.add(0);
    listCategoriesSubject.sink.add(listCategoriesPartition);
    listBrandsSubject.sink.add(listBrandsPartition);
    listPriceRangesSubject.sink.add(priceRanges);
    categoryButtonSubject.sink.add("Xem thêm");
    brandButtonSubject.sink.add("Xem thêm");
    idCategorySubject.sink.add(0);
    idBrandSubject.sink.add(0);
    idPriceSubject.sink.add(0);
    nameCategorySubject.sink.add("");
    nameBrandSubject.sink.add("");
    namePriceRangeSubject.sink.add("");
    applyButtonSubject.sink.add(false);
    filterOptionsSubject.sink.add(filterOptions);
  }

  getListCategories() async {
    listCategories = await AppUtils.getAllCategories();
    listCategoriesPartition.addAll(listCategories.getRange(0, 4));
  }

  getListBrands() async {
    listBrands = await getBrands();
    listBrandsPartition.addAll(listBrands.getRange(0, 4));
  }

  CategoryDetailViewModel({this.productCategoryId, this.searchWord, this.limit = 10, this.brandId, this.priceFrom = 0, this.priceTo = 1000000000});

  int productCategoryId;
  String searchWord;
  int limit;
  int brandId;
  int priceFrom;
  int priceTo;

  final brandSubject = BehaviorSubject<BrandModel>();

  Stream<BrandModel> get brandStream => brandSubject.stream;

  onSubmitSearchContent(String value) {
    searchSubject.sink.add(value);
    priceFromController.clear();
    priceToController.clear();
    idCategorySubject.sink.add(0);
    idBrandSubject.sink.add(0);
    idPriceSubject.sink.add(0);
    filterOptions.removeRange(0, filterOptions.length);
    filterOptionsSubject.sink.add(filterOptions);
  }

  onDeleteSearchContent() {
    searchController.clear();
    searchSubject.sink.add("");
    priceFromController.clear();
    priceToController.clear();
    idCategorySubject.sink.add(0);
    idBrandSubject.sink.add(0);
    idPriceSubject.sink.add(0);
    nameCategorySubject.sink.add("");
    nameBrandSubject.sink.add("");
    namePriceRangeSubject.sink.add("");
    filterOptions.removeRange(0, filterOptions.length); // Xóa các filter options
    filterOptionsSubject.sink.add(filterOptions);
  }

  handleResetButton() {
    priceFromController.clear();
    priceToController.clear();
    idCategorySubject.sink.add(0);
    idBrandSubject.sink.add(0);
    idPriceSubject.sink.add(0);
    nameCategorySubject.sink.add("");
    nameBrandSubject.sink.add("");
    namePriceRangeSubject.sink.add("");
  }

  handleApplyButton() async {
    applyButtonSubject.sink.add(!applyButtonSubject.stream.value);
    priceFromController.text != "" && priceToController.text != ""
        ? namePriceRangeSubject.sink
        .add("${double.parse(priceFromController.text) / 1000000} - ${double.parse(priceToController.text) / 1000000} triệu")
        : idPriceSubject.stream.value - 1 >= 0
        ? namePriceRangeSubject.sink.add(priceRanges[idPriceSubject.stream.value - 1].name)
        : namePriceRangeSubject.sink.add("");
    if (searchSubject.stream.value != "") {
      filterOptions.removeRange(0, filterOptions.length);
      filterOptions.add(nameCategorySubject.stream.value);
      filterOptions.add(nameBrandSubject.stream.value);
      filterOptions.add(namePriceRangeSubject.stream.value);
    }
    filterOptionsSubject.sink.add(filterOptions);
    Navigator.pop(context);
  }

  handleDeleteFilterOption(int index) {
    switch (index) {
      case 0:
        if (idCategorySubject.stream.value != 0 && nameCategorySubject.stream.value != "") {
          idCategorySubject.sink.add(0);
          nameCategorySubject.sink.add("");
        } else {
          if (idBrandSubject.stream.value != 0 && nameBrandSubject.stream.value != "") {
            idBrandSubject.sink.add(0);
            nameBrandSubject.sink.add("");
          } else {
            idPriceSubject.sink.add(0);
            namePriceRangeSubject.sink.add("");
          }
        }
        break;
      case 1:
        if (idBrandSubject.stream.value != 0 && nameBrandSubject.stream.value != "") {
          idBrandSubject.sink.add(0);
          nameBrandSubject.sink.add("");
        } else {
          idPriceSubject.sink.add(0);
          namePriceRangeSubject.sink.add("");
        }
        break;
      case 2:
        idPriceSubject.sink.add(0);
        namePriceRangeSubject.sink.add("");
        break;
    }
    filterOptions.removeAt(index);
    filterOptionsSubject.sink.add(filterOptions);
    applyButtonSubject.sink.add(!applyButtonSubject.stream.value);
  }

  handleTapOneChildCategory(int index, Category category) {
    // Load lại danh sách sản phẩm khi nhấn chọn 1 Child Category
    if (index > 0) {
      int childCategoryId = category.children[index - 1].id;
      categoryIdSubject.add(childCategoryId);
    } else {
      // Nếu nhấn chọn lại Tất cả (currentCategory = 0)
      categoryIdSubject.add(category.id);
    }
    currentCategorySubject.sink.add(index);
  }

  // Dùng cho GridView Products của mỗi Category
  Future<List<Product>> initRequesterCategoryProduct() async {
    return await loadDataCategoryProduct(0);
  }

  Future<List<Product>> dataRequesterCategoryProduct(int currentSize) async {
    return await loadDataCategoryProduct(currentSize);
  }

  Future<List<Product>> loadDataCategoryProduct(int offset) async {
    NetworkState<ListProductsModel> result =
        await categoryRepository.getProductsByCategory(productCategoryId, searchWord, limit, offset, brandId, priceFrom, priceTo);
    if (result.isSuccess) {
      List<Product> products = result.data.products;
      return products;
    } else {
      print("Vui lòng kiểm tra lại kết nối Internet!");
      return [];
    }
  }

  Future<List<Brand>> getBrands() async {
    NetworkState<BrandModel> result = await categoryRepository.getBrands();
    if (result.isSuccess) {
      brandSubject.sink.add(result.data);
      return result.data.brands;
    } else {
      print("Vui lòng kiểm tra lại kết nối Internet!");
      return [];
    }
  }

  // Dùng cho GridView Searched Products
  Future<List<Product>> initRequesterSearchedProduct() async {
    return await loadDataSearchedProduct(0);
  }

  Future<List<Product>> dataRequesterSearchedProduct(int currentSize) async {
    return await loadDataSearchedProduct(currentSize);
  }

  Future<List<Product>> loadDataSearchedProduct(int offset) async {
    NetworkState<SearchedProductModel> result =
        await categoryRepository.searchProduct(searchWord, limit, offset, productCategoryId, brandId, priceFrom, priceTo);
    if (result.isSuccess) {
      print("Searched Products: ${result.data.products}");
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
    searchSubject.close();
    categoryIdSubject.close();
    idPriceSubject.close();
    listCategoriesSubject.close();
    listBrandsSubject.close();
    listPriceRangesSubject.close();
    categoryButtonSubject.close();
    brandButtonSubject.close();
    brandSubject.close();
    idCategorySubject.close();
    idBrandSubject.close();
    nameCategorySubject.close();
    nameBrandSubject.close();
    namePriceRangeSubject.close();
    applyButtonSubject.close();
    currentCategorySubject.close();
    filterOptionsSubject.close();
  }
}
