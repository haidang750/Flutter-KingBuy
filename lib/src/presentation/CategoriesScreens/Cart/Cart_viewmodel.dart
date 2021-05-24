import 'package:projectui/src/presentation/base/base_viewmodel.dart';
import 'package:projectui/src/resource/model/InvoiceModel.dart';
import 'package:projectui/src/resource/model/model.dart';

class CartViewModel extends BaseViewModel {
  Future<int> getDiscountPrice(int couponId, int total, int feeShip, Address selectedAddress) async {
    print("couponId: $couponId");
    print("total: $total");
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
}
