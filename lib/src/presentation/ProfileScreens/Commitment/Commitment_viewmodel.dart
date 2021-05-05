import 'package:projectui/src/presentation/base/base.dart';
import 'package:rxdart/rxdart.dart';

class CommitmentScreenViewModel extends BaseViewModel {
  final commitmentSubject = BehaviorSubject<List<dynamic>>();

  Stream<List<dynamic>> get commitmentStream => commitmentSubject.stream;
  Sink<List<dynamic>> get commitmentSink => commitmentSubject.sink;

  getCommitmentInfo() async {
    List<dynamic> commitmentInfo =
        await commitmentRepository.getCommitmentInfo();
    commitmentSubject.sink.add(commitmentInfo);
  }

  void dispose() {
    commitmentSubject.close();
  }
}
