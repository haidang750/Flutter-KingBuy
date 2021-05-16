import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/base/base_viewmodel.dart';
import 'package:projectui/src/resource/model/AddressModel.dart';
import 'package:projectui/src/resource/model/network_state.dart';
import 'package:projectui/src/utils/app_shared.dart';
import 'package:provider/provider.dart';

class ListAddressViewModel extends BaseViewModel {
  getDeliveryAddress(BuildContext context) async {
    NetworkState<AddressModel> result = await authRepository.getDeliveryAddress();
    if (result.isSuccess) {
      List<Address> listAddress = result.data.addresses;
      // Sau khi lấy dữ liệu về thành công thì set dữ liệu vào Provider
      Provider.of<AddressModel>(context, listen: false).setAddress(listAddress);
      saveListAddressLocal(listAddress);
    }
  }

  // Sau khi đăng nhập và lấy danh sách Address về thì lưu danh sách này vào Local để sử dụng khi không Đăng nhập
  saveListAddressLocal(List<Address> listAddress) {
    List<String> listAddressLocal = [];
    listAddress.forEach((address) {
      listAddressLocal.add(json.encode(address));
    });
    AppShared.setListAddress(listAddressLocal);
  }
}
