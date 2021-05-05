import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/base/base_viewmodel.dart';
import 'package:projectui/src/resource/model/AddressModel.dart';
import 'package:projectui/src/resource/model/network_state.dart';
import 'package:provider/provider.dart';

class ListAddressViewModel extends BaseViewModel {
  getDeliveryAddress(BuildContext context) async {
    NetworkState<AddressModel> result =
        await authRepository.getDeliveryAddress();
    if (result.isSuccess) {
      List<Address> addresses = result.data.addresses;
      // Sau khi lấy dữ liệu về thành công thì set dữ liệu vào Provider
      Provider.of<AddressModel>(context, listen: false).setAddress(addresses);
    }
  }
}
