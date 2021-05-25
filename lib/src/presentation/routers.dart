import 'package:flutter/material.dart';
import 'package:projectui/src/presentation/profile_screens/contact/contact_types/contact_types_screen.dart';
import 'package:projectui/src/presentation/profile_screens/contact/detail_contact/detail_contact_screen.dart';
import '../presentation/presentation.dart';

class Routers {
  static const String Navigation = "/navigation";
  static const String Forget_Password = "/login_screens/forget_password";
  static const String Login = "/login_screens/login";
  static const String New_Password = "/login_screens/new_password";
  static const String Personal_Info = "/login_screens/personal_info";
  static const String Register = "/login_screens/register";
  static const String Member_Card = "/member_card";
  static const String Order_Detail = "/profile_screens/order/order_detail";
  static const String Detail_Contact = "/profile_screens/contact/detail_contact";
  static const String Create_Contact = "/profile_screens/contact/create_contact";
  static const String Writing_Comment = "/categories_screens/writing_comment";
  static const String Viewed_Products = "/profile_screens/viewed_products";
  static const String Coupon_Detail = "/profile_screens/coupon/coupon_detail";
  static const String Detail_Profile = "/profile_screens/detail_profile";
  static const String List_Promotion = "/profile_screens/promotion/list_promotion";
  static const String List_Coupons = "/profile_screens/coupon/list_coupons";
  static const String Order_History = "/profile_screens/order/order_history";
  static const String Change_Password = "/profile_screens/change_password";
  static const String Commitment = "/profile_screens/commitment";
  static const String Contact_Types = "profile_screens/contact/contact_types";
  static const String Term_Of_Use = "/profile_screens/term_of_use";
  static const String Installment_Detail = "/categories_screens/installment_detail";
  static const String Root_Profile = "/profile_screens/root_profile";
  static const String Search = "/home_screens/search";
  static const String Store_Location = "/home_screens/store_location";
  static const String Detail_Store = "/home_screens/detail_store";

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
      case Order_Detail:
        return animRoute(OrderDetail(invoice: arguments), name: Order_Detail, beginOffset: _center);
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
      case Coupon_Detail:
        return animRoute(CouponDetail(coupon: arguments), name: Coupon_Detail, beginOffset: _center);
        break;
      case Detail_Profile:
        return animRoute(DetailProfile(), name: Detail_Profile, beginOffset: _center);
        break;
      case List_Promotion:
        return animRoute(ListPromotion(), name: List_Promotion, beginOffset: _center);
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
      case Installment_Detail:
        return animRoute(InstallmentDetailScreen(invoiceId: arguments), name: Installment_Detail, beginOffset: _center);
        break;
      case Root_Profile:
        return animRoute(RootProfileScreen(), name: Root_Profile, beginOffset: _center);
        break;
      case Search:
        return animRoute(SearchScreen(), name: Search, beginOffset: _center);
        break;
      case Store_Location:
        return animRoute(StoreLocationScreen(), name: Store_Location, beginOffset: _center);
        break;
      case Detail_Store:
        return animRoute(DetailStoreScreen(store: arguments), name: Detail_Store, beginOffset: _center);
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
