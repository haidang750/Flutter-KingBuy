import 'package:projectui/src/resource/repo/Commitment_Repository.dart';
import 'package:rxdart/rxdart.dart';

class CommitmentViewModel {
  final _commitmentRepository = CommitmentRepository();

  final commitmentSubject = BehaviorSubject<List<dynamic>>();

  Stream<List<dynamic>> get commitmentStream => commitmentSubject.stream;
  Sink<List<dynamic>> get commitmentSink => commitmentSubject.sink;

  getCommitmentInfo() async {
    List<dynamic> commitmentInfo =
        await _commitmentRepository.getCommitmentInfo();
    commitmentSubject.sink.add(commitmentInfo);
  }

  void dispose() {
    commitmentSubject.close();
  }
}
