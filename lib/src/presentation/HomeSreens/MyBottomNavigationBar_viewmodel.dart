import 'package:projectui/src/resource/model/network_state.dart';
import 'package:projectui/src/resource/repo/auth_repository.dart';
import 'package:projectui/src/utils/app_utils.dart';

class MyBottomNavigationBarViewModel {
  final authRepository = AuthRepository();

  Future<int> getCountNotification() async {
    if(await AppUtils.checkLogin()){
      NetworkState<int> result = await authRepository.getCountNotification();
      return result.data;
    }else{
      return 0;
    }
  }
}
