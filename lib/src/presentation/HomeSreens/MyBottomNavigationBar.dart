import 'package:flutter/material.dart';
import 'HomeScreen.dart';
import '../StoreScreens/RootStoreScreen.dart';
import '../ProfileScreens/Notifications.dart';
import '../ProfileScreens/RootProfileScreen.dart';

class MyBottomNavigationBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyBottomNavigationBarState();
  }
}

class MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int currentIndex = 0;
  final controller = PageController(
    initialPage: 0, // HomeScreen
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
            child: PageView(
          controller: controller,
          scrollDirection: Axis.horizontal, // hướng swipe
          // Chỉ số Page sẽ bắt đầu từ 0
          children: [
            HomeScreen(), // 0
            RootStoreScreen(), // 1
            Notifications(), // 2
            RootProfileScreen() // 3
          ],
          // thay đổi UI bottom khi lướt
          onPageChanged: (value) {
            setState(() {
              currentIndex = value;
            });
          },
        )),
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildBottomItem(0),
              buildBottomItem(1),
              // Payment Button (middle of BottomNavigationBar)
              GestureDetector(
                child: Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                      color: Colors.red.shade700,
                      borderRadius: BorderRadius.all(Radius.circular(28))),
                  child: Center(
                    child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.red.shade700,
                            border: Border.all(width: 2, color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        child: Icon(
                          Icons.payment_outlined,
                          size: 22,
                          color: Colors.white,
                        )),
                  ),
                ),
                onTap: () {
                  print("Press on Payment Button");
                },
              ),
              buildBottomItem(2),
              buildBottomItem(3)
            ],
          ),
        )
      ],
    ));
  }

  buildBottomItem(int index) {
    String image;
    String name;

    switch (index) {
      case 0:
        image = "assets/home.png";
        name = "Trang chủ";
        break;
      case 1:
        image = "assets/menu.png";
        name = "Danh mục";
        break;
      case 2:
        image = "assets/alarm.png";
        name = "Thông báo";
        break;
      case 3:
        image = "assets/user.png";
        name = "Tài khoản";
        break;
    }

    return GestureDetector(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 12),
            ),
            Column(
              children: [
                Container(
                  height: 24,
                  width: 24,
                  child: Image.asset(
                    image,
                    color: index == currentIndex
                        ? Colors.red.shade700
                        : Colors.grey.shade500,
                  ),
                ),
                Text(name,
                    style: TextStyle(
                        fontSize: 14,
                        color: index == currentIndex
                            ? Colors.red.shade700
                            : Colors.grey.shade500,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
        // thay đổi Page khi click item bottom
        onTap: () {
          setState(() {
            currentIndex = index;
          });
          controller.jumpToPage(currentIndex);
        });
  }
}
