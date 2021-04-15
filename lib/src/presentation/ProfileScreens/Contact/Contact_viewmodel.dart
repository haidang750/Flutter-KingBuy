import 'package:projectui/src/resource/repo/Contact_Repository.dart';
import 'package:rxdart/rxdart.dart';

class ContactViewModel {
  final _contactRepository = ContactRepository();

  final contactSubject = BehaviorSubject<List<dynamic>>();

  Stream<List<dynamic>> get contactStream => contactSubject.stream;
  Sink<List<dynamic>> get contactSink => contactSubject.sink;

  getContactInfo() async {
    List<dynamic> contactInfo = await _contactRepository.getContactInfo();
    contactSubject.sink.add(contactInfo);
  }

  void dispose() {
    contactSubject.close();
  }
}
