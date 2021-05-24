import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/resource/model/model.dart';
import 'package:rxdart/rxdart.dart';

class StoreLocationViewModel extends BaseViewModel {
  final storeAddressSubject = BehaviorSubject<List<Store>>();

  Stream<List<Store>> get storeAddressStream => storeAddressSubject.stream;

  Future<List<Store>> getAllAddress() async {
    NetworkState<StoreModel> result = await authRepository.getAllAddress();
    if(result.isSuccess){
      if(result.data.status == 1){
        storeAddressSubject.sink.add(result.data.store);
        return result.data.store;
      }else{
        storeAddressSubject.sink.add([]);
        return [];
      }
    }else{
      storeAddressSubject.sink.add([]);
      return [];
    }
  }

  void dispose() {
    storeAddressSubject.close();
  }
}