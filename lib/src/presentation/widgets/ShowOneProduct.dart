import 'package:flutter/material.dart';

class ShowOneProduct extends StatelessWidget {
  ShowOneProduct(
      {Key key,
      this.image,
      this.discount,
      this.name,
      this.brand,
      this.newPrice,
      this.oldPrice})
      : super(key: key);
  String image, discount, name, brand, newPrice, oldPrice;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 200,
              child: Image.asset(
                "assets/$image",
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
                top: 4,
                right: 4,
                child: Container(
                  height: 32,
                  width: 58,
                  decoration: BoxDecoration(
                      color: Colors.red.shade700,
                      borderRadius: BorderRadius.all(Radius.circular(19))),
                  child: Center(
                    child: Text(
                      discount,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ))
          ],
        ),
        Expanded(
            child: Padding(
          padding: EdgeInsets.only(top: 10, left: 5, right: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
              SizedBox(
                height: 6,
              ),
              Text(brand,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue)),
              SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.yellow.shade600,
                    size: 14,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.yellow.shade600,
                    size: 14,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.yellow.shade600,
                    size: 14,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.yellow.shade600,
                    size: 14,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.yellow.shade600,
                    size: 14,
                  ),
                ],
              ),
              SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  Text(
                    newPrice,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade700),
                  ),
                  SizedBox(
                    width: 8.7,
                  ),
                  Text(
                    oldPrice,
                    style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.lineThrough),
                  ),
                ],
              )
            ],
          ),
        ))
      ],
    );
  }
}
