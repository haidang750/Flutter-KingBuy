import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/CategoriesScreens/RootCategories_screen.dart';
import 'package:projectui/src/presentation/HomeSreens/MyBottomNavigationBar_viewmodel.dart';
import 'package:projectui/src/resource/model/model.dart';
import 'package:provider/provider.dart';
import '../LoginScreens/LoginScreen_viewmodel.dart';
import 'HomeScreen.dart';
import '../CategoriesScreens/RootCategories_screen.dart';
import '../Notifications/Notifications_screen.dart';
import '../ProfileScreens/RootProfileScreen.dart';

class MainTabControlDelegate {
  int index;
  Function(int index) tabJumpTo;

  static MainTabControlDelegate _instance;

  static MainTabControlDelegate getInstance() {
    return _instance ??= MainTabControlDelegate._();
  }

  MainTabControlDelegate._();
}

class MyBottomNavigationBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyBottomNavigationBarState();
  }
}

class MyBottomNavigationBarState extends State<MyBottomNavigationBar> with WidgetsBindingObserver {
  int currentIndex = 0;
  final controller = PageController(
    initialPage: 0, // HomeScreen
  );

  @override
  void initState() {
    super.initState();
    MainTabControlDelegate.getInstance().tabJumpTo = (int index) {
      controller?.jumpToPage(index);
    };
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int countNotification = Provider.of<NotificationModel>(context).countNotification;

    return Scaffold(
        body: Column(
      children: [
        Expanded(
            child: PageView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          // hướng swipe
          physics: NeverScrollableScrollPhysics(),
          // Chỉ số Page sẽ bắt đầu từ 0
          children: [
            HomeScreen(), // 0
            RootCategoriesScreen(), // 1
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
              buildBottomItem(0, null),
              buildBottomItem(1, null),
              // Payment Button (middle of BottomNavigationBar)
              GestureDetector(
                child: Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(color: Colors.red.shade700, borderRadius: BorderRadius.all(Radius.circular(28))),
                  child: Center(
                    child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.red.shade700,
                            border: Border.all(width: 2, color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(25))),
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
              buildBottomItem(2, countNotification),
              buildBottomItem(3, null)
            ],
          ),
        )
      ],
    ));
  }

  buildBottomItem(int index, int countNotification) {
    String image;
    String name;
    int count = countNotification;

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
            buildOneItem(image, name, index, count)
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

  Widget buildOneItem(String image, String name, int index, int countNotification) {
    return Column(
      children: [
        Stack(
          children: [
            // build Icon
            Container(
              height: 24,
              width: 40,
              child: Image.asset(
                image,
                color: index == currentIndex ? Colors.red.shade700 : Colors.grey.shade500,
              ),
            ),
            // build Badge
            index == 2 ? buildNotificationItem(countNotification) : Container()
          ],
        ),
        // build Title
        Text(name,
            style: TextStyle(
                fontSize: 14, color: index == currentIndex ? Colors.red.shade700 : Colors.grey.shade500, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget buildNotificationItem(int countNotification) {
    return countNotification != null ? Positioned(
      top: 0,
      right: 2,
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(color: Colors.red.shade500, borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Center(
            child: Text(
              countNotification.toString(),
              style: TextStyle(color: Colors.white),
            )),
      ),
    ) : Container();
  }
}
