import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectui/src/presentation/widgets/show_dialog.dart';
import 'package:projectui/src/resource/model/address_model.dart';
import 'package:projectui/src/resource/model/category_model.dart';
import 'package:projectui/src/resource/model/comment_model.dart';
import 'package:projectui/src/resource/model/list_products_model.dart';
import 'package:projectui/src/resource/model/product_question_model.dart';
import 'package:projectui/src/resource/model/promotion_model.dart';
import 'package:projectui/src/resource/model/rating_model.dart';
import 'package:projectui/src/resource/model/network_state.dart';
import 'package:projectui/src/resource/repo/auth_repository.dart';
import 'package:projectui/src/resource/repo/category_repository.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:toast/toast.dart';
import 'app_shared.dart';

class AppUtils {
  AppUtils._();

  static final authRepository = AuthRepository();
  static final categoryRepository = CategoryRepository();

  static Future<bool> checkLogin() async => await AppShared.getAccessToken() != null ? true : false;

  static void myShowDialog(BuildContext context, int productId, String productVideoLink) => showDialog(
        context: context,
        builder: (context) {
          return ShowDialog(productId: productId, productVideoLink: productVideoLink);
        },
      );

  static handleMessenger(BuildContext context) async {
    if (await canLaunch('http://m.me/100040733580443')) {
      await launch('https://m.me/100040733580443');
    } else
      Toast.show("Không thể mở Messenger", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  }

  static handleZalo(BuildContext context) async {
    print("handleZalo()");
  }

  static handlePhone(BuildContext context, String hotLine) async {
    if (await canLaunch('tel:$hotLine')) {
      await launch('tel:$hotLine');
    } else {
      Toast.show("Không thể mở điện thoại", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  static Future<List<Category>> getAllCategories() async {
    NetworkState<CategoryModel> result = await categoryRepository.getAllCategories();
    return result.data.categories;
  }

  static ratingInfoByProduct(BuildContext context, int productId) async {
    NetworkState<RatingModel> result = await categoryRepository.ratingInfoByProduct(productId);
    if (result.isSuccess) {
      Provider.of<RatingModel>(context, listen: false).setRatingInfo(result.data);
    } else {
      print("Vui lòng kiểm tra lại kết nối Internet!");
    }
  }

  static getReviewByProduct(BuildContext context, int productId) async {
    NetworkState<CommentModel> result = await categoryRepository.getReviewByProduct(productId);
    if (result.isSuccess) {
      Provider.of<CommentModel>(context, listen: false).setCommentInfo(result.data);
    } else {
      print("Vui lòng kiểm tra lại kết nối Internet!");
    }
  }

  static getProductQuestions(BuildContext context, int productId, int limit) async {
    NetworkState<ProductQuestionModel> result = await categoryRepository.getProductQuestions(productId, limit, 0);
    if (result.isSuccess) {
      Provider.of<ProductQuestionModel>(context, listen: false).setProductQuestion(result.data);
    } else {
      print("Vui lòng kiểm tra lại kết nối Internet!");
    }
  }

  static Future<int> requestAnswerQuestion(int productId, String content) async {
    NetworkState<int> result = await categoryRepository.requestAnswerQuestion(productId, content);
    if (result.isSuccess) {
      int status = result.data;
      return status;
    } else {
      print("Vui lòng kiểm tra lại kết nối Internet!");
      return 0;
    }
  }

  static Future<List<Promotion>> getPromotion() async {
    NetworkState<PromotionModel> result = await authRepository.getPromotion(10, 0);
    if (result.isSuccess) {
      List<Promotion> promotions = result.data.promotions;
      return promotions;
    } else {
      return [];
    }
  }

  static Future<CategoryModel> getHotCategories() async {
    NetworkState<CategoryModel> result = await categoryRepository.getHotCategories();
    if (result.isSuccess) {
      return result.data;
    } else {
      print("Vui lòng kiểm tra lại kết nối Internet!");
      return null;
    }
  }

  static Future<List<Address>> updateDeliveryAddress(
      BuildContext context,
      int deliveryAddressId,
      String fullName,
      String firstPhone,
      String secondPhone,
      String provinceCode,
      String districtCode,
      String wardCode,
      String address,
      int isDefault,
      int isExportInvoice,
      String taxCode,
      String companyName,
      String companyAddress,
      String companyEmail) async {
    NetworkState<AddressModel> result = await authRepository.updateDeliveryAddress(deliveryAddressId, fullName, firstPhone, secondPhone, provinceCode,
        districtCode, wardCode, address, isDefault, isExportInvoice, taxCode, companyName, companyAddress, companyEmail);
    if (result.isSuccess) {
      List<Address> addresses = result.data.addresses;
      Provider.of<AddressModel>(context, listen: false).setAddress(addresses);
      return addresses;
    } else {
      return null;
    }
  }

  static String getStatus(int status) {
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

  static Future<List<Product>> getViewedProductsLocal(List<int> productIds) async {
    if (productIds.length != 0) {
      NetworkState<ListProductsModel> result = await categoryRepository.getProductById(productIds);
      if (result.isSuccess) {
        return result.data.products;
      } else {
        print("Vui lòng kiểm tra lại kết nối Internet!");
        return [];
      }
    } else {
      return [];
    }
  }

  static copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    Toast.show("Copied to Clipboard", context, gravity: Toast.CENTER);
  }
}
