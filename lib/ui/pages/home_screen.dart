import 'dart:convert';

import 'package:attendance/extension/date_time_extension.dart';
import 'package:attendance/extension/string_extension.dart';
import 'package:attendance/models/attendance.dart';
import 'package:attendance/controller/attendance_controller.dart';

import 'package:attendance/constants.dart';
import 'package:attendance/controller/loading_controller.dart';
import 'package:attendance/preferences/attendance_preference.dart';
import 'package:attendance/services/distance_service.dart';
import 'package:attendance/models/employee.dart';
import 'package:attendance/controller/employee_controller.dart';
import 'package:attendance/models/company.dart';
import 'package:attendance/controller/company_controller.dart';
import 'package:attendance/services/location_service.dart';
import 'package:attendance/preferences/app_preference.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart' as latlong;

import 'package:fluttertoast/fluttertoast.dart';

import '../components/failed_dialog.dart';
import 'setting_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _employeeController = Get.put(EmployeeController());
  final _companyController = Get.find<CompanyController>();
  final _loadingController = Get.find<LoadingController>();
  final _attendanceController = Get.put(AttendanceController());

  FailedDialog? _failedDialog;

  @override
  void initState() {
    loadSetting();
    loadAttendance();
    super.initState();
  }

  loadAttendance() async {
    var data = await AttendancePreference.getAttendance();
    if (data != null) {
      print("attendance " + data);
      var atts = jsonDecode(data);
      _attendanceController.listAttendance.value =
          (atts as List).map((e) => Attendance.fromJson(e)).toList();
    }
  }

  loadSetting() async {
    final setting = await AppPreferences.getSetting();
    if (setting != null) {
      Company.address = setting['address'];
      Company.location = LatLng(setting['latitude'], setting['longitude']);
      Employee.fullname = setting['fullname'];
      _employeeController.fullname.value = setting['fullname'];
      _companyController.address.value = Company.address ?? '';
      _companyController.latitude.value = Company.location!.latitude;
      _companyController.longitude.value = Company.location!.longitude;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: defaultPadding,
              ),
              buildHeader(),
              const SizedBox(
                height: defaultPadding * 1.5,
              ),
              Text(
                "Your Attendance",
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 10),
              ),
              const SizedBox(
                height: defaultPadding / 2,
              ),
              Flexible(
                  flex: 7,
                  fit: FlexFit.tight,
                  child: Obx(
                    () => _attendanceController.listAttendance.isEmpty
                        ? Text("No attendance added")
                        : ListView.builder(
                            itemCount:
                                _attendanceController.listAttendance.length,
                            itemBuilder: (context, index) {
                              return buildCard(
                                  _attendanceController.listAttendance[index]);
                            },
                            //children: [buildCard()],
                          ),
                  )),
              Flexible(
                flex: 1,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Obx(
                      () => _loadingController.isLoading.value
                          ? Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: primaryColor,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14))),
                              onPressed: createAttendance,
                              child: Text("CREATE ATTENDANCE")),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: defaultPadding * 2,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "hi",
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w300,
                  color: Color.fromARGB(255, 128, 125, 125)),
            ),
            Obx(() => _employeeController.fullname.isEmpty
                ? const SizedBox.shrink()
                : Text(
                    _employeeController.fullname.value.toCamelCase(),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  )),
          ],
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => SettingScreen(isEdit: true), preventDuplicates: false);
          },
          child: Container(
            padding: const EdgeInsets.all(defaultPadding / 2),
            decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(5)),
            child: Icon(
              Icons.settings_rounded,
              color: primaryColor,
            ),
          ),
        )
      ],
    );
  }

  createAttendance() async {
    _loadingController.isLoading.value = true;
    final location = await LocationService.getLocation();
    var distance = DistanceService.getDistance(
        empLocation: latlong.LatLng(location!.latitude!, location.longitude!),
        companyLocation: latlong.LatLng(_companyController.latitude.value,
            _companyController.longitude.value));
    _loadingController.isLoading.value = false;
    print("location $location distance $distance");
    if (distance > 50) {
      (_failedDialog = FailedDialog(context)
            ..title = "Failed"
            ..subTitle =
                "Your distance more than 50 meter. You can not create attendance"
            ..okPressed = () {
              Get.back();
            })
          .show();
    } else {
      Fluttertoast.showToast(
          msg: "Attendance added succesfully",
          backgroundColor: Color.fromARGB(255, 20, 20, 20),
          textColor: Colors.white,
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_LONG);
      var att =
          Attendance(fullname: Employee.fullname ?? '', date: DateTime.now());
      _attendanceController.listAttendance.add(att);
      AttendancePreference.saveAttendance(_attendanceController.listAttendance);
    }
  }

  Widget buildCard(Attendance att) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(att.fullname.toCamelCase()),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: defaultPadding / 2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xff32CB78)),
                alignment: Alignment.center,
                child: Text(
                  "IN",
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                      color: Color(0xffBDFFDB)),
                ),
              )
            ],
          ),
          const SizedBox(
            height: defaultPadding / 2,
          ),
          Text(
            att.date.infoDate(),
            style: TextStyle(
                color: Color(0xff707070),
                fontWeight: FontWeight.w300,
                fontSize: 10),
          ),
          const SizedBox(
            height: defaultPadding / 2,
          ),
          Container(
            height: 0.5,
            color: Color(0xffDAD7D7),
          )
        ],
      ),
    );
  }
}
