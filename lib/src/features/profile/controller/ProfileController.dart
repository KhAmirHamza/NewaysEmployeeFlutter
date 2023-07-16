// ignore_for_file: file_names

import 'package:client_information/client_information.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:neways3/src/features/profile/models/profile_response_model.dart';
import 'package:neways3/src/features/profile/services/profile_service.dart';
import 'package:neways3/src/utils/functions.dart';

import '../../linked_devices/controller/LinkedDeviceController.dart';
import '../../linked_devices/services/LinkedDeviceService.dart';

class ProfileController extends GetxController {
  late ProfileResponseModel profile;
  late ClientInformation diviceInfo;
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final box = GetStorage();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    systemUi();
    getInfo();
  }

  systemUi() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark));
    update();
  }

  getInfo() async {
    diviceInfo = await getClientInformation();
  }

  getProfile() async {
    await ProfileService.me().then((value) {
      return value;
    });
  }

  bool logOut() {
    box.write('isLogin', false);
    // messaging.subscribeToTopic('Neways3');
    messaging.unsubscribeFromTopic(box.read('employeeId'));
    // messaging.subscribeToTopic(box.read('departmentName'));
    diviceLogout();
    return true;
  }

  diviceLogout() async {
    await LinkedDeviceService.logoutDivice(data: {
      "diviceType": diviceInfo.osName,
      "device": diviceInfo.deviceName,
      "ip_address": '',
      "token": diviceInfo.deviceId,
    });
  }
}
