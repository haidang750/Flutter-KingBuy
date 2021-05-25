import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/model/model.dart';
import 'package:rxdart/rxdart.dart';

class DetailContactViewModel extends BaseViewModel{
  final feedbackController = TextEditingController();
  ScrollController scrollController = ScrollController();
  final feedbackSubject = BehaviorSubject<ContactModel>();

  Stream<ContactModel> get feedbackStream => feedbackSubject.stream;

  init() {
    getAllFeedback();
  }

  getAllFeedback() async {
    NetworkState result = await authRepository.getAllFeedback();
    feedbackSubject.sink.add(result.data);
  }

  Future<int> userReplyFeedback(String contentRep) async {
    NetworkState result = await authRepository.userReplyFeedback(contentRep);
    return result.data;
  }

  handleUserReply() async {
    int status = await userReplyFeedback(feedbackController.text);
    if (status == 1) {
      print("Gửi phản hồi thành công");
      feedbackController.text = "";
      await getAllFeedback();
      scrollController.animateTo(scrollController.position.maxScrollExtent + 50, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      print("Gửi phản hồi thất bại");
    }
  }

  @override
  void dispose() {
    super.dispose();
    feedbackSubject.close();
  }
}