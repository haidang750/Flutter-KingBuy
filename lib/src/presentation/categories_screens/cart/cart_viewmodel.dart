import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projectui/src/configs/configs.dart';
import 'package:projectui/src/presentation/categories_screens/order_payment/order_payment.dart';
import 'package:projectui/src/presentation/categories_screens/order_success/order_success.dart';
import 'package:projectui/src/presentation/categories_screens/payment_type/payment_type.dart';
import 'package:projectui/src/presentation/categories_screens/select_coupon/select_coupon_screen.dart';
import 'package:projectui/src/presentation/profile_screens/address/list_address/list_address.dart';
import 'package:projectui/src/presentation/base/base_viewmodel.dart';
import 'package:projectui/src/presentation/widgets/show_money.dart';
import 'package:projectui/src/resource/model/invoice_model.dart';
import 'package:projectui/src/resource/model/model.dart';
import 'package:projectui/src/utils/app_shared.dart';
import 'package:projectui/src/utils/app_utils.dart';
import 'package:toast/toast.dart';
import 'package:rxdart/rxdart.dart';

import '../../routers.dart';

class CartViewModel extends BaseViewModel {
  final cartProductSubject = BehaviorSubject<CartModel>();
  final deliveryAddressSubject = BehaviorSubject<Address>();
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

  init(BuildContext context, int totalQuantity) {
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
    totalQuantitySubject.sink.add(totalQuantity);
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

  deleteProduct(CartItem cartItem, CartModel cartModel) {
    tempPriceSubject.sink
        .add(tempPriceSubject.stream.value - cartItem.qty * cartItem.product.salePrice);
    totalQuantitySubject.sink
        .add(totalQuantitySubject.stream.value - cartItem.qty);
    CartModel.of(context).removeProduct(cartItem);
    cartProductSubject.sink.add(cartModel);
  }

  minusProduct(CartItem cartItem, CartModel cartModel) {
    tempPriceSubject.sink
        .add(tempPriceSubject.stream.value - cartItem.product.salePrice);
    CartModel.of(context).updateCartQuantity(cartItem, false);
    cartProductSubject.sink.add(cartModel);
    totalQuantitySubject.sink
        .add(totalQuantitySubject.stream.value - 1);
  }

  addProduct(CartItem cartItem, CartModel cartModel) {
    tempPriceSubject.sink
        .add(tempPriceSubject.stream.value + cartItem.product.salePrice);
    CartModel.of(context).updateCartQuantity(cartItem, true);
    cartProductSubject.sink.add(cartModel);
    totalQuantitySubject.sink.add(totalQuantitySubject.stream.value + 1);
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

  selectDeliveryAddress() async {
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
  }

  getDeliveryTime(int index) {
    deliveryStatusIndex.sink.add(index);
  }

  selectExportInvoice() {
    isExportInvoice.sink.add(!isExportInvoice.stream.value);
    CartModel.of(context).setExportInvoice(isExportInvoice.stream.value ? 1 : 0);
  }

  selectCoupon() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => SelectCouponScreen())).then((coupon) async {
      if (coupon != null) {
        nameSelectedCouponSubject.sink.add(coupon.name);
        idSelectedCouponSubject.sink.add(coupon.id);
        int couponId = coupon.id;
        int total = tempPriceSubject.stream.value;
        int feeShip = isBulkySubject.stream.value
            ? (deliveryAddressSubject.stream.value != null ? deliveryAddressSubject.stream.value.shipFeeBulky : 0)
            : (deliveryAddressSubject.stream.value != null ? deliveryAddressSubject.stream.value.shipFeeNotBulky : 0);
        discountPriceSubject.sink
            .add(await getDiscountPrice(couponId, total, feeShip, deliveryAddressSubject.stream.value));
      }
    });
  }

  selectUseRewardPoints(int rewardPoints) {
    useRewardPoints.sink.add(!useRewardPoints.stream.value);
    if (useRewardPoints.stream.value) {
      CartModel.of(context).setSavePoint(rewardPoints);
    } else {
      CartModel.of(context).setSavePoint(0);
    }
  }

  selectPaymentType() async {
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
  }

  Future<int> getDiscountPrice(int couponId, int total, int feeShip, Address selectedAddress) async {
    NetworkState<CheckCouponModel> result = await categoryRepository.checkCoupon(couponId, total);
    if (result.data != null) {
      int status = result.data.status;
      if (status == 1) {
        int discountPrice = 0;
        if (selectedAddress != null) {
          if (result.data.checkCoupon.type == 3) {
            // nếu type là 3 (giảm tiền ship)
            if (feeShip < result.data.checkCoupon.discount) {
              discountPrice = feeShip;
            } else {
              discountPrice = result.data.checkCoupon.discount;
            }
          } else {
            discountPrice = result.data.checkCoupon.discount; // nếu type là 1 hoặc 2 (giảm tiền hàng)
          }
        }
        return discountPrice;
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  }

  getTotalPrice(AsyncSnapshot snapshot) {
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
  }

  handlePressOrder() {
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
                              invoiceData = await createInvoiceToken(
                                  deliveryAddressSubject.stream.value.id,
                                  idPaymentTypeSubject.stream.value,
                                  deliveryStatusSubject.stream.value[deliveryStatusIndex.stream.value],
                                  noteController.text,
                                  isExportInvoice.stream.value ? 1 : 0,
                                  useRewardPoints.stream.value ? 1 : 0,
                                  CartModel.of(context).products);
                            } else {
                              // Tạo đơn hàng khi chưa đăng nhập
                              invoiceData = await createInvoiceNotToken(
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
  }

  Future<InvoiceData> createInvoiceToken(
      int deliveryAddressId, int paymentType, int deliveryStatus, String note, int isExportInvoice, int isUsePoint, List<CartItem> cartItems) async {
    NetworkState<InvoiceModel> result =
        await categoryRepository.createInvoiceToken(deliveryAddressId, paymentType, deliveryStatus, note, isExportInvoice, isUsePoint, cartItems);
    if (result.data.status == 1) {
      return result.data.invoiceData;
    } else {
      return null;
    }
  }

  Future<InvoiceData> createInvoiceNotToken(
      int paymentType,
      int deliveryStatus,
      String note,
      String orderPhone,
      String orderPhone2,
      String orderName,
      String provinceCode,
      String districtCode,
      String wardCode,
      String address,
      int isExportInvoice,
      String taxCode,
      String companyName,
      String companyAddress,
      String companyEmail,
      List<CartItem> cartItems) async {
    NetworkState<InvoiceModel> result = await categoryRepository.createInvoiceNotToken(paymentType, deliveryStatus, note, orderPhone, orderPhone2,
        orderName, provinceCode, districtCode, wardCode, address, isExportInvoice, taxCode, companyName, companyAddress, companyEmail, cartItems);
    if (result.data.status == 1) {
      return result.data.invoiceData;
    } else {
      return null;
    }
  }

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
}
