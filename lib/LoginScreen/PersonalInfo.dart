import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:badges/badges.dart';

class PersonalInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PersonalInfoState();
  }
}

class PersonalInfoState extends State<PersonalInfo> {
  String radioValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Thông tin cá nhân"),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20, top: 16, bottom: 8),
              child: ButtonTheme(
                  minWidth: 66,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  buttonColor: Colors.grey.shade500,
                  child: RaisedButton(
                    child: Text("LƯU",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                        )),
                    onPressed: () {},
                  )),
            )
          ],
        ),
        body: Container(
          alignment: Alignment.center,
          child: ListView(
            children: [
              Container(
                  height: 160,
                  child: Center(
                      child: GestureDetector(
                          child: Container(
                              height: 100,
                              width: 100,
                              child: Badge(
                                badgeContent: Icon(
                                  Icons.edit_rounded,
                                  color: Colors.white,
                                ),
                                badgeColor: Colors.red.shade700,
                                position: BadgePosition.bottomEnd(
                                    bottom: -6, end: -6),
                                child: Image.asset(
                                  "assets/user@2x.png",
                                  fit: BoxFit.cover,
                                ),
                              )),
                          onTap: () {
                            print("Handle Change Avatar");
                          }))),
              Container(
                height: 270,
                child: Column(
                  children: [
                    Container(
                        height: 56,
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(width: 0.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(28))),
                          child: Row(
                            children: [
                              Container(
                                  width: 80,
                                  child: Center(
                                      child: Container(
                                          width: 16,
                                          height: 20,
                                          child: Image.asset(
                                            "assets/user.png",
                                            fit: BoxFit.cover,
                                          )))),
                              Expanded(
                                child: Container(
                                  child: TextField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Họ và tên"),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Container(
                        height: 56,
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(width: 0.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(28))),
                          child: Row(
                            children: [
                              Container(
                                  width: 80,
                                  child: Center(
                                      child: Container(
                                          width: 20,
                                          height: 20,
                                          child: Image.asset(
                                            "assets/phone.png",
                                            fit: BoxFit.cover,
                                          )))),
                              Expanded(
                                child: Container(
                                  child: TextField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Số điện thoại"),
                                    keyboardType: TextInputType.phone,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Container(
                        height: 56,
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(width: 0.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(28))),
                          child: Row(
                            children: [
                              Container(
                                  width: 80,
                                  child: Center(
                                      child: Container(
                                          child: Icon(
                                              Icons.calendar_today_sharp)))),
                              Expanded(
                                child: Container(
                                  child: TextField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Ngày tháng năm sinh"),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                    ),
                    Container(
                        height: 56,
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(width: 0.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(28))),
                          child: Row(
                            children: [
                              Container(
                                  width: 80,
                                  child: Center(
                                      child: Container(
                                          child: Icon(Icons.email_outlined)))),
                              Expanded(
                                child: Container(
                                  child: TextField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Email"),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        "Giới tính",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w400),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          children: [
                            Radio(
                                value: "Nam",
                                groupValue: radioValue,
                                onChanged: (value) {
                                  setState(() {
                                    radioValue = value;
                                  });
                                }),
                            Text("Nam", style: TextStyle(fontSize: 17)),
                            Radio(
                                value: "Nữ",
                                groupValue: radioValue,
                                onChanged: (value) {
                                  setState(() {
                                    radioValue = value;
                                  });
                                }),
                            Text("Nữ", style: TextStyle(fontSize: 17)),
                          ],
                        ))
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
