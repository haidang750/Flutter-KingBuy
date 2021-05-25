import 'package:projectui/src/presentation/base/base_viewmodel.dart';
import 'package:rxdart/rxdart.dart';

class OrderHistoryViewModel extends BaseViewModel {
  final filterSubject = BehaviorSubject<int>();

  init() {
    filterSubject.sink.add(-1);
  }

  @override
  void dispose() {
    super.dispose();
    filterSubject.close();
  }
}
