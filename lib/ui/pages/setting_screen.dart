import 'package:attendance/constants.dart';
import 'package:attendance/controller/loading_controller.dart';
import 'package:attendance/models/employee.dart';
import 'package:attendance/controller/company_controller.dart';
import 'package:attendance/preferences/app_preference.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/company.dart';
import '../components/failed_dialog.dart';
import '../map/map_screen.dart';
import 'home_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({this.isEdit = false, Key? key}) : super(key: key);
  final bool isEdit;

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final _companyController = Get.find<CompanyController>();
  final _loadingController = Get.find<LoadingController>();

  final _nameController = TextEditingController();
  final _companyNamController = TextEditingController();

  FailedDialog? _failedDialog;
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
                height: defaultPadding * 1.5,
              ),
              Text(
                widget.isEdit
                    ? "Change your company here "
                    : "is it your first experience?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Flexible(
                  child: ListView(
                children: [
                  const SizedBox(
                    height: defaultPadding,
                  ),
                  buildLabel("where is your company"),
                  const SizedBox(
                    height: defaultPadding / 2,
                  ),
                  Container(
                    height: 60,
                    child: Row(
                      children: [
                        Flexible(
                          child: Obx(
                            () => Container(
                              height: 65,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Color(0xffBDBDBD), width: 0.4)),
                              padding: const EdgeInsets.all(defaultPadding / 2),
                              child: Text(_companyController.address.value),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: defaultPadding / 2,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => MapScreen(), preventDuplicates: false);
                          },
                          child: Image.asset(
                            "assets/images/map-icon.png",
                            width: 24,
                            height: 24,
                          ),
                        )
                      ],
                    ),
                  ),
                  widget.isEdit
                      ? const SizedBox.shrink()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: defaultPadding,
                            ),
                            buildLabel("your full name"),
                            const SizedBox(
                              height: defaultPadding / 2,
                            ),
                            buildInput("", controller: _nameController),
                          ],
                        ),
                  const SizedBox(
                    height: defaultPadding * 2,
                  ),
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
                                    const EdgeInsets.symmetric(vertical: 15)),
                            onPressed: save,
                            child: Text(widget.isEdit ? "UPDATE" : "CONFIRM")),
                  )
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  save() async {
    if (_companyController.address.isEmpty) {
      (_failedDialog = FailedDialog(context)
            ..title = "Warning"
            ..subTitle = "Company address is empty"
            ..okPressed = () {
              Get.back();
            })
          .show();
      return;
    }
    if (!widget.isEdit) {
      if (_nameController.text.isEmpty) {
        (_failedDialog = FailedDialog(context)
              ..title = "Warning"
              ..subTitle = "Full name is empty"
              ..okPressed = () {
                Get.back();
              })
            .show();
        return;
      }
    }

    _loadingController.isLoading.value = true;
    if (!widget.isEdit) {
      Employee.fullname = _nameController.text;
    }
    await AppPreferences.saveSetting();
    _loadingController.isLoading.value = false;
    if (widget.isEdit) {
      Get.back();
    } else {
      Get.offAll(() => HomeScreen());
    }
  }

  Widget buildInput(String hint,
      {bool readOnly = false, TextEditingController? controller}) {
    return TextField(
      readOnly: readOnly,
      controller: controller,
      decoration: InputDecoration(
          hintText: hint,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Color(0xffBDBDBD), width: 0.4)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Color(0xffBDBDBD), width: 0.4))),
    );
  }

  Widget buildLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Color(0xff979797),
      ),
    );
  }
}
