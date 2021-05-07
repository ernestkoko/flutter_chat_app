import 'package:flutter/material.dart';

class Settings{
String appName='';
String? appVersion;
ValueNotifier<Brightness> brightness= ValueNotifier(Brightness.light);

Settings();
Settings.fromJson(Map<String, dynamic> map){
appName=map['app_name']??null.toString();
appVersion=map["app_version"]??'';
}
}