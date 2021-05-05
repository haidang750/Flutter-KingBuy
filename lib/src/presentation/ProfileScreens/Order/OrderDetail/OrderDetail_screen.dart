// Ảnh 44 - Chi tiết đơn hàng
import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/presentation/widgets/ShowMoney.dart';
import 'package:projectui/src/resource/model/ListProductsModel.dart';
import 'package:projectui/src/resource/model/OrderHistoryModel.dart';

class OrderDetail extends StatefulWidget {
  OrderDetail({this.order});

  Order order;

  @override
  OrderDetailState createState() => OrderDetailState();
}

class OrderDetailState extends State<OrderDetail> with ResponsiveWidget {
  final orderDetailViewModel = OrderDetailViewModel();

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: orderDetailViewModel,
        builder: (context, viewModel, child) => Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              title: Text("Chi tiết đơn hàng"),
            ),
            body: buildUi(context: context)));
  }

  Widget buildScreen() {
    return Container(
      child: ListView(
        children: [
          buildOrderSuccess(),
          buildSeperateLine1(),
          buildOrderStatus(),
          buildSeperateLine1(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "DANH SÁCH SẢN PHẨM (${widget.order.items.length})",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      buildListProduct(),
                    ],
                  )),
            ],
          ),
          buildSeperateLine1(),
          buildDeliveryInfo(),
          buildSeperateLine1(),
          buildNote(widget.order.note),
          widget.order.isExportInvoice == 1 ? buildSeperateLine2(context) : Container(),
          buildExportInvoice(widget.order.isExportInvoice),
          buildSeperateLine2(context),
          buildPaymentInfo(widget.order.total + widget.order.discount + widget.order.deliveryCharge, widget.order.deliveryCharge,
              widget.order.discount, widget.order.total),
          buildSeperateLine2(context),
          buildPaymentMethod(widget.order.paymentType),
          buildSeperateLine2(context),
          buildRewardPoints(widget.order.rewardPoints)
        ],
      ),
    );
  }

  String getStatus(int status) {
    switch (status) {
      case 0:
        return "Đơn hàng chờ xác nhận";
        break;
      case 1:
        return "Đơn hàng chờ vận chuyển";
        break;
      case 2:
        return "Đơn hàng thành công";
        break;
      case 3:
        return "Đơn hàng đã hủy";
        break;
      case 4:
        return "Đơn hàng chờ thanh toán";
        break;
      default:
        return null;
    }
  }

  String getPaymentType(int paymentType) {
    switch (paymentType) {
      case 1:
        return "COD";
        break;
      case 2:
        return "Banking";
        break;
      case 3:
        return "VISA";
        break;
      case 4:
        return "Point Rewards";
        break;
      case 5:
        return "Installment";
        break;
      default:
        return null;
    }
  }

  Widget buildSeperateLine1() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 0.5,
        color: Colors.grey,
      ),
    );
  }

  Widget buildSeperateLine2(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      height: 7,
      color: Colors.grey.shade300,
    );
  }

  Widget buildOrderSuccess() {
    return Container(
      height: 120,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ĐẶT HÀNG THÀNH CÔNG",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(widget.order.createdAt, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
          Row(
            children: [
              Text("Mã đơn hàng: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
              Text(widget.order.invoiceCode, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Spacer(),
              Icon(
                Icons.copy,
                color: Colors.red,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildOrderStatus() {
    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "TRẠNG THÁI ĐƠN HÀNG",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(getStatus(widget.order.status), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }

  Widget buildOneProduct(String imageSource, String name, Color color, int price, int quantity, bool isGift) {
    return Container(
        alignment: Alignment.center,
        height: 100,
        padding: EdgeInsets.only(top: 10),
        child: Row(
          children: [
            Container(
                height: 90,
                width: 90,
                child: Image.network(
                  "${AppEndpoint.BASE_URL}$imageSource",
                  fit: BoxFit.fill,
                )),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: color)),
                    SizedBox(height: 3),
                    Row(
                      children: [
                        ShowMoney(
                          price: price,
                          fontSizeLarge: 18,
                          fontSizeSmall: 14,
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.bold,
                          isLineThrough: false,
                        ),
                        Spacer(),
                        Text("x${quantity.toString()}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400))
                      ],
                    ),
                    SizedBox(height: 3),
                    Container(
                        child: isGift
                            ? Text("Tặng kèm", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.purple))
                            : null)
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Widget buildGifts(List<Gift> gifts) {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: gifts.length,
      itemBuilder: (context, index) {
        Gift gift = gifts[index];
        return buildOneProduct(gift.imageSource, gift.name, Colors.blue, gift.price, 1, true);
      },
    );
  }

  Widget buildListProduct() {
    return SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: widget.order.items.length,
        itemBuilder: (context, index) {
          Item item = widget.order.items[index];

          return Column(
            children: [
              buildOneProduct(item.imageSource, item.productName, Colors.black, item.price, item.qty, false),
              item.gifts.length > 0 ? buildGifts(item.gifts) : Container()
            ],
          );
        },
      ),
    );
  }

  Widget buildDeliveryInfo() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              "THÔNG TIN GIAO HÀNG",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.order.orderName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 1.6),
              ),
              Text(widget.order.orderAddress, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, height: 1.3)),
              Text(
                  "${widget.order.orderPhone != null ? widget.order.orderPhone : ""}${widget.order.orderPhone2 != null ? -widget.order.orderPhone2 : ""}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, height: 1.6))
            ],
          ))
        ],
      ),
    );
  }

  Widget buildNote(String note) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text("GHI CHÚ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Text(note != "" ? note : "[Không có]", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400))
          ],
        ));
  }

  Widget buildExportInvoice(int isExportInvoice) {
    return isExportInvoice == 1
        ? Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    "YÊU CẦU XUẤT HÓA ĐƠN VAT",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mã số thuế 0109067764",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 1.6),
                    ),
                    Text("Công ty ABC Natural", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, height: 1.3)),
                    Text("Số 12 Đinh Tiên Hoàng, phường Đa Kao, Quận 1, Hồ Chí Minh",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, height: 1.3)),
                    Text("abcnatural@gmail.com", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, height: 1.3))
                  ],
                ))
              ],
            ),
          )
        : Container();
  }

  Widget buildPaymentInfo(int tempPrice, int deliveryCharge, int discount, int total) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              "THÔNG TIN THANH TOÁN",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              Text("Tạm tính", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
              Spacer(),
              ShowMoney(
                price: tempPrice,
                fontSizeLarge: 18,
                fontSizeSmall: 14,
                color: Colors.black,
                fontWeight: FontWeight.normal,
                isLineThrough: false,
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text("Phí vận chuyển", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
              Spacer(),
              ShowMoney(
                price: deliveryCharge,
                fontSizeLarge: 18,
                fontSizeSmall: 14,
                color: Colors.black,
                fontWeight: FontWeight.normal,
                isLineThrough: false,
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text("Giảm giá", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
              Spacer(),
              ShowMoney(
                price: discount,
                fontSizeLarge: 18,
                fontSizeSmall: 14,
                color: Colors.black,
                fontWeight: FontWeight.normal,
                isLineThrough: false,
              )
            ],
          ),
          SizedBox(height: 10),
          Divider(
            height: 1,
            color: Colors.black,
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text("TỔNG", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Spacer(),
              ShowMoney(
                price: total,
                fontSizeLarge: 18,
                fontSizeSmall: 14,
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                isLineThrough: false,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPaymentMethod(int paymentType) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text("PHƯƠNG THỨC THANH TOÁN", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Text(getPaymentType(paymentType), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400))
          ],
        ));
  }

  Widget buildRewardPoints(int rewardPoints) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text("ĐIỂM TÍCH LŨY", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Text("${rewardPoints.toString()} điểm", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.primary))
          ],
        ));
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
