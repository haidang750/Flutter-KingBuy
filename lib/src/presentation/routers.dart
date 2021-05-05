import 'package:flutter/material.dart';
import '../presentation/presentation.dart';

class Routers {
  static const String Navigation = "/Navigation";
  static const String Forget_Password = "/LoginScreens/ForgetPassword";
  static const String Login = "/LoginScreens/Login";
  static const String New_Password = "/LoginScreens/NewPassword";
  static const String Personal_Info = "/LoginScreens/PersonalInfo";
  static const String Register = "/LoginScreens/Register";
  static const String Member_Card = "/MemberCard";

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
      default:
        return animRoute(Container(
            child:
            Center(child: Text('No route defined for ${settings.name}'))));
    }
  }

  static Route animRoute(Widget page,
      {Offset beginOffset, String name, Object arguments}) {
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
