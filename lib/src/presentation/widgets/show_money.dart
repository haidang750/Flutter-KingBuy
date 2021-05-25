import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShowMoney extends StatelessWidget {
  ShowMoney(
      {Key key,
      this.price,
      this.fontSizeLarge,
      this.fontSizeSmall,
      this.color,
      this.fontWeight,
      this.isLineThrough})
      : super(key: key);
  int price;
  double fontSizeLarge;
  double fontSizeSmall;
  Color color;
  FontWeight fontWeight;
  bool isLineThrough;

  String formatMoney(int money) {
    if (money != null)
      return "${NumberFormat(",###", "vi").format(money)}";
    else
      return "0";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          formatMoney(price),
          style: TextStyle(
              fontSize: fontSizeLarge,
              fontWeight: fontWeight,
              color: color,
              decoration: isLineThrough ? TextDecoration.lineThrough : null),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "đ",
              style: TextStyle(
                  fontSize: fontSizeSmall,
                  fontWeight: fontWeight,
                  color: color),
            )
          ],
        )
      ],
    );
  }
}
