import 'package:projectui/src/presentation/base/base.dart';
import 'package:rxdart/rxdart.dart';

class CommitmentScreenViewModel extends BaseViewModel {
  final commitmentSubject = BehaviorSubject<List<dynamic>>();

  Stream<List<dynamic>> get commitmentStream => commitmentSubject.stream;
  Sink<List<dynamic>> get commitmentSink => commitmentSubject.sink;

  init() {
    getCommitmentInfo();
  }

  getCommitmentInfo() async {
    List<dynamic> commitmentInfo =
        await commitmentRepository.getCommitmentInfo();
    commitmentSubject.sink.add(commitmentInfo);
  }

  @override
  void dispose() {
    commitmentSubject.close();
    super.dispose();
  }
}
