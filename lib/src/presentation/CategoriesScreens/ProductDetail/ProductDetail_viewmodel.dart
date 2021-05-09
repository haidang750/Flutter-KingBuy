import 'package:flutter/cupertino.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/model/CommentModel.dart';
import 'package:projectui/src/resource/model/DetailProductModel.dart';
import 'package:projectui/src/resource/model/ListProductsModel.dart';
import 'package:projectui/src/resource/model/ProductQuestionModel.dart';
import 'package:projectui/src/resource/model/RatingModel.dart';
import 'package:projectui/src/resource/model/network_state.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class ProductDetailViewModel extends BaseViewModel {
  final productDetailSubject = BehaviorSubject<DetailProductModel>();
  final purchasedTogetherProductsSubject = BehaviorSubject<List<Product>>();
  final relatedProductSubject = BehaviorSubject<List<Product>>();
  final viewedProductsSubject = BehaviorSubject<List<Product>>();
  final viewedProductsLocalSubject = BehaviorSubject<List<Product>>();
  final productQuestionsSubject = BehaviorSubject<List<Question>>();

  Stream<DetailProductModel> get productDetailStream => productDetailSubject.stream;

  Stream<List<Product>> get purchasedTogetherProductsStream => purchasedTogetherProductsSubject.stream;

  Stream<List<Product>> get relatedProductStream => relatedProductSubject.stream;

  Stream<List<Product>> get viewedProductsStream => viewedProductsSubject.stream;

  Stream<List<Product>> get viewedProductsLocalStream => viewedProductsLocalSubject.stream;

  Stream<List<Question>> get productQuestionsStream => productQuestionsSubject.stream;

  getSingleProduct(int productId) async {
    NetworkState<DetailProductModel> result = await categoryRepository.getSingleProduct(productId);
    if (result.isSuccess) {
      productDetailSubject.sink.add(result.data);
    } else {
      print("Vui lòng kiểm tra lại kết nối Internet!");
    }
  }

  ratingInfoByProduct(BuildContext context, int productId) async {
    NetworkState<RatingModel> result = await categoryRepository.ratingInfoByProduct(productId);
    if (result.isSuccess) {
      Provider.of<RatingModel>(context, listen: false).setRatingInfo(result.data);
    } else {
      print("Vui lòng kiểm tra lại kết nối Internet!");
    }
  }

  // kiểm tra xem tài khoản đã Đánh giá một sản phẩm nào đó hay chưa
  bool isUserRated(int userId, List<Comment> comments) {
    return comments.any((comment) => comment.userId == userId ? true : false);
  }

  getReviewByProduct(BuildContext context, int productId) async {
    NetworkState<CommentModel> result = await categoryRepository.getReviewByProduct(productId);
    if (result.isSuccess) {
      Provider.of<CommentModel>(context, listen: false).setCommentInfo(result.data);
    } else {
      print("Vui lòng kiểm tra lại kết nối Internet!");
    }
  }

  getProductQuestions(int productId) async {
    NetworkState<ProductQuestionModel> result = await categoryRepository.getProductQuestions(productId, 3, 0);
    if (result.isSuccess) {
      List<Question> productQuestions = result.data.questions;
      productQuestionsSubject.sink.add(productQuestions);
    } else {
      print("Vui lòng kiểm tra lại kết nối Internet!");
    }
  }

  Future<int> requestAnswerQuestion(int productId, String content) async {
    NetworkState<int> result = await categoryRepository.requestAnswerQuestion(productId, content);
    if (result.isSuccess) {
      int status = result.data;
      return status;
    } else {
      print("Vui lòng kiểm tra lại kết nối Internet!");
      return 0;
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
    NetworkState<ListProductsModel> result = await categoryRepository.relatedProduct(productId, 6, offset);
    if (result.isSuccess) {
      List<Product> relatedProducts = result.data.products;
      relatedProductSubject.sink.add(relatedProducts);
      return relatedProducts;
    } else {
      return [];
    }
  }

  getViewedProductsLocal(List<int> productIds) async {
    if (productIds.length != 0) {
      NetworkState<ListProductsModel> result = await categoryRepository.getProductById(productIds);
      if (result.isSuccess) {
        viewedProductsLocalSubject.sink.add(result.data.products);
      } else {
        print("Vui lòng kiểm tra lại kết nối Internet!");
        viewedProductsLocalSubject.sink.add([]);
      }
    } else {
      viewedProductsLocalSubject.sink.add([]);
    }
  }

  getViewedProducts() async {
    NetworkState<ListProductsModel> result = await authRepository.getViewedProducts(6, 0);
    if (result.isSuccess) {
      viewedProductsSubject.sink.add(result.data.products);
    } else {
      print("Vui lòng kiểm tra lại kết nối Internet!");
      viewedProductsSubject.sink.add([]);
    }
  }

  void dispose() {
    productDetailSubject.close();
    purchasedTogetherProductsSubject.close();
    relatedProductSubject.close();
    viewedProductsSubject.close();
    viewedProductsLocalSubject.close();
    productQuestionsSubject.close();
  }
}
