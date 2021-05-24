import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/configs/constants/app_colors.dart';
import 'package:projectui/src/presentation/Notifications/Notifications_viewmodel.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/widgets/MyLoading.dart';

class Notifications extends StatefulWidget {
  @override
  NotificationsState createState() => NotificationsState();
}

class NotificationsState extends State<Notifications> with ResponsiveWidget {
  final notificationViewModel = NotificationViewModel();

  @override
  void initState() {
    super.initState();
    notificationViewModel.getListNotification();
  }

  @override
  void dispose() {
    notificationViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      mainScreen: true,
        viewModel: notificationViewModel,
        builder: (context, viewModel, child) => Scaffold(
            appBar: AppBar(
                title: Text("Thông báo", style: TextStyle(color: AppColors.black)),
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.white),
            body: buildUi(context: context)));
  }

  Widget buildScreen() {
    return StreamBuilder(
      stream: notificationViewModel.listNotificationStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data.length > 0
              ? ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                            padding: EdgeInsets.fromLTRB(5, 15, 25, 5),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(15, 0, 10, 40),
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: AppColors.primary,
                                    backgroundImage: AssetImage(AppImages.logo),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          padding: EdgeInsets.only(bottom: 15),
                                          child: Text(snapshot.data[index].title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400))),
                                      Container(
                                          child: Text(DateFormat("dd/MM/yyyy").format(snapshot.data[index].createdAt),
                                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400))),
                                    ],
                                  ),
                                )
                              ],
                            )),
                        Container(
                          height: 0.5,
                          color: Colors.grey.shade500,
                        )
                      ],
                    );
                  },
                )
              : Center(child: Text("Không có dữ liệu"));
        } else {
          return MyLoading();
        }
      },
    );
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
