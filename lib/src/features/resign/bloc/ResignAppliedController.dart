import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../services/ResignAPIService.dart';

class ResignAppliedController extends GetxController {
  TextEditingController reasonController = TextEditingController();
  DateTime lastdate =
      DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

  submit() async {
    if (reasonController.text.isEmpty) {
      Get.snackbar('Wrong', "Reason must be required",
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full));
      return false;
    }
    EasyLoading.show();
    await ResignAPIService.submit(
      data: {
        "application": reasonController.text,
        "resign_date": lastdate.toString()
      },
    ).then((data) async {
      reasonController.clear();
      Get.back();
      Get.snackbar('Message', data,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full));
    });
    EasyLoading.dismiss();
    update();
    return true;
  }
}
