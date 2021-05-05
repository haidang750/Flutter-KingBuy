import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/model/CommentModel.dart';
import 'package:projectui/src/resource/model/DetailProductModel.dart';
import 'package:projectui/src/resource/model/ListProductsModel.dart';
import 'package:projectui/src/resource/model/RatingModel.dart';
import 'package:projectui/src/resource/model/network_state.dart';
import 'package:rxdart/rxdart.dart';

class ProductDetailViewModel extends BaseViewModel {
  final productDetailSubject = BehaviorSubject<DetailProductModel>();
  final ratingInfoSubject = BehaviorSubject<RatingModel>();
  final commentInfoSubject = BehaviorSubject<CommentModel>();
  final purchasedTogetherProductsSubject = BehaviorSubject<List<Product>>();
  final relatedProductSubject = BehaviorSubject<List<Product>>();
  final viewedProductsSubject = BehaviorSubject<List<Product>>();

  Stream<DetailProductModel> get productDetailStream => productDetailSubject.stream;
  Stream<RatingModel> get ratingInfoStream => ratingInfoSubject.stream;
  Stream<CommentModel> get commentInfoStream => commentInfoSubject.stream;
  Stream<List<Product>> get purchasedTogetherProductsStream => purchasedTogetherProductsSubject.stream;
  Stream<List<Product>> get relatedProductStream => relatedProductSubject.stream;
  Stream<List<Product>> get viewedProductsStream => viewedProductsSubject.stream;

  getSingleProduct(int productId) async {
    NetworkState<DetailProductModel> result = await categoryRepository.getSingleProduct(productId);
    if (result.isSuccess) {
      productDetailSubject.sink.add(result.data);
    } else {
      print("Vui lòng kiểm tra lại kết nối Internet!");
    }
  }

  ratingInfoByProduct(int productId) async {
    NetworkState<RatingModel> result = await categoryRepository.ratingInfoByProduct(productId);
    if (result.isSuccess) {
      ratingInfoSubject.sink.add(result.data);
    } else {
      print("Vui lòng kiểm tra lại kết nối Internet!");
    }
  }

  getReviewByProduct(int productId) async {
    NetworkState<CommentModel> result = await categoryRepository.getReviewByProduct(productId);
    if (result.isSuccess) {
      commentInfoSubject.sink.add(result.data);
    } else {
      print("Vui lòng kiểm tra lại kết nối Internet!");
    }
  }

  purchasedTogetherProducts(int productId) async {
    NetworkState<ListProductsModel> result = await categoryRepository.purchasedTogetherProducts(productId);
    if (result.isSuccess) {
      purchasedTogetherProductsSubject.sink.add(result.data.products);
    } else {
      print("Vui lòng kiểm tra lại kết nối Internet!");
    }
  }

  Future<List<Product>> getRelatedProducts(int productId, int offset) async {
    // Lấy dữ liệu theo filter, limit = 6, offset
    NetworkState<ListProductsModel> result =
    await categoryRepository.relatedProduct(productId, 6, offset);
    if (result.isSuccess) {
      List<Product> relatedProducts = result.data.products;
      relatedProductSubject.sink.add(relatedProducts);
      return relatedProducts;
    } else {
      return [];
    }
  }

  getViewedProducts() async {
    NetworkState<ListProductsModel> result = await authRepository.getViewedProducts(6, 0);
    if(result.isSuccess){
      viewedProductsSubject.sink.add(result.data.products);
    }else{
      print("Vui lòng kiểm tra lại kết nối Internet!");
      viewedProductsSubject.sink.add([]);
    }
  }

  void dispose() {
    productDetailSubject.close();
    ratingInfoSubject.close();
    commentInfoSubject.close();
    purchasedTogetherProductsSubject.close();
    relatedProductSubject.close();
    viewedProductsSubject.close();
  }
}
