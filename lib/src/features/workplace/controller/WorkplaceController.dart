// ignore_for_file: file_names

import 'package:client_information/client_information.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:neways3/src/features/login/components/LoginScreen.dart';

import '../../../utils/functions.dart';
import '../../linked_devices/services/LinkedDeviceService.dart';

class WorkplaceController extends GetxController {
  final box = GetStorage();
  late ClientInformation diviceInfo;
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  bool isHidden = true;
  @override
  void onInit() {
    super.onInit();
    getInfo();
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
}
