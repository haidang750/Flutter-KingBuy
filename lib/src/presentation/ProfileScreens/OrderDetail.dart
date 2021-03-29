// Ảnh 44 - Chi tiết đơn hàng
import 'package:flutter/material.dart';

List<dynamic> products = [
  {
    "image": "Image 1.png",
    "name": "Ghế Massage King Sport G33...",
    "price": "35.400.000đ",
    "attachment": null,
    "quantity": "x1"
  },
  {
    "image": "Image 1.png",
    "name": "Ghế Massage King Sport G36...",
    "price": "65.000.000đ",
    "attachment": null,
    "quantity": "x1"
  },
  {
    "image": "Image 3.png",
    "name": "Gối Massage Buheung MK-31...",
    "price": "0đ",
    "attachment": "Tặng kèm",
    "quantity": "x1"
  }
];

class OrderDetail extends StatelessWidget {
  OrderDetail({Key key, this.order}) : super(key: key);
  final Map<String, String> order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Đơn hàng"),
        ),
        body: Container(
          child: ListView(
            children: [
              Container(
                height: 120,
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ĐẶT HÀNG THÀNH CÔNG",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(order["time"],
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400)),
                    Row(
                      children: [
                        Text("Mã đơn hàng: ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400)),
                        Text("QU18291010",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Spacer(),
                        Icon(
                          Icons.copy,
                          color: Colors.red,
                        )
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 0.5,
                  color: Colors.grey,
                ),
              ),
              Container(
                height: order["status"] == "Đã giao hàng" ? 120 : 80,
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "TRẠNG THÁI ĐƠN HÀNG",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(order["status"],
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400)),
                    Container(
                      child: order["status"] == "Đã giao hàng"
                          ? Text("11:00 - Thứ 3, 04/06/2019",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400))
                          : null,
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 0.5,
                  color: Colors.grey,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "DANH SÁCH SẢN PHẨM (${order.length})",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            height: products.length * 80.0,
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                return Container(
                                    height: 80,
                                    padding: EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 80,
                                          width: 80,
                                          child: Image.asset(
                                              "assets/${products[index]["image"]}"),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(left: 15),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(products[index]["name"],
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: products[index][
                                                                    "attachment"] !=
                                                                null
                                                            ? Colors.blue
                                                            : Colors.black)),
                                                SizedBox(height: 3),
                                                Row(
                                                  children: [
                                                    Text(
                                                        products[index]
                                                            ["price"],
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .red.shade600)),
                                                    Spacer(),
                                                    Text(
                                                        products[index]
                                                            ["quantity"],
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400))
                                                  ],
                                                ),
                                                SizedBox(height: 3),
                                                Container(
                                                    child: products[index][
                                                                "attachment"] !=
                                                            null
                                                        ? Text("Tặng kèm",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .purple))
                                                        : null)
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ));
                              },
                            ),
                          )
                        ],
                      )),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 0.5,
                  color: Colors.grey,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "THÔNG TIN GIAO HÀNG",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nguyễn Văn A",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 1.6),
                        ),
                        Text(
                            "Số 12 Đinh Tiên Hoàng, phường Đa Kao, Quận 1, Hồ Chí Minh",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                height: 1.3)),
                        Text("012345678 - 0345678927",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                height: 1.6))
                      ],
                    ))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 0.5,
                  color: Colors.grey,
                ),
              ),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("GHI CHÚ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      Text("Gọi điện thoại báo trước khi giao hàng!",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400))
                    ],
                  )),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                width: MediaQuery.of(context).size.width,
                height: 7,
                color: Colors.grey.shade300,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "YÊU CẦU XUẤT HÓA ĐƠN VAT",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mã số thuế 0109067764",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 1.6),
                        ),
                        Text("Công ty ABC Natural",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                height: 1.3)),
                        Text(
                            "Số 12 Đinh Tiên Hoàng, phường Đa Kao, Quận 1, Hồ Chí Minh",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                height: 1.3)),
                        Text("abcnatural@gmail.com",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                height: 1.3))
                      ],
                    ))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                width: MediaQuery.of(context).size.width,
                height: 7,
                color: Colors.grey.shade300,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "THÔNG TIN THANH TOÁN",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: [
                        Text("Tạm tính",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400)),
                        Spacer(),
                        Text("100.400.000đ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text("Phí vận chuyển",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400)),
                        Spacer(),
                        Text("100.000đ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text("Giảm giá",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400)),
                        Spacer(),
                        Text("-10.500.000đ",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Divider(
                      height: 0.5,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text("TỔNG",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Spacer(),
                        Text("90.000.000đ",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade600)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                width: MediaQuery.of(context).size.width,
                height: 7,
                color: Colors.grey.shade300,
              ),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("PHƯƠNG THỨC THANH TOÁN",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      Text("Thanh toán bằng tiền mặt khi nhận hàng",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400))
                    ],
                  )),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                width: MediaQuery.of(context).size.width,
                height: 7,
                color: Colors.grey.shade300,
              ),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("ĐIỂM TÍCH LŨY",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      Text("10 điểm",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.red.shade600))
                    ],
                  )),
            ],
          ),
        ));
  }
}
