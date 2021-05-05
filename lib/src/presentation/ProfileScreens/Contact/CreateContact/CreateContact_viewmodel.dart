import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/model/network_state.dart';

class CreateContactViewModel extends BaseViewModel {
  Future<String> userSendContact(String fullName, String email, String phone,
      String subject, String body) async {
    NetworkState<String> result = await authRepository.userSendContact(
        fullName, email, phone, subject, body);
    return result.data;
  }
}