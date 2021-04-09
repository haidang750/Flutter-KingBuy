// Ảnh 45 - Địa chỉ giao hàng
import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/ProfileScreens/Address/Address_viewmodel.dart';

class Address extends StatefulWidget {
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  final addressViewModel = AddressViewModel();

  @override
  void initState() {
    super.initState();
    addressViewModel.fetchAllAddresses();
  }

  @override
  void dispose() {
    super.dispose();
    addressViewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                onTap: () {
                  print("Thêm địa chỉ");
                },
              ),
            ),
          ],
        ),
        body: _buildListAddress());
  }

  Widget _buildListAddress() {
    return StreamBuilder(
      stream: addressViewModel.addressStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
              color: Colors.grey.shade300,
              child: ListView.builder(
                itemCount: snapshot.data.addresses.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(20, 15, 20, 10),
                          color: Colors.white,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data.addresses[index].fullname,
                                  style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 3),
                                Text(snapshot.data.addresses[index].fullAddress,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400)),
                                SizedBox(height: 3),
                                Text(snapshot.data.addresses[index].firstPhone,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400)),
                                Container(
                                  padding: EdgeInsets.only(top: 5),
                                  child: snapshot.data.addresses[index]
                                              .isDefault ==
                                          1
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
                      Opacity(
                          opacity: 1.0,
                          child: Container(
                            height: 5,
                          )),
                    ],
                  );
                },
              ));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
