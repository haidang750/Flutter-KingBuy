import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/CategoriesScreens/CategoriesScreens.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/presentation/widgets/MyLoading.dart';
import 'package:projectui/src/resource/model/AddressModel.dart';
import 'package:projectui/src/resource/model/CartModel.dart';
import 'package:projectui/src/resource/model/ListProductsModel.dart';
import 'package:projectui/src/resource/model/Data.dart';
import 'package:projectui/src/utils/app_shared.dart';
import 'package:projectui/src/utils/app_utils.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

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
  final deliveryStatusSubject = BehaviorSubject<List<String>>(); // lưu danh sách thời gian giao hàng của địa chỉ hiện tại
  final deliveryStatusIndex = BehaviorSubject<int>(); // lưu thời gian giao hàng đang được chọn hiện tại trong giỏ hàng
  final noteController = TextEditingController();
  final isExportInvoice = BehaviorSubject<bool>();
  final taxCodeController = TextEditingController();
  final companyNameController = TextEditingController();
  final companyAddressController = TextEditingController();
  final companyEmailController = TextEditingController();
  final useRewardPoints = BehaviorSubject<bool>();
  final totalQuantitySubject = BehaviorSubject<int>();

  @override
  void initState() {
    super.initState();
    CartModel cartModel = CartModel.of(context);
    cartProductSubject.sink.add(cartModel);
    totalQuantitySubject.sink.add(widget.totalQuantity);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
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
          deliveryStatusSubject.sink.add(getListDeliveryStatusName(listAddress[i].deliveryStatus)); // set list thời gian giao hàng
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
    });
    deliveryStatusIndex.sink.add(-1);
    isExportInvoice.sink.add(false);
    useRewardPoints.sink.add(false);
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

  List<String> getListDeliveryStatusName(List<int> deliveryStatusId) {
    List<String> deliveryStatusName = [];
    deliveryStatusId.forEach((status) {
      String name = getDeliveryStatusName(status);
      deliveryStatusName.add(name);
    });
    return deliveryStatusName;
  }

  @override
  void dispose() {
    super.dispose();
    cartProductSubject.close();
    deliveryAddressSubject.close();
    deliveryStatusSubject.close();
    deliveryStatusIndex.close();
    isExportInvoice.close();
    useRewardPoints.close();
    totalQuantitySubject.close();
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
                        return Column(
                          children: [
                            Container(
                              height: 70,
                              child: Row(
                                children: [
                                  MyNetworkImage(url: "${AppEndpoint.BASE_URL}${cartItems[index].product.imageSource}", height: 70, width: 70),
                                  SizedBox(width: 10),
                                  Container(
                                    height: 70,
                                    width: MediaQuery.of(context).size.width - 110,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            cartItems[index].product.name.length < 33
                                                ? cartItems[index].product.name
                                                : "${cartItems[index].product.name.substring(0, 33)} ...",
                                            style: TextStyle(fontWeight: FontWeight.w500)),
                                        Row(
                                          children: [
                                            ShowMoney(
                                                price: cartItems[index].product.salePrice,
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.bold,
                                                isLineThrough: false,
                                                fontSizeLarge: 14,
                                                fontSizeSmall: 11),
                                            Spacer(),
                                            GestureDetector(
                                                child: Text("Xóa", style: TextStyle(fontSize: 13, color: AppColors.blue)),
                                                onTap: () {
                                                  totalQuantitySubject.sink.add(totalQuantitySubject.stream.value - cartItems[index].qty);
                                                  CartModel.of(context).removeProduct(cartItems[index]);
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
                                                  onTap: cartItems[index].qty > 0
                                                      ? () {
                                                          CartModel.of(context).updateCartQuantity(cartItems[index], false);
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
                                                child: Text(cartItems[index].qty.toString(), style: TextStyle(fontSize: 12)),
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
                                                    CartModel.of(context).updateCartQuantity(cartItems[index], true);
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
                  deliveryStatusSubject.sink.add(getListDeliveryStatusName(address.deliveryStatus));
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
                  deliveryStatusSubject.sink.add(getListDeliveryStatusName(address.deliveryStatus));
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
                                Text(snapshot2.data[index])
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
                Text("Chọn mã giảm giá", style: TextStyle(fontSize: 14, color: AppColors.grey)),
                SizedBox(width: 10),
                Icon(Icons.arrow_forward_ios_outlined, size: 14)
              ],
            )
          ],
        ),
      ),
      onTap: () {
        print("navigate sang màn hình chọn coupon");
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
                        if (useRewardPoints.stream.value) print("RewardPoints: $rewardPoints điểm");
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
                Container(
                  height: 32,
                  width: 170,
                  child: Text("Chọn phương thức thanh toán", style: TextStyle(fontSize: 14, color: AppColors.grey), textAlign: TextAlign.right),
                ),
                SizedBox(width: 10),
                Icon(Icons.arrow_forward_ios_outlined, size: 14)
              ],
            )
          ],
        ),
      ),
      onTap: () {
        print("navigate sang màn hình chọn phương thức thanh toán");
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
                  ShowMoney(
                    price: 1990000,
                    isLineThrough: false,
                    fontWeight: FontWeight.normal,
                    fontSizeLarge: 14,
                    fontSizeSmall: 11,
                  )
                ],
              ),
              SizedBox(height: 13),
              Row(
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
              ),
              SizedBox(height: 13),
              Row(
                children: [
                  Text("Giảm giá", style: TextStyle(fontSize: 14)),
                  Spacer(),
                  ShowMoney(
                    price: 0,
                    isLineThrough: false,
                    fontWeight: FontWeight.normal,
                    fontSizeLarge: 14,
                    fontSizeSmall: 11,
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
                  ShowMoney(
                    price: 1990000,
                    isLineThrough: false,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSizeLarge: 14,
                    fontSizeSmall: 11,
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
      child: Container(
        height: 45,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.all(Radius.circular(22.5))),
        child: Container(
            height: 20,
            child: Row(
              children: [
                ShowMoney(
                  price: 1990000,
                  color: AppColors.white,
                  isLineThrough: false,
                  fontWeight: FontWeight.bold,
                  fontSizeLarge: 14,
                  fontSizeSmall: 11,
                ),
                Spacer(),
                Text("Đặt hàng", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.white))
              ],
            )),
      ),
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
