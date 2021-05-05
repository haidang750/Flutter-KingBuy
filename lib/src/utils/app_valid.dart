import 'package:flutter/material.dart';

import '../configs/configs.dart';

class AppValid {
  AppValid._();

  static validateFullName(BuildContext context) {
    return (value) {
      if (value == null || value.length == 0) {
        return AppLocalizations.of(context).translate("valid_full_name");
      }
      return null;
    };
  }

  static validateEmail(BuildContext context) {
    return (value) {
      if (value == null || value.length == 0) {
        return AppLocalizations.of(context).translate("valid_enter_email");
      } else {
        Pattern pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(value))
          return AppLocalizations.of(context).translate("valid_email");
        else
          return null;
      }
    };
  }

  static validatePassword(BuildContext context) {
    return (value) {
      if (value == null || value.length < 6) {
        return AppLocalizations.of(context).translate("valid_password");
      } else {
        Pattern pattern = r'^[0-9a-zA-Z!@#\$&*~]{6,}$';
        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(value))
          return AppLocalizations.of(context).translate("valid_password");
        else
          return null;
      }
    };
  }

  static validatePhoneNumber(BuildContext context, {bool notRequired = false}) {
    Pattern pattern = r'^(?:[+0]9)?[0-9]{10}$';
    RegExp regex = new RegExp(pattern);

    return (value) {
      if(notRequired)
        return null;
      if (value == null || value.length == 0) {
        return AppLocalizations.of(context).translate("valid_enter_phone");
      } else if (value.length != 10) {
        return AppLocalizations.of(context).translate("valid_phone");
      } else if (!regex.hasMatch(value)) {
        return AppLocalizations.of(context).translate("valid_phone");
      } else {
        return null;
      }
    };
  }

  static validatePhoneAndEmail(BuildContext context) {
    Pattern pattern =
        r'(^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$)|(^(?:[+0]9)?[0-9]{10}$)';
    RegExp regex = new RegExp(pattern);

    return (value) {
      if (value == null || value.length == 0) {
        return AppLocalizations.of(context).translate("valid_enter_account");
      } else if (!regex.hasMatch(value)) {
        return AppLocalizations.of(context).translate("valid_phone");
      } else {
        return null;
      }
    };
  }
}
