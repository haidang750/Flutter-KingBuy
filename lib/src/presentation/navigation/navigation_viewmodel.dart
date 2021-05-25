import 'package:projectui/src/presentation/base/base_viewmodel.dart';
import 'package:projectui/src/resource/model/network_state.dart';
import 'package:projectui/src/utils/app_utils.dart';

class NavigationViewModel extends BaseViewModel {
  Future<int> getCountNotification() async {
    if(await AppUtils.checkLogin()){
      NetworkState<int> result = await authRepository.getCountNotification();
      return result.data;
    }else{
      return 0;
    }
  }
}
