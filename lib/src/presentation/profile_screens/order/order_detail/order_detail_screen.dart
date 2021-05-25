// Ảnh 44 - Chi tiết đơn hàng
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/presentation/widgets/show_money.dart';
import 'package:projectui/src/resource/model/invoice_model.dart';
import 'package:projectui/src/resource/model/list_products_model.dart';
import 'package:projectui/src/resource/model/order_history_model.dart';
import 'package:toast/toast.dart';

class OrderDetail extends StatefulWidget {
  OrderDetail({this.invoice});

  InvoiceData invoice;

  @override
  OrderDetailState createState() => OrderDetailState();
}

class OrderDetailState extends State<OrderDetail> with ResponsiveWidget {
  OrderDetailViewModel orderDetailViewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: OrderDetailViewModel(),
        onViewModelReady: (viewModel) => orderDetailViewModel = viewModel,
        builder: (context, viewModel, child) => Scaffold(appBar: AppBar(titleSpacing: 0, title: Text("Đơn hàng")), body: buildUi(context: context)));
  }

  Widget buildScreen() {
    return Container(
      child: ListView(
        children: [
          buildOrderSuccess(),
          buildSeparateLine1(),
          buildOrderStatus(),
          buildSeparateLine1(),
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
                          "DANH SÁCH SẢN PHẨM (${widget.invoice.items.length})",
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                      buildListProduct(),
                    ],
                  )),
            ],
          ),
          buildSeparateLine1(),
          buildDeliveryInfo(),
          buildSeparateLine1(),
          buildNote(widget.invoice.note),
          widget.invoice.isExportInvoice == 1 ? buildSeparateLine2(context) : Container(),
          buildExportInvoice(widget.invoice.isExportInvoice),
          buildSeparateLine2(context),
          buildPaymentInfo(widget.invoice.total - widget.invoice.deliveryCharge + widget.invoice.discount, widget.invoice.deliveryCharge,
              widget.invoice.discount, widget.invoice.total),
          buildSeparateLine2(context),
          buildPaymentMethod(widget.invoice.paymentType),
          buildSeparateLine2(context),
          buildRewardPoints()
        ],
      ),
    );
  }

  Widget buildSeparateLine1() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 0.5,
        color: Colors.grey,
      ),
    );
  }

  Widget buildSeparateLine2(BuildContext context) {
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
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text(widget.invoice.createdAt, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
          Row(
            children: [
              Text("Mã đơn hàng: ", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
              Text(widget.invoice.invoiceCode, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              Spacer(),
              GestureDetector(
                child: Icon(
                  Icons.copy,
                  color: Colors.red,
                ),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: widget.invoice.invoiceCode));
                  Toast.show("Copied to Clipboard", context, gravity: Toast.CENTER);
                },
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
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text(orderDetailViewModel.getStatus(widget.invoice.status), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
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
                    Text(name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: color)),
                    SizedBox(height: 3),
                    Row(
                      children: [
                        ShowMoney(
                          price: price,
                          fontSizeLarge: 15,
                          fontSizeSmall: 12,
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.bold,
                          isLineThrough: false,
                        ),
                        Spacer(),
                        Text("x${quantity.toString()}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400))
                      ],
                    ),
                    SizedBox(height: 3),
                    Container(
                        child: isGift ? Text("Tặng kèm", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.purple)) : null)
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
        itemCount: widget.invoice.items.length,
        itemBuilder: (context, index) {
          Item item = widget.invoice.items[index];

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
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.invoice.orderName,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, height: 1.6),
              ),
              Text(widget.invoice.orderAddress, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, height: 1.3)),
              Text(
                  "${widget.invoice.orderPhone != null ? widget.invoice.orderPhone : ""}${widget.invoice.orderPhone2 != null ? "-${widget.invoice.orderPhone2}" : ""}",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, height: 1.6))
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
              child: Text("GHI CHÚ", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            ),
            Text(note != "" ? note : "[Không có]", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400))
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
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mã số thuế ${widget.invoice.taxCode}",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, height: 1.6),
                    ),
                    Text(widget.invoice.companyName, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, height: 1.3)),
                    Text(widget.invoice.companyAddress, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, height: 1.3)),
                    Text(widget.invoice.companyEmail, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, height: 1.3))
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
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              Text("Tạm tính", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
              Spacer(),
              ShowMoney(
                price: tempPrice,
                fontSizeLarge: 15,
                fontSizeSmall: 12,
                color: Colors.black,
                fontWeight: FontWeight.normal,
                isLineThrough: false,
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text("Phí vận chuyển", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
              Spacer(),
              ShowMoney(
                price: deliveryCharge,
                fontSizeLarge: 15,
                fontSizeSmall: 12,
                color: Colors.black,
                fontWeight: FontWeight.normal,
                isLineThrough: false,
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text("Giảm giá", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
              Spacer(),
              ShowMoney(
                price: discount,
                fontSizeLarge: 15,
                fontSizeSmall: 12,
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
              Text("TỔNG", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              Spacer(),
              ShowMoney(
                price: total,
                fontSizeLarge: 15,
                fontSizeSmall: 12,
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
              child: Text("PHƯƠNG THỨC THANH TOÁN", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            ),
            Text(orderDetailViewModel.getPaymentType(paymentType), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400))
          ],
        ));
  }

  Widget buildRewardPoints() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text("ĐIỂM TÍCH LŨY", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            ),
            Text("${widget.invoice.rewardPoints.toString()} điểm",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.primary))
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
