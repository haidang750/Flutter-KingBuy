import 'dart:async';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppShared {
  AppShared._();

  static final prefs = RxSharedPreferences(SharedPreferences.getInstance());

  static const String _keyAccessToken = "_keyAccessToken";
  static const String _keyListAddress = "_keyListAddress";
  static const String _keyListSearch = "_keyListSearch";
  static const String _keyShowPopup = "_keyShowPopup";

  static Future<void> setAccessToken(String token) => prefs.setString(_keyAccessToken, token);

  static Future<String> getAccessToken() => prefs.getString(_keyAccessToken);

  static Future<void> setListAddress(List<String> listAddress) => prefs.setStringList(_keyListAddress, listAddress);

  static Future<List<String>> getAddressModel() => prefs.getStringList(_keyListAddress);

  static Future<void> setListSearch(List<String> listSearch) => prefs.setStringList(_keyListSearch, listSearch);

  static Future<List<String>> getListSearch() => prefs.getStringList(_keyListSearch);

  static Future<void> setShowPopup(bool isShowPopup) => prefs.setBool(_keyShowPopup, isShowPopup);

  static Future<bool> getShowPopup() => prefs.getBool(_keyShowPopup);
}
