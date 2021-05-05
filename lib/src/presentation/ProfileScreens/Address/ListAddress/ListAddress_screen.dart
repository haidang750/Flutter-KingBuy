// Ảnh 45 - Địa chỉ giao hàng
import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/ProfileScreens/Address/ListAddress/ListAddress_viewmodel.dart';
import 'package:projectui/src/presentation/ProfileScreens/Address/CreateAddress/CreateAddress_screen.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/widgets/MyLoading.dart';
import 'package:projectui/src/resource/model/AddressModel.dart';
import 'package:provider/provider.dart';

class ListAddress extends StatefulWidget {
  @override
  ListAddressState createState() => ListAddressState();
}

class ListAddressState extends State<ListAddress> with ResponsiveWidget{
  final listAddressViewModel = ListAddressViewModel();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // lấy dữ liệu về + set dữ liệu vào Provider
      await listAddressViewModel.getDeliveryAddress(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
    listAddressViewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<ListAddressViewModel>(
        viewModel: ListAddressViewModel(),
        builder: (context, viewModel, child) => Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
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
                              builder: (context) => CreateAddress(
                                event: "create",
                              )));
                    },
                  ),
                ),
              ],
            ),
            body: buildUi(context: context)),
    );
  }

  Widget buildScreen() {
    // lấy dữ liệu đã set ở Provider ra sử dụng
    List<Address> listAddress = Provider.of<AddressModel>(context).addresses;
    
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
        : MyLoading();
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
                  builder: (context) => CreateAddress(
                        address: address,
                        event: "update",
                      )));
        });
  }

  @override
  Widget buildDesktop(BuildContext context) {
    // TODO: implement buildDesktop
    return buildScreen();
  }

  @override
  Widget buildMobile(BuildContext context) {
    // TODO: implement buildMobile
    return buildScreen();
  }

  @override
  Widget buildTablet(BuildContext context) {
    // TODO: implement buildTablet
    return buildScreen();
  }
}
