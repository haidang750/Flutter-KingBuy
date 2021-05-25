import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/base/base_viewmodel.dart';
import 'package:projectui/src/resource/model/comment_model.dart';
import 'package:projectui/src/resource/model/profile.dart';
import 'package:projectui/src/utils/app_utils.dart';
import 'package:rxdart/rxdart.dart';

class RatingAndCommentViewModel extends BaseViewModel {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final isUserRatedSubject = BehaviorSubject<bool>();
  final productCommentSubject = BehaviorSubject<List<Comment>>();
  final userProfileSubject = BehaviorSubject<Profile>();

  init(int productId, bool isUserRated) {
    AppUtils.ratingInfoByProduct(context, productId);
    AppUtils.getReviewByProduct(context, productId);
    isUserRatedSubject.sink.add(isUserRated);
  }

  bool isUserRated(int userId, List<Comment> comments) {
    return comments.any((comment) => comment.userId == userId ? true : false);
  }

  @override
  void dispose() {
    super.dispose();
    isUserRatedSubject.close();
    productCommentSubject.close();
    userProfileSubject.close();
  }
}