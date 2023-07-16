import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../utils/constants.dart';
import '../services/SecurityAPIService.dart';

class SecurityController extends GetxController {
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  @override
  void onInit() {
    super.onInit();
  }

  submit() async {
    if (fieldEmpty()) {
      return;
    }
    if (passwordNotMatch()) {
      return;
    }
    EasyLoading.show();
    await SecurityAPIService.change(data: {
      "password": oldPassword.text,
      "new_password": newPassword.text
    }).then((value) {
      Get.snackbar('Message', value,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full));
      if (value == "Password Change Successfull") {
        oldPassword.clear();
        newPassword.clear();
        confirmPassword.clear();
      }
    });
    EasyLoading.dismiss();

    return true;
  }

  fieldEmpty() {
    if (oldPassword.text.isEmpty) {
      Get.snackbar('Message', "Old Password must be required!",
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full));
      return true;
    } else if (newPassword.text.isEmpty) {
      Get.snackbar('Message', "New Password must be required!",
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full));
      return true;
    } else if (confirmPassword.text.isEmpty) {
      Get.snackbar('Message', "Confirm Password must be required!",
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full));
      return true;
    }
    return false;
  }

  passwordNotMatch() {
    if (newPassword.text != confirmPassword.text) {
      Get.snackbar('Message', "Confirm password not match new password!",
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full));
      return true;
    }

    return false;
  }
}
