import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/routers.dart';
import 'package:projectui/src/resource/model/model.dart';
import 'package:rxdart/rxdart.dart';

class StoreLocationViewModel extends BaseViewModel {
  Completer<GoogleMapController> googleMapController = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final storeAddressSubject = BehaviorSubject<List<Store>>();

  Stream<List<Store>> get storeAddressStream => storeAddressSubject.stream;

  init() {
    getListStore();
  }

  getListStore() async {
    List<Store> listStore = await getAllAddress();
    listStore.forEach((store) async {
      MarkerId markerId = MarkerId(store.id.toString());
      Marker marker = Marker(
        markerId: markerId,
        position: LatLng(double.parse(store.latitude), double.parse(store.longitude)),
        infoWindow: InfoWindow(title: store.address),
        // icon: await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(1, 1), devicePixelRatio: 1), AppImages.logo, mipmaps: false)
      );

      markers[markerId] = marker;
    });
  }

  Future<List<Store>> getAllAddress() async {
    NetworkState<StoreModel> result = await authRepository.getAllAddress();
    if (result.isSuccess) {
      if (result.data.status == 1) {
        storeAddressSubject.sink.add(result.data.store);
        return result.data.store;
      } else {
        storeAddressSubject.sink.add([]);
        return [];
      }
    } else {
      storeAddressSubject.sink.add([]);
      return [];
    }
  }

  onTapOneStore(Store store) {
    Navigator.pushNamed(context, Routers.Detail_Store, arguments: store);
  }

  @override
  void dispose() {
    super.dispose();
    storeAddressSubject.close();
  }
}
