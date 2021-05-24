import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/CategoriesScreens/CategoriesScreens.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/presentation/widgets/MyLoading.dart';
import 'package:projectui/src/resource/model/AddressModel.dart';
import 'package:projectui/src/resource/model/CartModel.dart';
import 'package:projectui/src/resource/model/InvoiceModel.dart';
import 'package:projectui/src/resource/model/ListProductsModel.dart';
import 'package:projectui/src/resource/model/Data.dart';
import 'package:projectui/src/utils/app_shared.dart';
import 'package:projectui/src/utils/app_utils.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:toast/toast.dart';

class CartScreen extends StatefulWidget {
  CartScreen({this.totalQuantity});

  int totalQuantity;

  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen> with ResponsiveWidget {
  final cartViewModel = CartViewModel();
  final cartProductSubject = BehaviorSubject<CartModel>();
  final deliveryAddressSubject = BehaviorSubject<Address>();
  final listAddressViewModel = ListAddressViewModel();
  final deliveryStatusSubject = BehaviorSubject<List<int>>(); // lưu danh sách thời gian giao hàng của địa chỉ hiện tại
  final deliveryStatusIndex = BehaviorSubject<int>(); // lưu thời gian giao hàng đang được chọn hiện tại trong giỏ hàng
  final noteController = TextEditingController();
  final isExportInvoice = BehaviorSubject<bool>();
  final taxCodeController = TextEditingController();
  final companyNameController = TextEditingController();
  final companyAddressController = TextEditingController();
  final companyEmailController = TextEditingController();
  final nameSelectedCouponSubject = BehaviorSubject<String>();
  final idSelectedCouponSubject = BehaviorSubject<int>();
  final selectedPaymentTypeSubject = BehaviorSubject<String>();
  final idPaymentTypeSubject = BehaviorSubject<int>();
  final useRewardPoints = BehaviorSubject<bool>();
  final totalQuantitySubject = BehaviorSubject<int>(); // Tổng số sản phẩm trong Cart
  final tempPriceSubject = BehaviorSubject<int>(); // Tạm tính
  final isBulkySubject = BehaviorSubject<bool>(); // kiểm tra xem trong tất cả các sản phẩm trong Cart, có sản phẩm nào có isBulky = 1 hay không
  final discountPriceSubject = BehaviorSubject<int>();
  final totalPriceSubject = BehaviorSubject<int>();

  @override
  void initState() {
    super.initState();
    CartModel cartModel = CartModel.of(context);
    cartProductSubject.sink.add(cartModel);
    tempPriceSubject.sink.add(0);
    isBulkySubject.sink.add(false);
    cartModel.products.forEach((cartItem) {
      tempPriceSubject.sink.add(tempPriceSubject.stream.value + cartItem.qty * cartItem.product.salePrice); // Tạm tính giá tiền
      if (cartItem.product.isBulky == 1) {
        isBulkySubject.sink.add(true);
      }
    });
    totalQuantitySubject.sink.add(widget.totalQuantity);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getDeliveryAddress();
    });
    deliveryStatusIndex.sink.add(-1);
    isExportInvoice.sink.add(false);
    nameSelectedCouponSubject.sink.add("");
    idSelectedCouponSubject.sink.add(-1);
    selectedPaymentTypeSubject.sink.add("");
    idPaymentTypeSubject.sink.add(-1);
    useRewardPoints.sink.add(false);
    discountPriceSubject.sink.add(0);
    totalPriceSubject.sink.add(0);
  }

  Future<Address> getDeliveryAddress() async {
    int addressIdDB = CartModel.of(context).deliveryAddressId; // lấy id địa chỉ giao hàng đã chọn về từ Database
    // lấy danh sách địa chỉ giao hàng đã lưu ở Local (dù Login hay không Login thì danh sách này đều được lưu ở Local)
    List<String> listAddressLocal = await AppShared.getAddressModel();
    List<Address> listAddress = [];
    listAddressLocal.forEach((addressLocal) {
      Map<String, dynamic> address = jsonDecode(addressLocal);
      listAddress.add(Address.fromJson(address));
    });
    int flag = 0;
    // kiểm tra trong danh sách nếu địa chỉ nào có Id trùng với Id đã lấy về từ Database thì lấy địa chỉ đó ra hiển thị
    for (int i = 0; i < listAddress.length; i++) {
      if (listAddress[i].id == addressIdDB) {
        deliveryAddressSubject.sink.add(listAddress[i]); // set địa chỉ giao hàng
        deliveryStatusSubject.sink.add(listAddress[i].deliveryStatus); // set list thời gian giao hàng
        // set thông tin hóa đơn VAT
        taxCodeController.text = listAddress[i].taxCode;
        companyNameController.text = listAddress[i].companyName;
        companyAddressController.text = listAddress[i].companyAddress;
        companyEmailController.text = listAddress[i].companyEmail;
        flag = 1;
      }
    }
    // nếu ra ngoài vòng for mà flag vẫn = 0 tức là trong danh sách địa chỉ đã lưu ở Local không có địa chỉ nào trùng với địa chỉ trên DB
    if (flag == 0) {
      deliveryAddressSubject.sink.add(null);
      deliveryStatusSubject.sink.add([]);
      taxCodeController.text = "";
      companyNameController.text = "";
      companyAddressController.text = "";
      companyEmailController.text = "";
    }
    return deliveryAddressSubject.stream.value;
  }

  String getDeliveryStatusName(int deliveryStatusId) {
    String name = "";
    switch (deliveryStatusId) {
      case 1:
        name = "Giao hàng trong 3h";
        break;
      case 2:
        name = "Giao hàng trong 24h";
        break;
      case 3:
        name = "Giao hàng 2-3 ngày";
        break;
      case 4:
        name = "Giao hàng 3-5 ngày";
        break;
      case 5:
        name = "Nhân viên gọi xác nhận";
        break;
    }
    return name;
  }

  @override
  void dispose() {
    super.dispose();
    cartProductSubject.close();
    deliveryAddressSubject.close();
    deliveryStatusSubject.close();
    deliveryStatusIndex.close();
    isExportInvoice.close();
    nameSelectedCouponSubject.close();
    idSelectedCouponSubject.close();
    selectedPaymentTypeSubject.close();
    idPaymentTypeSubject.close();
    useRewardPoints.close();
    totalQuantitySubject.close();
    tempPriceSubject.close();
    isBulkySubject.close();
    discountPriceSubject.close();
    totalPriceSubject.close();
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: cartViewModel,
        builder: (context, viewModel, child) => Scaffold(
            appBar: AppBar(
                title: Text("Giỏ hàng"),
                titleSpacing: 0,
                leading: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context, totalQuantitySubject.stream.value);
                      },
                    );
                  },
                )),
            body: buildUi(context: context)));
  }

  Widget buildScreen() {
    int rewardPoints = Provider.of<Data>(context, listen: false).rewardPoints;

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Column(
          children: [
            Container(
              color: AppColors.white,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [buildListProduct(), buildDeliveryInfo(), buildDeliveryTime(), buildNote()],
              ),
            ),
            Container(height: 5, color: AppColors.grey2),
            buildExportVAT(),
            Container(height: 5, color: AppColors.grey2),
            Container(
              height: rewardPoints != null ? 161 : 131,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  buildSelectCoupon(),
                  Container(
                    height: 0.5,
                    color: AppColors.grey3,
                  ),
                  rewardPoints != null ? buildUseRewardPoints() : Container(),
                  Container(
                    height: 0.5,
                    color: AppColors.grey3,
                  ),
                  buildSelectPaymentType()
                ],
              ),
            ),
            Container(height: 5, color: AppColors.grey2),
            buildCartPrice(),
            Container(height: 10, color: AppColors.grey2),
            buildButton()
          ],
        ),
      ),
    );
  }

  Widget buildListProduct() {
    return StreamBuilder(
      stream: cartProductSubject.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          CartModel cartModel = snapshot.data;
          List<CartItem> cartItems = cartModel.products;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 50,
                  alignment: Alignment.centerLeft,
                  child:
                      Text("DANH SÁCH SẢN PHẨM (${totalQuantitySubject.stream.value})", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
              cartItems.length > 0
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        CartItem cartItem = cartItems[index];

                        return Column(
                          children: [
                            Container(
                              height: 70,
                              child: Row(
                                children: [
                                  MyNetworkImage(url: "${AppEndpoint.BASE_URL}${cartItem.product.imageSource}", height: 70, width: 70),
                                  SizedBox(width: 10),
                                  Container(
                                    height: 70,
                                    width: MediaQuery.of(context).size.width - 110,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            cartItem.product.name.length < 33
                                                ? cartItem.product.name
                                                : "${cartItem.product.name.substring(0, 33)} ...",
                                            style: TextStyle(fontWeight: FontWeight.w500)),
                                        Row(
                                          children: [
                                            ShowMoney(
                                                price: cartItem.product.salePrice,
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.bold,
                                                isLineThrough: false,
                                                fontSizeLarge: 14,
                                                fontSizeSmall: 11),
                                            Spacer(),
                                            GestureDetector(
                                                child: Text("Xóa", style: TextStyle(fontSize: 13, color: AppColors.blue)),
                                                onTap: () {
                                                  tempPriceSubject.sink
                                                      .add(tempPriceSubject.stream.value - cartItem.qty * cartItem.product.salePrice);
                                                  totalQuantitySubject.sink.add(totalQuantitySubject.stream.value - cartItem.qty);
                                                  CartModel.of(context).removeProduct(cartItem);
                                                  cartProductSubject.sink.add(cartModel);
                                                })
                                          ],
                                        ),
                                        Container(
                                          height: 20,
                                          child: Row(
                                            children: [
                                              GestureDetector(
                                                  child: Container(
                                                    height: 20,
                                                    width: 20,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            left: BorderSide(width: 1, color: AppColors.grey2),
                                                            top: BorderSide(width: 1, color: AppColors.grey2),
                                                            right: BorderSide(width: 0.5, color: AppColors.grey2),
                                                            bottom: BorderSide(width: 1, color: AppColors.grey2))),
                                                    child: Text("-", style: TextStyle(fontSize: 12)),
                                                  ),
                                                  onTap: cartItem.qty > 0
                                                      ? () {
                                                          tempPriceSubject.sink.add(tempPriceSubject.stream.value - cartItem.product.salePrice);
                                                          CartModel.of(context).updateCartQuantity(cartItem, false);
                                                          cartProductSubject.sink.add(cartModel);
                                                          totalQuantitySubject.sink.add(totalQuantitySubject.stream.value - 1);
                                                        }
                                                      : null),
                                              Container(
                                                height: 20,
                                                width: 40,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        left: BorderSide(width: 0.5, color: AppColors.grey2),
                                                        top: BorderSide(width: 1, color: AppColors.grey2),
                                                        right: BorderSide(width: 0.5, color: AppColors.grey2),
                                                        bottom: BorderSide(width: 1, color: AppColors.grey2))),
                                                child: Text(cartItem.qty.toString(), style: TextStyle(fontSize: 12)),
                                              ),
                                              GestureDetector(
                                                  child: Container(
                                                    height: 20,
                                                    width: 20,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            left: BorderSide(width: 0.5, color: AppColors.grey2),
                                                            top: BorderSide(width: 1, color: AppColors.grey2),
                                                            right: BorderSide(width: 1, color: AppColors.grey2),
                                                            bottom: BorderSide(width: 1, color: AppColors.grey2))),
                                                    child: Text("+", style: TextStyle(fontSize: 12)),
                                                  ),
                                                  onTap: () {
                                                    tempPriceSubject.sink.add(tempPriceSubject.stream.value + cartItem.product.salePrice);
                                                    CartModel.of(context).updateCartQuantity(cartItem, true);
                                                    cartProductSubject.sink.add(cartModel);
                                                    totalQuantitySubject.sink.add(totalQuantitySubject.stream.value + 1);
                                                  }),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 15)
                          ],
                        );
                      },
                    )
                  : Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width - 30,
                      alignment: Alignment.topLeft,
                      child: Text("Giỏ hàng đang trống, thêm sản phẩm vào giỏ để bắt đầu mua sắm!",
                          style: TextStyle(fontSize: 14, color: Colors.red, fontWeight: FontWeight.w400))),
              cartItems.length > 0
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        List<Gift> gifts = cartItems[index].product.gifts;
                        int giftQuantity = cartItems[index].qty;

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: gifts.length,
                          itemBuilder: (context, index) => Column(
                            children: [
                              Container(
                                height: 70,
                                child: Row(
                                  children: [
                                    MyNetworkImage(url: "${AppEndpoint.BASE_URL}${gifts[index].imageSource}", height: 70, width: 70),
                                    SizedBox(width: 10),
                                    Container(
                                      height: 70,
                                      width: MediaQuery.of(context).size.width - 110,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(gifts[index].name.length < 33 ? gifts[index].name : "${gifts[index].name.substring(0, 33)} ...",
                                              style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.blue)),
                                          Row(
                                            children: [
                                              ShowMoney(
                                                  price: gifts[index].price,
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.bold,
                                                  isLineThrough: false,
                                                  fontSizeLarge: 14,
                                                  fontSizeSmall: 11),
                                              Spacer(),
                                              Text("x$giftQuantity", style: TextStyle(fontSize: 13))
                                            ],
                                          ),
                                          Text("Tặng kèm", style: TextStyle(color: AppColors.purple))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 15)
                            ],
                          ),
                        );
                      },
                    )
                  : Container(),
              SizedBox(height: 15),
              Container(
                height: 0.5,
                color: AppColors.grey3,
              )
            ],
          );
        } else {
          return MyLoading();
        }
      },
    );
  }

  Widget buildDeliveryInfo() {
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      child: Column(
        children: [
          Container(
              height: 32.5,
              alignment: Alignment.bottomLeft,
              child: Text("THÔNG TIN GIAO HÀNG", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
          SizedBox(height: 10),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: StreamBuilder(
              stream: deliveryAddressSubject.stream,
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  Address address = snapshot.data;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(address.fullName, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      SizedBox(height: 3),
                      Text(address.fullAddress, style: TextStyle(fontSize: 14)),
                      SizedBox(height: 3),
                      Text("${address.firstPhone}${address.secondPhone != null ? " - ${address.secondPhone}" : ""}", style: TextStyle(fontSize: 14))
                    ],
                  );
                } else {
                  return Container(
                    height: 20,
                    width: MediaQuery.of(context).size.width - 30,
                    alignment: Alignment.topLeft,
                    child: Text("Chọn địa chỉ giao hàng của bạn", style: TextStyle(fontSize: 14)),
                  );
                }
              },
            ),
            onTap: () async {
              if (await AppUtils.checkLogin()) {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListAddress(
                            enableSelect: true,
                            isCallFromCart: true,
                            selectedAddressId: -1,
                            cartAddress: deliveryAddressSubject.stream.value))).then((address) {
                  deliveryAddressSubject.sink.add(address);
                  deliveryStatusSubject.sink.add(address.deliveryStatus);
                  taxCodeController.text = address.taxCode;
                  companyNameController.text = address.companyName;
                  companyAddressController.text = address.companyAddress;
                  companyEmailController.text = address.companyEmail;
                });
              } else {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListAddress(
                            enableSelect: false,
                            isCallFromCart: true,
                            selectedAddressId: -1,
                            cartAddress: deliveryAddressSubject.stream.value))).then((address) {
                  deliveryAddressSubject.sink.add(address);
                  deliveryStatusSubject.sink.add(address.deliveryStatus);
                  taxCodeController.text = address.taxCode;
                  companyNameController.text = address.companyName;
                  companyAddressController.text = address.companyAddress;
                  companyEmailController.text = address.companyEmail;
                });
              }
            },
          ),
          SizedBox(height: 15),
          Container(
            height: 0.5,
            color: AppColors.grey3,
          )
        ],
      ),
    );
  }

  Widget buildDeliveryTime() {
    return Column(
      children: [
        Container(
            height: 50,
            alignment: Alignment.centerLeft,
            child: Text("THỜI GIAN GIAO HÀNG", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        StreamBuilder(
          stream: deliveryStatusIndex.stream,
          builder: (context, snapshot1) {
            if (snapshot1.hasData) {
              return StreamBuilder(
                stream: deliveryStatusSubject.stream,
                builder: (context, snapshot2) {
                  if (snapshot2.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot2.data.length,
                      itemBuilder: (context, index) => Column(
                        children: [
                          GestureDetector(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(snapshot1.data == index ? AppImages.icEnableRadio : AppImages.icDisableRadio, height: 20, width: 20),
                                SizedBox(width: 5),
                                Text(getDeliveryStatusName(snapshot2.data[index]))
                              ],
                            ),
                            onTap: () {
                              deliveryStatusIndex.sink.add(index);
                            },
                          ),
                          SizedBox(height: 10)
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              );
            } else {
              return Container();
            }
          },
        ),
        SizedBox(height: 5),
        Container(
          height: 0.5,
          color: AppColors.grey3,
        )
      ],
    );
  }

  Widget buildNote() {
    return Column(
      children: [
        Container(height: 50, alignment: Alignment.centerLeft, child: Text("GHI CHÚ", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
        BorderTextField(
          textController: noteController,
          height: 50,
          color: AppColors.white,
          textPaddingRight: 5,
          textPaddingLeft: 0,
          fontSize: 14,
          transformText: -12,
          borderColor: AppColors.white,
          borderWidth: 0,
          borderRadius: 0,
          hintText: "Bạn có muốn dặn dò gì không?",
          hintTextFontSize: 14,
          hintTextFontWeight: FontWeight.normal,
        ),
        SizedBox(height: 10)
      ],
    );
  }

  Widget buildExportVAT() {
    return StreamBuilder(
        stream: isExportInvoice.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: snapshot.data,
                      activeColor: AppColors.primary,
                      onChanged: (value) {
                        isExportInvoice.sink.add(!isExportInvoice.stream.value);
                        CartModel.of(context).setExportInvoice(isExportInvoice.stream.value ? 1 : 0);
                      },
                    ),
                    GestureDetector(
                      child: Text(
                        "YÊU CẦU XUẤT HÓA ĐƠN VAT",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        setState(() {
                          isExportInvoice.sink.add(!isExportInvoice.stream.value);
                          CartModel.of(context).setExportInvoice(isExportInvoice.stream.value ? 1 : 0);
                        });
                      },
                    )
                  ],
                )),
                snapshot.data
                    ? Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            BorderTextField(
                              height: 50,
                              borderColor: AppColors.grey3,
                              borderRadius: 6,
                              borderWidth: 0.8,
                              textController: taxCodeController,
                              fontSize: 14,
                              hintText: "Mã số thuế",
                              hintTextFontSize: 14,
                              hintTextFontWeight: FontWeight.w400,
                            ),
                            SizedBox(height: 10),
                            BorderTextField(
                              height: 50,
                              borderColor: AppColors.grey3,
                              borderRadius: 6,
                              borderWidth: 0.8,
                              textController: companyNameController,
                              fontSize: 14,
                              hintText: "Tên công ty",
                              hintTextFontSize: 14,
                              hintTextFontWeight: FontWeight.w400,
                            ),
                            SizedBox(height: 10),
                            BorderTextField(
                              height: 50,
                              borderColor: AppColors.grey3,
                              borderRadius: 6,
                              borderWidth: 0.8,
                              textController: companyAddressController,
                              fontSize: 14,
                              hintText: "Địa chỉ công ty",
                              hintTextFontSize: 14,
                              hintTextFontWeight: FontWeight.w400,
                            ),
                            SizedBox(height: 10),
                            BorderTextField(
                              height: 50,
                              borderColor: AppColors.grey3,
                              borderRadius: 6,
                              borderWidth: 0.8,
                              textController: companyEmailController,
                              fontSize: 14,
                              hintText: "Email",
                              hintTextFontSize: 14,
                              hintTextFontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      )
                    : Container(),
                snapshot.data ? SizedBox(height: 20) : Container()
              ],
            );
          } else {
            return Container();
          }
        });
  }

  Widget buildSelectCoupon() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 55,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AppImages.icCoupon, height: 19, width: 20),
            SizedBox(width: 7),
            Text("Mã giảm giá"),
            Spacer(),
            Row(
              children: [
                StreamBuilder(
                  stream: nameSelectedCouponSubject.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      String couponName = snapshot.data;

                      return Text(couponName == "" ? "Chọn mã giảm giá" : couponName,
                          style: TextStyle(fontSize: 14, color: couponName == "" ? AppColors.grey : AppColors.black));
                    } else {
                      return Container();
                    }
                  },
                ),
                SizedBox(width: 10),
                Icon(Icons.arrow_forward_ios_outlined, size: 14)
              ],
            )
          ],
        ),
      ),
      onTap: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (context) => SelectCouponScreen())).then((coupon) async {
          if (coupon != null) {
            nameSelectedCouponSubject.sink.add(coupon.name);
            idSelectedCouponSubject.sink.add(coupon.id);
            int couponId = coupon.id;
            int total = tempPriceSubject.stream.value;
            int feeShip = isBulkySubject.stream.value
                ? (deliveryAddressSubject.stream.value != null ? deliveryAddressSubject.stream.value.shipFeeBulky : 0)
                : (deliveryAddressSubject.stream.value != null ? deliveryAddressSubject.stream.value.shipFeeNotBulky : 0);
            discountPriceSubject.sink.add(await cartViewModel.getDiscountPrice(couponId, total, feeShip, deliveryAddressSubject.stream.value));
          }
        });
      },
    );
  }

  Widget buildUseRewardPoints() {
    int rewardPoints = Provider.of<Data>(context, listen: false).rewardPoints == null ? 0 : Provider.of<Data>(context, listen: false).rewardPoints;

    return Container(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(AppImages.icCoin, height: 18, width: 17),
          SizedBox(width: 8),
          Text("Dùng tích điểm"),
          Spacer(),
          Row(
            children: [
              Text("($rewardPoints điểm)", style: TextStyle(fontSize: 14, color: Colors.red)),
              SizedBox(width: 10),
              StreamBuilder(
                stream: useRewardPoints.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GestureDetector(
                      child: Container(
                        height: 16,
                        width: 28,
                        padding: EdgeInsets.fromLTRB(2, 1, 2, 1),
                        alignment: snapshot.data ? Alignment.centerRight : Alignment.centerLeft,
                        decoration: BoxDecoration(
                            color: snapshot.data ? AppColors.blue2 : AppColors.grey, borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: Container(
                          height: 12,
                          width: 12,
                          decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.all(Radius.circular(6))),
                        ),
                      ),
                      onTap: () {
                        useRewardPoints.sink.add(!useRewardPoints.stream.value);
                        if (useRewardPoints.stream.value) {
                          print("RewardPoints: $rewardPoints điểm");
                          CartModel.of(context).setSavePoint(rewardPoints);
                        } else {
                          CartModel.of(context).setSavePoint(0);
                        }
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildSelectPaymentType() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AppImages.icWallet, height: 20, width: 20),
            SizedBox(width: 5),
            Container(height: 32, width: 100, child: Text("Phương thức thanh toán")),
            Spacer(),
            Row(
              children: [
                StreamBuilder(
                    stream: selectedPaymentTypeSubject.stream,
                    builder: (context, snapshot) {
                      String paymentTypeName = snapshot.data;

                      if (snapshot.hasData) {
                        return Container(
                          height: 32,
                          width: 160,
                          alignment: Alignment.center,
                          child: Text(paymentTypeName == "" ? "Chọn phương thức thanh toán" : paymentTypeName,
                              style: TextStyle(fontSize: 14, color: paymentTypeName == "" ? AppColors.grey : AppColors.black),
                              textAlign: TextAlign.right),
                        );
                      } else {
                        return Container();
                      }
                    }),
                SizedBox(width: 10),
                Icon(Icons.arrow_forward_ios_outlined, size: 14)
              ],
            )
          ],
        ),
      ),
      onTap: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentTypeScreen())).then((paymentType) {
          switch (paymentType) {
            case 1:
              selectedPaymentTypeSubject.sink.add("Thanh toán bằng tiền mặt khi nhận hàng");
              idPaymentTypeSubject.sink.add(1);
              break;
            case 2:
              selectedPaymentTypeSubject.sink.add("Chuyển khoản ngân hàng");
              idPaymentTypeSubject.sink.add(2);
              break;
            case 3:
              selectedPaymentTypeSubject.sink.add("Thanh toán bằng thẻ Visa / MasterCard");
              idPaymentTypeSubject.sink.add(3);
              break;
            default:
              selectedPaymentTypeSubject.sink.add("");
              break;
          }
        });
      },
    );
  }

  Widget buildCartPrice() {
    return Container(
        height: 135,
        color: AppColors.white,
        padding: EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.bottomLeft,
        child: Container(
          height: 121,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Tạm tính", style: TextStyle(fontSize: 14)),
                  Spacer(),
                  StreamBuilder(
                      stream: tempPriceSubject.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ShowMoney(
                            price: snapshot.data,
                            isLineThrough: false,
                            fontWeight: FontWeight.normal,
                            fontSizeLarge: 14,
                            fontSizeSmall: 11,
                          );
                        } else {
                          return ShowMoney(
                            price: 0,
                            isLineThrough: false,
                            fontWeight: FontWeight.normal,
                            fontSizeLarge: 14,
                            fontSizeSmall: 11,
                          );
                        }
                      })
                ],
              ),
              SizedBox(height: 13),
              StreamBuilder(
                stream: deliveryAddressSubject.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Row(
                      children: [
                        Text("Phí vận chuyển", style: TextStyle(fontSize: 14)),
                        Spacer(),
                        ShowMoney(
                          price: isBulkySubject.stream.value ? snapshot.data.shipFeeBulky : snapshot.data.shipFeeNotBulky,
                          isLineThrough: false,
                          fontWeight: FontWeight.normal,
                          fontSizeLarge: 14,
                          fontSizeSmall: 11,
                        )
                      ],
                    );
                  } else {
                    return Row(
                      children: [
                        Text("Phí vận chuyển", style: TextStyle(fontSize: 14)),
                        Spacer(),
                        ShowMoney(
                          price: 0,
                          isLineThrough: false,
                          fontWeight: FontWeight.normal,
                          fontSizeLarge: 14,
                          fontSizeSmall: 11,
                        )
                      ],
                    );
                  }
                },
              ),
              SizedBox(height: 13),
              Row(
                children: [
                  Text("Giảm giá", style: TextStyle(fontSize: 14)),
                  Spacer(),
                  StreamBuilder(
                    stream: discountPriceSubject.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ShowMoney(
                          price: snapshot.data,
                          isLineThrough: false,
                          fontWeight: FontWeight.normal,
                          fontSizeLarge: 14,
                          fontSizeSmall: 11,
                        );
                      } else {
                        return Container();
                      }
                    },
                  )
                ],
              ),
              SizedBox(height: 10),
              Container(height: 0.5, color: AppColors.grey3),
              SizedBox(height: 10),
              Row(
                children: [
                  Text("TỔNG", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  Spacer(),
                  StreamBuilder(
                    stream: Rx.combineLatest3(
                        tempPriceSubject.stream, deliveryAddressSubject.stream, discountPriceSubject.stream, (stream1, stream2, stream3) => stream1),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        int tempPrice = snapshot.data;
                        int feeShip = deliveryAddressSubject.stream.value == null
                            ? 0
                            : (isBulkySubject.stream.value
                                ? deliveryAddressSubject.stream.value.shipFeeBulky
                                : deliveryAddressSubject.stream.value.shipFeeNotBulky);
                        int discountPrice = discountPriceSubject.stream.value;
                        totalPriceSubject.sink.add(tempPrice + feeShip - discountPrice);

                        return ShowMoney(
                          price: tempPrice + feeShip - discountPrice,
                          isLineThrough: false,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSizeLarge: 14,
                          fontSizeSmall: 11,
                        );
                      } else {
                        return ShowMoney(
                          price: 0,
                          isLineThrough: false,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSizeLarge: 14,
                          fontSizeSmall: 11,
                        );
                      }
                    },
                  )
                ],
              ),
            ],
          ),
        ));
  }

  Widget buildButton() {
    return Container(
      height: 55,
      padding: EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.topCenter,
      color: AppColors.grey2,
      child: GestureDetector(
          child: Container(
            height: 45,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.all(Radius.circular(22.5))),
            child: Container(
                height: 20,
                child: Row(
                  children: [
                    StreamBuilder(
                      stream: totalPriceSubject.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ShowMoney(
                            price: snapshot.data,
                            color: AppColors.white,
                            isLineThrough: false,
                            fontWeight: FontWeight.bold,
                            fontSizeLarge: 14,
                            fontSizeSmall: 11,
                          );
                        } else {
                          return ShowMoney(
                            price: 0,
                            color: AppColors.white,
                            isLineThrough: false,
                            fontWeight: FontWeight.bold,
                            fontSizeLarge: 14,
                            fontSizeSmall: 11,
                          );
                        }
                      },
                    ),
                    Spacer(),
                    Text("Đặt hàng", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.white))
                  ],
                )),
          ),
          onTap: () async {
            if (CartModel.of(context).products.isEmpty) {
              Toast.show("Vui lòng thêm sản phẩm vào giỏ hàng trước khi đặt hàng", context, gravity: Toast.CENTER);
            } else if (deliveryAddressSubject.stream.value == null) {
              Toast.show("Vui lòng chọn địa chỉ giao hàng", context, gravity: Toast.CENTER);
            } else if (deliveryStatusIndex.stream.value == -1) {
              Toast.show("Vui lòng chọn thời gian giao hàng", context, gravity: Toast.CENTER);
            } else if (idPaymentTypeSubject.stream.value == -1) {
              Toast.show("Vui lòng chọn phương thức thanh toán", context, gravity: Toast.CENTER);
            } else if (isExportInvoice.stream.value &&
                (taxCodeController.text == "" ||
                    companyNameController.text == "" ||
                    companyAddressController.text == "" ||
                    companyEmailController.text == "")) {
              Toast.show("Vui lòng nhập đầy đủ thông tin hóa đơn VAT", context, gravity: Toast.CENTER);
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      insetPadding: EdgeInsets.symmetric(horizontal: 50),
                      child: Container(
                        height: 110,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Bạn xác nhận đặt hàng nhé?",
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
                                      decoration: BoxDecoration(color: AppColors.disableButton, borderRadius: BorderRadius.all(Radius.circular(15))),
                                      child: Text(
                                        "Chờ đã",
                                        style: TextStyle(color: AppColors.buttonContent, fontWeight: FontWeight.w500),
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
                                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.all(Radius.circular(15))),
                                    child: Text("Đồng ý", style: TextStyle(color: AppColors.buttonContent, fontWeight: FontWeight.w500)),
                                  ),
                                  onTap: () async {
                                    InvoiceData invoiceData;
                                    if (await AppUtils.checkLogin()) {
                                      // Tạo đơn hàng khi đã đăng nhập
                                      invoiceData = await cartViewModel.createInvoiceToken(
                                          deliveryAddressSubject.stream.value.id,
                                          idPaymentTypeSubject.stream.value,
                                          deliveryStatusSubject.stream.value[deliveryStatusIndex.stream.value],
                                          noteController.text,
                                          isExportInvoice.stream.value ? 1 : 0,
                                          useRewardPoints.stream.value ? 1 : 0,
                                          CartModel.of(context).products);
                                    } else {
                                      // Tạo đơn hàng khi chưa đăng nhập
                                      invoiceData = await cartViewModel.createInvoiceNotToken(
                                          idPaymentTypeSubject.stream.value,
                                          deliveryStatusSubject.stream.value[deliveryStatusIndex.stream.value],
                                          noteController.text,
                                          deliveryAddressSubject.stream.value.firstPhone,
                                          deliveryAddressSubject.stream.value.secondPhone,
                                          deliveryAddressSubject.stream.value.fullName,
                                          deliveryAddressSubject.stream.value.provinceCode,
                                          deliveryAddressSubject.stream.value.districtCode,
                                          deliveryAddressSubject.stream.value.wardCode,
                                          deliveryAddressSubject.stream.value.address,
                                          isExportInvoice.stream.value ? 1 : 0,
                                          isExportInvoice.stream.value ? taxCodeController.text : null,
                                          isExportInvoice.stream.value ? companyNameController.text : null,
                                          isExportInvoice.stream.value ? companyAddressController.text : null,
                                          isExportInvoice.stream.value ? companyEmailController.text : null,
                                          CartModel.of(context).products);
                                    }
                                    if (invoiceData != null) {
                                      if (idPaymentTypeSubject.stream.value == 3) {
                                        if (await AppUtils.checkLogin()) {
                                          Toast.show("Thành công", context, gravity: Toast.CENTER);
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => OrderPayment(invoiceData: invoiceData)));
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  insetPadding: EdgeInsets.symmetric(horizontal: 50),
                                                  child: Container(
                                                    height: 110,
                                                    decoration:
                                                        BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
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
                                                                    style: TextStyle(color: AppColors.buttonContent, fontWeight: FontWeight.w500),
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  Navigator.pop(context);
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
                                                                    color: AppColors.primary, borderRadius: BorderRadius.all(Radius.circular(15))),
                                                                child: Text("Đăng nhập",
                                                                    style: TextStyle(color: AppColors.buttonContent, fontWeight: FontWeight.w500)),
                                                              ),
                                                              onTap: () {
                                                                Navigator.pushNamed(context, Routers.Login);
                                                              },
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        }
                                      } else {
                                        Toast.show("Thành công", context, gravity: Toast.CENTER);
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => OrderSuccess(invoiceData: invoiceData)));
                                      }
                                    } else {
                                      Toast.show("Tạo đơn hàng không thành công", context, gravity: Toast.CENTER);
                                    }
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  });
            }
          }),
    );
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
