import 'package:projectui/src/resource/model/NotificationModel.dart';
import 'package:projectui/src/resource/model/network_state.dart';
import 'package:projectui/src/resource/repo/auth_repository.dart';
import 'package:rxdart/subjects.dart';

class NotificationViewModel {
  final authRepository = AuthRepository();

  final listNotificationSubject = BehaviorSubject<List<Notification>>();

  Stream<List<Notification>> get listNotificationStream =>
      listNotificationSubject.stream;

  getListNotification() async {
    // limit = 10, offset = 0
    NetworkState<NotificationModel> result =
        await authRepository.getListNotification(10, 0);
    if (result.isSuccess) {
      List<Notification> listNotification = result.data.notifications;
      listNotificationSubject.sink.add(listNotification);
    }
  }

  void dispose() {
    listNotificationSubject.close();
  }
}
