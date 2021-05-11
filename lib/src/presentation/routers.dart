import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/ProfileScreens/Contact/DetailContact/DetailContact_screen.dart';
import '../presentation/presentation.dart';

class Routers {
  static const String Navigation = "/Navigation";
  static const String Forget_Password = "/LoginScreens/ForgetPassword";
  static const String Login = "/LoginScreens/Login";
  static const String New_Password = "/LoginScreens/NewPassword";
  static const String Personal_Info = "/LoginScreens/PersonalInfo";
  static const String Register = "/LoginScreens/Register";
  static const String Member_Card = "/MemberCard";
  static const String Category_Detail = "/CategoriesScreens/CategoryDetail";
  static const String Order_Detail = "/ProfileScreens/Order/OrderDetail";
  static const String Detail_Contact = "/ProfileScreens/Contact/DetailContact";
  static const String Create_Contact = "/ProfileScreens/Contact/CreateContact";
  static const String Writing_Comment = "/CategoriesScreens/WritingComment";
  static const String Viewed_Products = "/ProfileScreens/ViewedProducts";
  static const String Create_Address = "/ProfileScreens/Address/CreateAddress";
  static const String Coupon_Detail = "/ProfileScreens/Coupon/CouponDetail";
  static const String Detail_Profile = "/ProfileScreens/DetailProfile";
  static const String List_Promotion = "/ProfileScreens/Promotion/ListPromotion";
  static const String List_Address = "/ProfileScreens/Address/ListAddress";
  static const String List_Coupons = "/ProfileScreens/Coupon/ListCoupons";
  static const String Order_History = "/ProfileScreens/Order/OrderHistory";
  static const String Change_Password = "/ProfileScreens/ChangePassword";
  static const String Commitment = "/ProfileScreens/Commitment";
  static const String Contact_Types = "ProfileScreens/Contact/ContactTypes";
  static const String Term_Of_Use = "/ProfileScreens/TermOfUse";
  static const String Cart = "/CategoriesScreens/Cart";
  static const String Installment_Detail = "/CategoriesScreens/InstallmentDetail";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    var arguments = settings.arguments;

    switch (settings.name) {
      case Navigation:
        return animRoute(NavigationScreen(), name: Navigation, beginOffset: _center);
        break;
      case Forget_Password:
        return animRoute(ForgetPassword(), name: Forget_Password, beginOffset: _center);
        break;
      case Login:
        return animRoute(LoginScreen(), name: Login, beginOffset: _center);
        break;
      case New_Password:
        return animRoute(NewPassword(), name: New_Password, beginOffset: _center);
        break;
      case Personal_Info:
        return animRoute(PersonalInfo(), name: Personal_Info, beginOffset: _center);
        break;
      case Register:
        return animRoute(RegisterScreen(), name: Register, beginOffset: _center);
        break;
      case Member_Card:
        return animRoute(MemberCardScreen(), name: Member_Card, beginOffset: _center);
        break;
      case Category_Detail:
        return animRoute(CategoryDetail(category: arguments), name: Category_Detail, beginOffset: _center);
        break;
      case Order_Detail:
        return animRoute(OrderDetail(order: arguments), name: Order_Detail, beginOffset: _center);
        break;
      case Detail_Contact:
        return animRoute(DetailContact(), name: Detail_Contact, beginOffset: _center);
        break;
      case Create_Contact:
        return animRoute(CreateContact(), name: Create_Contact, beginOffset: _center);
        break;
      case Writing_Comment:
        return animRoute(WritingComment(productId: arguments), name: Writing_Comment, beginOffset: _center);
        break;
      case Viewed_Products:
        return animRoute(ViewedProducts(), name: Viewed_Products, beginOffset: _center);
        break;
      case Create_Address:
        return animRoute(CreateAddress(event: arguments), name: Create_Address, beginOffset: _center);
        break;
      case Coupon_Detail:
        return animRoute(CouponDetail(coupon: arguments), name: Coupon_Detail, beginOffset: _center);
        break;
      case Detail_Profile:
        return animRoute(DetailProfile(), name: Detail_Profile, beginOffset: _center);
        break;
      case List_Promotion:
        return animRoute(ListPromotion(), name: List_Promotion, beginOffset: _center);
        break;
      case List_Address:
        return animRoute(ListAddress(), name: List_Address, beginOffset: _center);
        break;
      case List_Coupons:
        return animRoute(ListCoupons(), name: List_Coupons, beginOffset: _center);
        break;
      case Order_History:
        return animRoute(OrderHistory(), name: Order_History, beginOffset: _center);
        break;
      case Change_Password:
        return animRoute(ChangePassword(), name: Change_Password, beginOffset: _center);
        break;
      case Commitment:
        return animRoute(CommitmentScreen(), name: Commitment, beginOffset: _center);
        break;
      case Contact_Types:
        return animRoute(ContactTypes(), name: Contact_Types, beginOffset: _center);
        break;
      case Term_Of_Use:
        return animRoute(TermsOfUse(), name: Term_Of_Use, beginOffset: _center);
        break;
      case Cart:
        return animRoute(CartScreen(cartProducts: arguments), name: Cart, beginOffset: _center);
        break;
      case Installment_Detail:
        return animRoute(InstallmentDetailScreen(invoiceId: arguments), name: Installment_Detail, beginOffset: _center);
        break;
      default:
        return animRoute(Container(child: Center(child: Text('No route defined for ${settings.name}'))));
    }
  }

  static Route animRoute(Widget page, {Offset beginOffset, String name, Object arguments}) {
    return PageRouteBuilder(
      settings: RouteSettings(name: name, arguments: arguments),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = beginOffset ?? Offset(0.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  static Offset _center = Offset(0.0, 0.0);
  static Offset _top = Offset(0.0, 1.0);
  static Offset _bottom = Offset(0.0, -1.0);
  static Offset _left = Offset(-1.0, 0.0);
  static Offset _right = Offset(1.0, 0.0);
}
