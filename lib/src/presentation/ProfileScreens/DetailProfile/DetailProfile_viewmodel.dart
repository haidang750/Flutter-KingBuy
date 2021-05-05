import 'package:projectui/src/presentation/base/base_viewmodel.dart';
import 'package:projectui/src/resource/model/Data.dart';
import 'package:projectui/src/resource/model/model.dart';

class DetailProfileViewModel extends BaseViewModel {
  getProfile() async {
    NetworkState<Data> result = await authRepository.getProfile();
    if (result.isSuccess) {
      print("Success: ${result.data}");
    } else if (result.isError) {
      print(result.message);
    }
  }

  Future<NetworkState<Data>> updateProfile(
    String name,
    String phoneNumber,
    String dateOfBirth,
    int gender,
    String email,
    String avatarPath,
  ) async {
    NetworkState<Data> result = await authRepository.updateProfile(
        name: name,
        phoneNumber: phoneNumber,
        dateOfBirth: dateOfBirth,
        gender: gender,
        email: email,
        avatarPath: avatarPath);
    return result;
  }
}
