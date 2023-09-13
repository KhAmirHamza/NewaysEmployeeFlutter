// ignore_for_file: file_names

import 'dart:convert';

import 'package:client_information/client_information.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:neways3/src/features/login/models/login_request_model.dart';
import 'package:neways3/src/features/login/models/login_response_model.dart';
import 'package:neways3/src/features/login/services/login_service.dart';

import '../../../utils/functions.dart';

class LoginController extends GetxController {
  TextEditingController employeeId = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController otpController = TextEditingController();

  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  late ClientInformation diviceInfo;
  final box = GetStorage();
  var deviceData = <String, dynamic>{};
  bool isRemember = true;
  bool isLoading = false;
  bool visibleUser = false;
  bool obscureText = true;
  bool sendOtp = false;
  int? otp;
  @override
  void onInit() {
    super.onInit();
    messaging.deleteToken();
    if (box.read("isRemember") != null) {
      visibleUser = box.read("isRemember");
      if (box.read("isRemember")) {
        employeeId.text = box.read("employeeId");
        // password.text = box.read("password");
      }
      update();
    }
    getInfo();
  }

  getInfo() async {
    diviceInfo = await getClientInformation();
  }

  setObscureText() {
    obscureText = !obscureText;
    update();
  }

  setRemember(value) {
    isRemember = value;
    update();
  }

  login() async {
    EasyLoading.show(status: "Login...");
    var status = await LoginService.login(LoginRequestModel(
            employeeId: employeeId.text, password: password.text))
        .then((value) async {
      print(jsonEncode(value).toString());
      EasyLoading.dismiss();
      if (value.runtimeType == LoginResponseModel) {
        if (isRemember) {
          box.write('isRemember', true);
          box.write('password', password.text);
        } else {
          box.write('isRemember', false);
          box.write('firstName', null);
          box.write('avater', null);
        }
        print(value.phone);
        print(value.otp);
        otp = value.otp;
        sendOtp = true;
        print(value.avater);
        box.write('token', '${value.accessToken}');
        box.write('firstName', value.fName);
        box.write('employeeId', employeeId.text);
        box.write('name', value.fullName);
        box.write('designationName', value.designationName);
        box.write('departmentName', value.departmentName);
        box.write('roleName', value.roleName);
        box.write('roleName', value.roleName);
        box.write('isDepHead', value.isDepHead);
        box.write('avater', value.avater);
        box.write('reportingBoss', value.reportingBoss);
        print("reportingBoss: ${value.reportingBoss}");
        messaging.subscribeToTopic("Neways3");
        messaging.subscribeToTopic(employeeId.text);
        LoginService.setDiviceInfo(data: {
          "diviceType": diviceInfo.osName,
          "device": diviceInfo.deviceName,
          "ip_address": '',
          "token": diviceInfo.deviceId,
          'datetime': DateTime.now().toString(),
        });
        // messaging.subscribeToTopic(value.departmentName);
        return true;
        // login
      } else {
        return false;
      }
    });
    update();
    return status;
  }

  verify() {
    if (otp.toString() == otpController.text) {
      box.write('isLogin', true);
      return true;
    } else {
      return false;
    }
  }
}
