// ignore_for_file: file_names

import 'package:client_information/client_information.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:neways3/src/features/login/components/LoginScreen.dart';
import 'package:neways3/src/features/workplace/model/EmployeeLocation.dart';
import 'package:neways3/src/features/workplace/model/PendingApproval.dart';
import 'package:neways3/src/features/workplace/services/WorkplaceService.dart';

import '../../../utils/functions.dart';
import '../../linked_devices/services/LinkedDeviceService.dart';

class WorkplaceController extends GetxController {
  final box = GetStorage();
  late ClientInformation diviceInfo;
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  bool isHidden = true;

  PendingApprovals dHeadPendingApprovals = PendingApprovals(leave: 0, purchase: 0,taDa: 0, advance: 0, emergencyWork: 0, resign: 0, fired: 0);
  PendingApprovals bossPendingApprovals = PendingApprovals(leave: 0, purchase: 0,taDa: 0, advance: 0, emergencyWork: 0, resign: 0, fired: 0);
  late bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    getInfo();
    getAllDHeadPendingCount();
    getAllBossPendingCount();
  }

  getInfo() async {
    diviceInfo = await getClientInformation();
    await LinkedDeviceService.checkLogin(data: {
      "diviceType": diviceInfo.osName,
      "device": diviceInfo.deviceName,
      "ip_address": '',
      "token": diviceInfo.deviceId,
    }).then((value) {
      if (value == false) {
        box.write('isLogin', false);
        messaging.unsubscribeFromTopic(box.read('employeeId'));
        Get.offAll(const LoginScreen());
      }
    });
  }

  getAllDHeadPendingCount() async {
    EasyLoading.show();
    await WorkplaceService.getAllDHeadPendingCount().then((value) {
      if (value.runtimeType == PendingApprovals) {
        // print("getAllDHeadPendingCount called");
        dHeadPendingApprovals = value;
        isLoading = false;
      } else {
        // error
      }
    });

    //update();
    refresh();
    EasyLoading.dismiss();
  }


  getAllBossPendingCount() async {
    EasyLoading.show();
    await WorkplaceService.getAllBossPendingCount().then((value) {
      if (value.runtimeType == PendingApprovals) {
        // print("getAllBossPendingCount called");
        bossPendingApprovals = value;
        isLoading = false;
      } else {
        // error
      }
    });

    //update();
    refresh();
    EasyLoading.dismiss();
  }




}
