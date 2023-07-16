import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../models/EmployeeResignResponse.dart';
import '../services/ResignAPIService.dart';

class ResignApproveController extends GetxController {
  TextEditingController reasonController = TextEditingController();
  bool isDataEmpty = false;
  List<EmployeeResignResponse> responses = [];

  @override
  void onInit() async {
    super.onInit();
    getAllData();
  }

  submit() async {
    if (reasonController.text.isEmpty) {
      Get.snackbar('Wrong', "Reason must be required",
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full));
      return false;
    }
    EasyLoading.show();
    await ResignAPIService.submit(
      data: {"reason": reasonController.text},
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

  getAllData() async {
    EasyLoading.show();
    await ResignAPIService.getAllData().then((data) {
      print(data);
      if (data.runtimeType == List<EmployeeResignResponse>) {
        responses = data;
        isDataEmpty = data.isEmpty;
      }
    });
    EasyLoading.dismiss();

    update();
  }

  action(String status, EmployeeResignResponse response) async {
    EasyLoading.show();
    await ResignAPIService.update(id: response.id, status: status).then((msg) {
      Get.snackbar('Message', msg,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full));
    });
    EasyLoading.dismiss();
    await getAllData();
    update();
  }
}
