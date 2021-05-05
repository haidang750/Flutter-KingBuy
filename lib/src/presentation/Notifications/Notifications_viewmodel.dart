import 'package:projectui/src/presentation/base/base_viewmodel.dart';
import 'package:projectui/src/resource/model/NotificationModel.dart';
import 'package:projectui/src/resource/model/network_state.dart';
import 'package:projectui/src/utils/app_utils.dart';
import 'package:rxdart/subjects.dart';

class NotificationViewModel extends BaseViewModel {
  final listNotificationSubject = BehaviorSubject<List<Notification>>();

  Stream<List<Notification>> get listNotificationStream =>
      listNotificationSubject.stream;

  getListNotification() async {
    if(await AppUtils.checkLogin()){
      NetworkState<NotificationModel> result =
      await authRepository.getListNotification(10, 0);
      if (result.isSuccess) {
        List<Notification> listNotification = result.data.notifications;
        listNotificationSubject.sink.add(listNotification);
      }
    }else{
      listNotificationSubject.sink.add([]);
    }
  }

  void dispose() {
    listNotificationSubject.close();
  }
}
