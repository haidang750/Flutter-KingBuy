import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/model/model.dart';

class ChangePasswordViewModel extends BaseViewModel{
  updatePassword(String oldPassword, String newPassword, String newConfirmPassword) async {
    NetworkState<int> result = await authRepository.updatePassword(oldPassword, newPassword, newConfirmPassword);
    if(result.isSuccess){
      return result.data;
    }else{
      return 0;
    }
  }
}