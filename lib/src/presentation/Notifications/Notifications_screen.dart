import 'package:flutter/material.dart';

List<dynamic> notifications = [
  {
    "content":
        "Nhân ngày Quốc Khánh Việt Nam 2/9, Kingbuy xin hân hạnh mang tới cho quý khách hàng chương trình ưu đãi cực hấp dẫn !!!",
    "time": "Thứ hai, 30/08/2019",
    "avatar": "logo.png"
  },
  {
    "content":
        "Kingbuy xin chào quý khách! Tuần mới nhiều niềm vui và tràn đầy hứng khởi bạn yêu nhé!",
    "time": "Thứ ba, 23/09/2019",
    "avatar": "logo.png"
  },
  {
    "content":
        "Chào đón cửa hàng mới, ưu đãi giảm giá lên đến 50%, mua ngay thôi!",
    "time": "Thứ tư, 29/05/2020",
    "avatar": "logo.png"
  },
];

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thông báo"),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
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
                          backgroundImage: AssetImage(
                              "assets/" + "${notifications[index]["avatar"]}"),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                padding: EdgeInsets.only(bottom: 15),
                                child: Text(notifications[index]["content"],
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400))),
                            Container(
                                child: Text(notifications[index]["time"],
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400))),
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
      ),
    );
  }
}
