import 'dart:async';

import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppShared {
  AppShared._();

  static final prefs = RxSharedPreferences(SharedPreferences.getInstance());

  static const String _keyAccessToken = "_keyAccessToken";

  static Future<void> setAccessToken(String token) =>
      prefs.setString(_keyAccessToken, token);

  static Future<String> getAccessToken() => prefs.getString(_keyAccessToken);

  /// DEMO: Use stream listen change
  // static Future<bool> setWeather(WeatherModel weather) async {
  //   String json = weather != null ? jsonEncode(weather) : "";
  //   return prefs.setString(keyWeather, json);
  // }
  //
  // static Future<WeatherModel> getWeather() async {
  //   String string = await prefs.getString(keyWeather);
  //   if (string != null && string.length != 0)
  //     return WeatherModel.fromJson(jsonDecode(string));
  //   else
  //     return null;
  // }
  //
  // static Stream<WeatherModel> watchWeather() {
  //   return prefs.getStringStream(keyWeather).transform(
  //       StreamTransformer.fromHandlers(
  //           handleData: (data, sink) => (data == null || data.length == 0)
  //               ? sink.add(null)
  //               : sink.add(WeatherModel.fromJson(jsonDecode(data)))));
  // }
}
