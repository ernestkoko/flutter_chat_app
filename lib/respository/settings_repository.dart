import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

ValueNotifier<Settings> settings = ValueNotifier(Settings());

///a unique key for the entire app
final navigatorKey = GlobalKey<NavigatorState>();

Future<Settings> initSetting() async {
  Settings? _setting = Settings.fromJson({});
  SharedPreferences pref = await SharedPreferences.getInstance();
  _setting.brightness.value =
      pref.getBool('isDark') ?? false ? Brightness.dark : Brightness.light;
  settings.value = _setting;
  //ignore:
  settings.notifyListeners();

  return settings.value;
}
