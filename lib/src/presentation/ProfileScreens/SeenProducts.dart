// Sản phẩm đã xem
import 'package:flutter/material.dart';

List<dynamic> products = [
  {
    "image": "Image 1.png",
    "name": "Ghế massage mini thông minh Maxcare",
    "brand": "Maxcare",
    "newPrice": "14.000.000đ",
    "oldPrice": "26.600.000đ",
    "discount": "- 47%"
  },
  {
    "image": "Image 3.png",
    "name": "Ghế massage Buheung MK-4000 (màu xanh)",
    "brand": "Buheung",
    "newPrice": "72.590.000đ",
    "oldPrice": "82.650.000đ",
    "discount": "- 18%"
  },
  {
    "image": "Image 3.png",
    "name": "Ghế massage toàn thân Inada Dreamwave",
    "brand": "INADA",
    "newPrice": "164.000.000đ",
    "oldPrice": "230.600.000đ",
    "discount": "- 47%"
  },
  {
    "image": "Image 1.png",
    "name": "Ghế massage toàn thân Inada Yume Robo",
    "brand": "INADA",
    "newPrice": "87.590.000đ",
    "oldPrice": "166.650.000đ",
    "discount": "- 45%"
  },
  {
    "image": "Image 1.png",
    "name": "Ghế massage mini thông minh Maxcare",
    "brand": "Maxcare",
    "newPrice": "14.000.000đ",
    "oldPrice": "26.600.000đ",
    "discount": "- 43%"
  },
  {
    "image": "Image 3.png",
    "name": "Ghế massage Buheung MK-4000 màu xanh",
    "brand": "Buheung",
    "newPrice": "72.590.000đ",
    "oldPrice": "82.650.000đ",
    "discount": "- 18%"
  }
];

class SeenProducts extends StatefulWidget {
  @override
  _SeenProductsState createState() => _SeenProductsState();
}

class _SeenProductsState extends State<SeenProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Sản phẩm đã xem")),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Container(
                  height: 50,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/home.png",
                        height: 22,
                        width: 22,
                        color: Colors.black,
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 14,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Tài khoản",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 14,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Sản phẩm đã xem",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 5 / 9,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: List.generate(products.length, (index) {
                        return Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0.5, color: Colors.grey.shade400)),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: 200,
                                      color: Colors.green,
                                      child: Image.asset(
                                        "assets/${products[index]["image"]}",
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
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(19))),
                                          child: Center(
                                            child: Text(
                                              products[index]["discount"],
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ))
                                  ],
                                ),
                                Expanded(
                                    child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 10, left: 8, right: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(products[index]["name"],
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500)),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(products[index]["brand"],
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.blue)),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Colors.yellow.shade500,
                                            size: 18,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.yellow.shade500,
                                            size: 18,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.yellow.shade500,
                                            size: 18,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.yellow.shade500,
                                            size: 18,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.yellow.shade500,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        products[index]["newPrice"],
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red.shade700),
                                      )
                                    ],
                                  ),
                                ))
                              ],
                            ));
                      }),
                    ),
                  ),
                )
              ],
            )));
  }
}
