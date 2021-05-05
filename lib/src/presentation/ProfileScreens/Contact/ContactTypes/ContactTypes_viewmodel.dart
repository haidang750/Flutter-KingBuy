import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/model/model.dart';
import 'package:rxdart/rxdart.dart';

class ContactTypesViewModel extends BaseViewModel {
  final contactSubject = BehaviorSubject<List<dynamic>>();

  Stream<List<dynamic>> get contactStream => contactSubject.stream;

  getContactInfo() async {
    List<dynamic> contactInfo = await contactRepository.getContactInfo();
    contactSubject.sink.add(contactInfo);
  }

  Future<bool> checkFeedbackOfUser() async {
    NetworkState<bool> result = await authRepository.checkFeedbackOfUser();
    return result.data;
  }

  void dispose() {
    contactSubject.close();
  }
}
