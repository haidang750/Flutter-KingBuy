import 'package:flutter/material.dart';
import 'package:projectui/src/resource/model/AddressModel.dart';
import 'package:projectui/src/resource/model/DistrictModel.dart';
import 'package:projectui/src/resource/model/ProvinceModel.dart';
import 'package:projectui/src/resource/model/WardModel.dart';
import 'package:projectui/src/resource/model/network_state.dart';
import 'package:projectui/src/resource/repo/auth_repository.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class AddressViewModel {
  final authRepository = AuthRepository();

  final provinceSubject = BehaviorSubject<List<Province>>();
  final districtSubject = BehaviorSubject<List<District>>();
  final wardSubject = BehaviorSubject<List<Ward>>();

  Stream<List<Province>> get provinceStream => provinceSubject.stream;
  Stream<List<District>> get districtStream => districtSubject.stream;
  Stream<List<Ward>> get wardStream => wardSubject.stream;

  getProvince() async {
    NetworkState<ProvinceModel> result = await authRepository.getProvince();
    if (result.isSuccess) {
      List<Province> provinces = result.data.provinces;
      provinceSubject.sink.add(provinces);
    }
  }

  Future<List<District>> getDistrict(String provinceCode) async {
    NetworkState<DistrictModel> result =
        await authRepository.getDistrict(provinceCode);
    if (result.isSuccess) {
      List<District> districts = result.data.districts;
      districtSubject.sink.add(districts);
      return districts;
    } else {
      return [];
    }
  }

  Future<List<Ward>> getWard(String districtCode) async {
    NetworkState<WardModel> result = await authRepository.getWard(districtCode);
    if (result.isSuccess) {
      List<Ward> wards = result.data.wards;
      wardSubject.sink.add(wards);
      return wards;
    } else {
      return [];
    }
  }

  getDeliveryAddress(BuildContext context) async {
    NetworkState<AddressModel> result =
        await authRepository.getDeliveryAddress();
    if (result.isSuccess) {
      List<Address> addresses = result.data.addresses;
      // Sau khi lấy dữ liệu về thành công thì set dữ liệu vào Provider
      Provider.of<AddressModel>(context, listen: false).setAddress(addresses);
    }
  }

  Future<bool> createDeliveryAddress(
      BuildContext context,
      String fullName,
      String firstPhone,
      String secondPhone,
      String provinceCode,
      String districtCode,
      String wardCode,
      String address,
      int isDefault,
      int isExportInvoice,
      String taxCode,
      String companyName,
      String companyAddress,
      String companyEmail) async {
    NetworkState<AddressModel> result =
        await authRepository.createDeliveryAddress(
            fullName,
            firstPhone,
            secondPhone,
            provinceCode,
            districtCode,
            wardCode,
            address,
            isDefault,
            isExportInvoice,
            taxCode,
            companyName,
            companyAddress,
            companyEmail);
    if (result.isSuccess) {
      List<Address> addresses = result.data.addresses;
      Provider.of<AddressModel>(context, listen: false).setAddress(addresses);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateDeliveryAddress(
      BuildContext context,
      int deliveryAddressId,
      String fullName,
      String firstPhone,
      String secondPhone,
      String provinceCode,
      String districtCode,
      String wardCode,
      String address,
      int isDefault,
      int isExportInvoice,
      String taxCode,
      String companyName,
      String companyAddress,
      String companyEmail) async {
    NetworkState<AddressModel> result =
        await authRepository.updateDeliveryAddress(
            deliveryAddressId,
            fullName,
            firstPhone,
            secondPhone,
            provinceCode,
            districtCode,
            wardCode,
            address,
            isDefault,
            isExportInvoice,
            taxCode,
            companyName,
            companyAddress,
            companyEmail);
    if (result.isSuccess) {
      List<Address> addresses = result.data.addresses;
      Provider.of<AddressModel>(context, listen: false).setAddress(addresses);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteDeliveryAddress(
    BuildContext context,
    int deliveryAddressId,
  ) async {
    NetworkState<AddressModel> result =
        await authRepository.deleteDeliveryAddress(
      deliveryAddressId,
    );
    if (result.isSuccess) {
      List<Address> addresses = result.data.addresses;
      Provider.of<AddressModel>(context, listen: false).setAddress(addresses);
      return true;
    } else {
      return false;
    }
  }

  void dispose() {
    provinceSubject.close();
    districtSubject.close();
    wardSubject.close();
  }
}
