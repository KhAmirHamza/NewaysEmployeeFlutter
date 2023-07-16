import 'package:client_information/client_information.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../../utils/functions.dart';
import '../../login/components/LoginScreen.dart';
import '../services/LinkedDeviceService.dart';

class LinkedDeviceController extends GetxController {
  late ClientInformation diviceInfo;
  List responses = [];
  @override
  void onInit() {
    super.onInit();
    getInfo();
    getLoginData();
  }

  getInfo() async {
    diviceInfo = await getClientInformation();
  }

  getLoginData() async {
    var count = 0;
    await LinkedDeviceService.getLoginDivice().then((value) {
      responses.clear();
      if (value != null) {
        for (var element in value) {
          if (element["device_type"] == "windows" ||
              element["device_type"] == "linux") {
            if (!isTimePast(int.parse(element["time_now"].toString())) &&
                element["time_now"].toString() != "0") {
              responses.add(element);
            }
          } else if (element["device_type"] == "Android") {
            count = responses
                .where((e) => e["token"] == element['token'].toString())
                .length;
            if (count == 0) {
              responses.add(element);
            }
          } else {
            responses.add(element);
          }
        }
      }
      update();
    });
  }

  bool isTimePast(int timestamp) {
    var now = DateTime.now();
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = date.difference(now);
    if (diff.inMinutes < -59) {
      return true;
    }

    return false;
  }

  Future<void> scanQR() async {
    String qrCodeScanRes;
    try {
      qrCodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(qrCodeScanRes);
      await LinkedDeviceService.desktopLogin(qrCodeScanRes.split("key=")[1]);
      Future.delayed(const Duration(seconds: 2))
          .then((value) async => await getLoginData());
    } on PlatformException {
      qrCodeScanRes = 'Failed to get platform version.';
    }
    return;
  }

  deviceLogout({data}) async {
    await LinkedDeviceService.logoutDivice(data: {
      "token": data['token'],
    });
    print(data['token'] == diviceInfo.deviceId);
    if (data['token'] == diviceInfo.deviceId) {
      GetStorage().write('isLogin', false);
      Get.offAll(const LoginScreen());
    }
    await getLoginData();
  }
}
