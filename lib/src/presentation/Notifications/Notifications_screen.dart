import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:projectui/src/presentation/Notifications/Notifications_viewmodel.dart';
import 'package:projectui/src/utils/app_shared.dart';
import 'package:projectui/src/utils/app_utils.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
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
    return Scaffold(
        appBar: AppBar(
          title: Text("Thông báo"),
          automaticallyImplyLeading: false,
        ),
        body: buildListNotification());
  }

  Widget buildListNotification() {
    return StreamBuilder(
      stream: notificationViewModel.listNotificationStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data.length > 0 ? ListView.builder(
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
                              backgroundColor: Colors.red.shade600,
                              backgroundImage: AssetImage("assets/logo.png"),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    padding: EdgeInsets.only(bottom: 15),
                                    child: Text(snapshot.data[index].title,
                                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400))),
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
          ) : Center(child: Text("Không có dữ liệu"));
        } else {
          return Center(
            child: SpinKitCircle(color: Colors.blue, size: 40),
          );
        }
      },
    );
  }
}
