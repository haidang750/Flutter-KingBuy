// Ảnh 45 - Địa chỉ giao hàng
import 'package:flutter/material.dart';

List<Map<String, dynamic>> addresses = [
  {
    "name": "Nguyễn Văn A",
    "address": "Số 12 Đinh Tiên Hoàng, phường Đa Kao, Quận 1, Hồ Chí Minh",
    "phone": "0123456789",
    "default": true
  },
  {
    "name": "Nguyễn Văn B",
    "address": "Lại Thế, Phú Thượng, Phú Vang, Thừa Thiên Huế",
    "phone": "098234546",
    "default": false
  },
  {
    "name": "Nguyễn Hải Đăng",
    "address": "Lại Thế, Phú Thượng, Phú Vang, Thừa Thiên Huế",
    "phone": "0987552546",
    "default": false
  }
];

class Address extends StatefulWidget {
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
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
        body: Container(
            color: Colors.grey.shade300,
            child: ListView.builder(
              itemCount: addresses.length,
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
                                addresses[index]["name"],
                                style: TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 3),
                              Text(addresses[index]["address"],
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400)),
                              SizedBox(height: 3),
                              Text(addresses[index]["phone"],
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400)),
                              Container(
                                padding: EdgeInsets.only(top: 5),
                                child: addresses[index]["default"]
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
            )));
  }
}
