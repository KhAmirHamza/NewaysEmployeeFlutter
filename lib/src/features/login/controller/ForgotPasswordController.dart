// ignore_for_file: file_names

import 'package:client_information/client_information.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:neways3/src/features/login/models/login_request_model.dart';
import 'package:neways3/src/features/login/models/login_response_model.dart';
import 'package:neways3/src/features/login/services/login_service.dart';

import '../../../utils/constants.dart';

class ForgotPasswordController extends GetxController {
  TextEditingController employeeId = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController otpController = TextEditingController();

  late ClientInformation diviceInfo;
  final box = GetStorage();
  var deviceData = <String, dynamic>{};
  bool isRemember = true;
  bool isLoading = false;
  bool visibleUser = false;
  bool obscureText = true;
  bool sendOtp = false;
  int? otp;

  bool step1 = true;
  bool step2 = false;
  bool step3 = false;

  @override
  void onInit() {
    super.onInit();
    if (box.read("isRemember") != null) {
      visibleUser = box.read("isRemember");
      if (box.read("isRemember")) {
        employeeId.text = box.read("employeeId");
        // password.text = box.read("password");
      }
      update();
    }
  }

  changeStep(int step) {
    switch (step) {
      case 1:
        step1 = true;
        step2 = false;
        step3 = false;
        break;
      case 2:
        step1 = false;
        step2 = true;
        step3 = false;
        break;
      case 3:
        step1 = false;
        step2 = false;
        step3 = true;
        break;
      default:
    }
    update();
  }

  sendNewOtp() async {
    await EasyLoading.show();
    await LoginService.sendOtp(employeeId: employeeId.text).then((value) {
      if (value is String) otp = int.parse(value);
      update();
    });
    await EasyLoading.dismiss();
    changeStep(2);
    return true;
  }

  forgotPassword() async {
    if (passwordNotMatch()) {
      return;
    }
    await EasyLoading.show();
    await LoginService.forgotPassword(
            {"employeeId": employeeId.text, "password": confirmPassword.text})
        .then((value) {
      if (value == "Password Change Successfull") {
        Get.back();
        Get.snackbar('Message', value,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.all(DPadding.full));
      }
      update();
    });
    await EasyLoading.dismiss();
    return true;
  }

  verify() {
    if (otp.toString() == otpController.text) {
      changeStep(3);
      return true;
    } else {
      return false;
    }
  }

  passwordNotMatch() {
    if (password.text != confirmPassword.text) {
      Get.snackbar('Message', "Confirm password not match new password!",
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full));
      return true;
    }

    return false;
  }
}
