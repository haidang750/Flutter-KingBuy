import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/model/model.dart';

class WritingCommentViewModel extends BaseViewModel {
  userRatingProduct(int productId, String name, String phoneNumber, String comment, double rating) async {
    NetworkState<int> result = await categoryRepository.userRatingProduct(productId, name, phoneNumber, comment, rating);

    if (result.isSuccess) {
      int status = result.data;
      return status;
    } else {
      print("Vui lòng kiểm tra lại kết nối Internet!");
      return 0;
    }
  }
}