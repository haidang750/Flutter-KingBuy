import 'package:projectui/src/resource/repo/auth_repository.dart';
import 'package:rxdart/rxdart.dart';

class MyBottomNavigationBarViewModel {
  final authRepository = AuthRepository();

  final countNotificationSubject = BehaviorSubject<int>();

  Stream<int> get countNotificationStream => countNotificationSubject.stream;

  getCountNotification() async {
    int countNotification =
        await authRepository.getCountNotification().then((value) {
      if (value.isSuccess) {
        return value.data;
      } else {
        return null;
      }
    });
    countNotificationSubject.sink.add(countNotification);
  }

  void dispose() {
    countNotificationSubject.close();
  }
}
