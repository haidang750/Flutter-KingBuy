import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/model/model.dart';
import 'package:rxdart/rxdart.dart';

class DetailContactViewModel extends BaseViewModel{
  final feedbackSubject = BehaviorSubject<ContactModel>();

  Stream<ContactModel> get feedbackStream => feedbackSubject.stream;

  getAllFeedback() async {
    NetworkState result = await authRepository.getAllFeedback();
    feedbackSubject.sink.add(result.data);
  }

  Future<int> userReplyFeedback(String contentRep) async {
    NetworkState result = await authRepository.userReplyFeedback(contentRep);
    return result.data;
  }

  void dispose() {
    feedbackSubject.close();
  }
}