import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/categories_screens/categories_screens.dart';
import 'package:projectui/src/presentation/base/base.dart';
import 'package:projectui/src/presentation/presentation.dart';
import 'package:projectui/src/presentation/widgets/my_loading.dart';
import 'package:projectui/src/resource/model/address_model.dart';
import 'package:projectui/src/resource/model/cart_model.dart';
import 'package:projectui/src/resource/model/list_products_model.dart';
import 'package:projectui/src/resource/model/data.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class CartScreen extends StatefulWidget {
  CartScreen({this.totalQuantity});

  int totalQuantity;

  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen> with ResponsiveWidget {
  CartViewModel cartViewModel;

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
        viewModel: CartViewModel(),
        onViewModelReady: (viewModel) => cartViewModel = viewModel..init(context, widget.totalQuantity),
        builder: (context, viewModel, child) => Scaffold(
            appBar: AppBar(
                title: Text("Giỏ hàng"),
                titleSpacing: 0,
                leading: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context, cartViewModel.totalQuantitySubject.stream.value);
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
    );
  }

  Widget buildListProduct() {
    return StreamBuilder(
      stream: cartViewModel.cartProductSubject.stream,
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
                  child: Text("DANH SÁCH SẢN PHẨM (${cartViewModel.totalQuantitySubject.stream.value})",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
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
                                                  cartViewModel.deleteProduct(cartItem, cartModel);
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
                                                          cartViewModel.minusProduct(cartItem, cartModel);
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
                                                    cartViewModel.addProduct(cartItem, cartModel);
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
              stream: cartViewModel.deliveryAddressSubject.stream,
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
            onTap: () {
              cartViewModel.selectDeliveryAddress();
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
          stream: cartViewModel.deliveryStatusIndex.stream,
          builder: (context, snapshot1) {
            if (snapshot1.hasData) {
              return StreamBuilder(
                stream: cartViewModel.deliveryStatusSubject.stream,
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
                                Text(cartViewModel.getDeliveryStatusName(snapshot2.data[index]))
                              ],
                            ),
                            onTap: () {
                              cartViewModel.getDeliveryTime(index);
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
          textController: cartViewModel.noteController,
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
        stream: cartViewModel.isExportInvoice.stream,
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
                        cartViewModel.selectExportInvoice();
                      },
                    ),
                    GestureDetector(
                      child: Text(
                        "YÊU CẦU XUẤT HÓA ĐƠN VAT",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        cartViewModel.selectExportInvoice();
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
                              textController: cartViewModel.taxCodeController,
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
                              textController: cartViewModel.companyNameController,
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
                              textController: cartViewModel.companyAddressController,
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
                              textController: cartViewModel.companyEmailController,
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
                  stream: cartViewModel.nameSelectedCouponSubject.stream,
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
      onTap: () {
        cartViewModel.selectCoupon();
      },
    );
  }

  Widget buildUseRewardPoints() {
    int rewardPoints = Provider.of<Data>(context, listen: false).rewardPoints ?? 0;

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
                stream: cartViewModel.useRewardPoints.stream,
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
                        cartViewModel.selectUseRewardPoints(rewardPoints);
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
                    stream: cartViewModel.selectedPaymentTypeSubject.stream,
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
      onTap: () {
        cartViewModel.selectPaymentType();
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
                      stream: cartViewModel.tempPriceSubject.stream,
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
                stream: cartViewModel.deliveryAddressSubject.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Row(
                      children: [
                        Text("Phí vận chuyển", style: TextStyle(fontSize: 14)),
                        Spacer(),
                        ShowMoney(
                          price: cartViewModel.isBulkySubject.stream.value ? snapshot.data.shipFeeBulky : snapshot.data.shipFeeNotBulky,
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
                    stream: cartViewModel.discountPriceSubject.stream,
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
                    stream: Rx.combineLatest3(cartViewModel.tempPriceSubject.stream, cartViewModel.deliveryAddressSubject.stream,
                        cartViewModel.discountPriceSubject.stream, (stream1, stream2, stream3) => stream1),
                    builder: (context, snapshot) {
                      return cartViewModel.getTotalPrice(snapshot);
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
                      stream: cartViewModel.totalPriceSubject.stream,
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
          onTap: () {
            cartViewModel.handlePressOrder();
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
