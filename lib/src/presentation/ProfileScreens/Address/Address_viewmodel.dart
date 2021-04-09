import 'package:projectui/src/resource/model/AddressModel.dart';
import 'package:projectui/src/resource/repo/Address_Repository.dart';
import 'package:rxdart/rxdart.dart';

class AddressViewModel {
  final _addressRepository = AddressRepository();

  final addressSubject = BehaviorSubject<AddressList>();

  Stream<AddressList> get addressStream => addressSubject.stream;
  Sink<AddressList> get addressSink => addressSubject.sink;

  fetchAllAddresses() async {
    AddressList addresses = await _addressRepository.fetchAllAddresses();
    addressSubject.sink.add(addresses);
  }

  void dispose() {
    addressSubject.close();
  }
}
