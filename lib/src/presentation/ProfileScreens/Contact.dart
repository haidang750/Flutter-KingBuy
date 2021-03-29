// Ảnh 48 - Liên hệ
import 'package:flutter/material.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Liên hệ")),
        body: Container(
          padding: EdgeInsets.only(left: 25, right: 35, top: 20),
          child: ListView(
            children: [
              Container(
                height: 50,
                child: Row(children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            width: 20,
                            height: 20,
                            child: Image.asset("assets/chat.png")),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "@kingbuy",
                          style: TextStyle(fontSize: 17),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 28,
                    width: 28,
                    child: Image.asset(
                      "assets/messenger.png",
                    ),
                  )
                ]),
              ),
              Container(
                height: 50,
                child: Row(children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            width: 20,
                            height: 20,
                            child: Image.asset("assets/call-answer.png")),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "1900.6810",
                          style: TextStyle(fontSize: 17),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Icon(Icons.arrow_forward_ios_outlined,
                        size: 18, color: Colors.grey),
                  )
                ]),
              ),
              Container(
                height: 50,
                child: Row(children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            width: 20,
                            height: 20,
                            child: Image.asset("assets/email.png")),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "hello@kingbuy.com",
                          style: TextStyle(fontSize: 17),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Icon(Icons.arrow_forward_ios_outlined,
                        size: 18, color: Colors.grey),
                  )
                ]),
              ),
            ],
          ),
        ));
  }
}
