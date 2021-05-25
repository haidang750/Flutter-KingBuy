import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/model/model.dart';
import 'package:projectui/src/utils/app_utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:toast/toast.dart';

class WritingCommentViewModel extends BaseViewModel {
  final commentController = TextEditingController();
  final ratingSubject = BehaviorSubject<double>();
  final nameUserSubject = BehaviorSubject<String>();
  final phoneNumberUserSubject = BehaviorSubject<String>();

  init() {
    ratingSubject.sink.add(0.0);
  }

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

  sendComment(int productId) async {
    int status = await userRatingProduct(productId, nameUserSubject.stream.value,
        phoneNumberUserSubject.stream.value, commentController.text, ratingSubject.stream.value);
    if (status == 1) {
      await AppUtils.ratingInfoByProduct(context, productId);
      await AppUtils.getReviewByProduct(context, productId);
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Toast.show("Đánh giá đã được gửi đi", context, gravity: Toast.CENTER);
        Navigator.pop(context);
      });
    } else {
      Toast.show("Đánh giá thất bại", context, gravity: Toast.CENTER);
    }
  }

  @override
  void dispose() {
    super.dispose();
    ratingSubject.close();
    nameUserSubject.close();
    phoneNumberUserSubject.close();
  }
}