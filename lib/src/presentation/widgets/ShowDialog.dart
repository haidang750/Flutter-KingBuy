import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/LoginScreens/LoginScreen.dart';

class ShowDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 50),
      child: Container(
        height: 110,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Bạn chưa đăng nhập?",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Button Hủy
                GestureDetector(
                    child: Container(
                      height: 30,
                      width: 80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade500,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Text(
                        "Hủy",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    }),
                SizedBox(
                  width: 30,
                ),
                // Button Đăng nhập
                GestureDetector(
                  child: Container(
                    height: 30,
                    width: 80,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.red.shade700,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Text("Đăng nhập",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500)),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ));
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
