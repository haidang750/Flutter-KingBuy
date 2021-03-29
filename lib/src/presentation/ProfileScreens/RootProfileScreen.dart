// Ảnh 41 - Profile chính
import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/LoginScreens/LoginScreen.dart';
import 'package:badges/badges.dart';
import 'package:projectui/src/presentation/ProfileScreens/Address.dart';
import 'package:projectui/src/presentation/ProfileScreens/ChangePassword.dart';
import 'package:projectui/src/presentation/ProfileScreens/KingbuyCommitment.dart';
import 'package:projectui/src/presentation/ProfileScreens/MyCoupon.dart';
import 'package:projectui/src/presentation/ProfileScreens/OrderHistory.dart';
import 'package:projectui/src/presentation/ProfileScreens/Profile.dart';
import 'package:projectui/src/presentation/ProfileScreens/SeenProducts.dart';
import 'package:projectui/src/presentation/ProfileScreens/TermsOfUse.dart';
import 'Contact.dart';
import 'Promotion.dart';

List<Map<String, dynamic>> items = [
  {
    "id": 1,
    "icon": "person.png",
    "content": "Thông tin cá nhân",
    "badgeContent": null
  },
  {
    "id": 2,
    "icon": "promotion.png",
    "content": "Khuyến mãi",
    "badgeContent": "2"
  },
  {
    "id": 3,
    "icon": "bike.png",
    "content": "Địa chỉ giao hàng",
    "badgeContent": null
  },
  {
    "id": 4,
    "icon": "star.png",
    "content": "Coupon của tôi",
    "badgeContent": null
  },
  {
    "id": 5,
    "icon": "history.png",
    "content": "Lịch sử đặt hàng",
    "badgeContent": null
  },
  {
    "id": 6,
    "icon": "eye.png",
    "content": "Sản phẩm đã xem",
    "badgeContent": null
  },
  {
    "id": 7,
    "icon": "lock.png",
    "content": "Đổi mật khẩu",
    "badgeContent": null
  },
  {
    "id": 8,
    "icon": "group.png",
    "content": "Cam kết của Kingbuy",
    "badgeContent": null
  },
  {"id": 9, "icon": "phone.png", "content": "Liên hệ", "badgeContent": null},
  {
    "id": 10,
    "icon": "policy.png",
    "content": "Điều khoản sử dụng",
    "badgeContent": null
  },
];

class RootProfileScreen extends StatefulWidget {
  @override
  _RootProfileScreenState createState() => _RootProfileScreenState();
}

class _RootProfileScreenState extends State<RootProfileScreen> {
  onSelectItem(int id) {
    switch (id) {
      case 1:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Profile(),
            ));
        break;
      case 2:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Promotion(),
            ));
        break;
      case 3:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Address(),
            ));
        break;
      case 4:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyCoupon(),
            ));
        break;
      case 5:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderHistory(),
            ));
        break;
      case 6:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SeenProducts(),
            ));
        break;
      case 7:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangePassword(),
            ));
        break;
      case 8:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KingbuyCommitment(),
            ));
        break;
      case 9:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Contact(),
            ));
        break;
      case 10:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TermsOfUse(),
            ));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: 240,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.only(top: 40)),
                    GestureDetector(
                        // Tạo Badge bằng Stack và Positioned
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage("assets/1.jpg"),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                    color: Colors.red.shade700,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                child: Center(
                                  child: Icon(
                                    Icons.edit_rounded,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        onTap: () {
                          print("Handle Change Avatar");
                        }),
                    SizedBox(
                      height: 15,
                    ),
                    Text("Nguyễn Hải Đăng",
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.bold)),
                    Text("+8412345678",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w400)),
                    Text("5 điểm",
                        style: TextStyle(
                            fontSize: 21,
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.bold))
                  ],
                )),
            Container(
                height: 510,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Container(
                        height: 50,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      child: Center(
                                          // Tạo Badge bằng package bagdes.dart có sẵn
                                          child: Badge(
                                        showBadge:
                                            items[index]["badgeContent"] == null
                                                ? false
                                                : true,
                                        badgeContent: Text(
                                            "${items[index]["badgeContent"]}",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        badgeColor: Colors.red.shade600,
                                        position: BadgePosition.topEnd(
                                            top: -11, end: -11),
                                        child: Container(
                                          height: 24,
                                          width: 24,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12))),
                                          child: Image.asset("assets/" +
                                              "${items[index]["icon"]}"),
                                        ),
                                      )),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "${items[index]["content"]}",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 16,
                              )
                            ],
                          ),
                          onTap: () => {onSelectItem(items[index]["id"])},
                        ));
                  },
                )),
            Container(
              height: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Hotline: 1900.6810",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "2023 Kingbuy.Ver 1.07",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
            Container(
                height: 60,
                child: Center(
                  child: GestureDetector(
                    child: Text(
                      "Đăng xuất",
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ));
                    },
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
