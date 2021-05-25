import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/login_screens/login/Login_screen.dart';

class ShowDialog extends StatefulWidget {
  ShowDialog({this.productId = -1, this.productVideoLink = ""});
  int productId;
  String productVideoLink;

  @override
  ShowDialogState createState() => ShowDialogState();
}

class ShowDialogState extends State<ShowDialog> {
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
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
                          color: AppColors.disableButton,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Text(
                        "Hủy",
                        style: TextStyle(
                            color: AppColors.buttonContent, fontWeight: FontWeight.w500),
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
                        color: AppColors.primary,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Text("Đăng nhập",
                        style: TextStyle(
                            color: AppColors.buttonContent, fontWeight: FontWeight.w500)),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(productId: widget.productId, productVideoLink: widget.productVideoLink),
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
