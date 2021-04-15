// Ảnh 45 - Địa chỉ giao hàng
import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/ProfileScreens/Address/Address_viewmodel.dart';
import 'package:projectui/src/presentation/ProfileScreens/Address/HandleAddress_screen.dart';
import 'package:projectui/src/resource/model/AddressModel.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class AddressScreen extends StatefulWidget {
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<AddressScreen> {
  final addressViewModel = AddressViewModel();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // lấy dữ liệu về + set dữ liệu vào Provider
      await addressViewModel.getDeliveryAddress(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
    addressViewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // lấy dữ liệu đã set ở Provider ra sử dụng
    List<Address> listAddress = Provider.of<AddressModel>(context).addresses;

    return Scaffold(
        appBar: AppBar(
          title: Text("Địa chỉ giao hàng"),
          actions: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 15, 10),
              child: GestureDetector(
                child: CircleAvatar(
                  radius: 12,
                  child: Icon(
                    Icons.add,
                    size: 20,
                  ),
                  backgroundColor: Colors.white,
                ),
                onTap: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HandleAddress(
                                event: "create",
                              )));
                },
              ),
            ),
          ],
        ),
        body: buildListAddress(listAddress));
  }

  Widget buildListAddress(List<Address> listAddress) {
    return listAddress != null
        ? Container(
            color: Colors.grey.shade300,
            child: ListView.builder(
                itemCount: listAddress.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      buildOneAddress(listAddress[index]),
                      Opacity(
                          opacity: 1.0,
                          child: Container(
                            height: 5,
                          )),
                    ],
                  );
                }))
        : Center(child: CircularProgressIndicator());
  }

  Widget buildOneAddress(Address address) {
    return GestureDetector(
        child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20, 15, 20, 10),
            color: Colors.white,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.fullName,
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  Text(address.fullAddress,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
                  Text(address.firstPhone,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    child: address.isDefault == 1
                        ? Text(
                            "Địa chỉ mặc định",
                            style: TextStyle(
                                color: Colors.red.shade600,
                                fontSize: 17,
                                fontWeight: FontWeight.w600),
                          )
                        : null,
                  )
                ],
              ),
            )),
        onTap: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HandleAddress(
                        address: address,
                        event: "update",
                      )));
        });
  }
}
