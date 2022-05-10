import 'dart:convert';

import 'package:attendance/controller/loading_controller.dart';

import 'package:attendance/controller/company_controller.dart';
import 'package:attendance/preferences/app_preference.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/attendance_controller.dart';
import 'ui/pages/home_screen.dart';
import 'ui/pages/setting_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _companyController = Get.put(CompanyController());
  final _loadingController = Get.put(LoadingController());

  bool isFirst = true;

  @override
  void initState() {
    loadSetting();
    super.initState();
  }

  loadSetting() async {
    var setting = await AppPreferences.getSetting();
    if (setting != null) {
      print("setting ${jsonEncode(setting)}");
      setState(() {
        isFirst = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'The Attendance',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Builder(builder: (context) {
        if (!isFirst) {
          return const HomeScreen();
        }
        return const SettingScreen();
      }),
    );
  }
}
