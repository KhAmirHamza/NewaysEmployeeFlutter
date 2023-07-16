// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../models/PurchaseMoneyResponse.dart';
import '../services/purchase_money_api_services.dart';

class PurchaseMoneyApproveController extends GetxController {
  late List<PurchaseMoneyResponse> responses = [];
  TextEditingController noteController = TextEditingController();
  late bool isLoadding = false;

  @override
  void onInit() {
    super.onInit();
    getAllData();
  }

  getAllData() async {
    EasyLoading.show();
    isLoadding = true;
    await PurchaseMoneyAPIServices.getPendingData().then((data) {
      if (data.runtimeType == List<PurchaseMoneyResponse>) {
        responses = data;
      }
    });
    EasyLoading.dismiss();
    isLoadding = false;

    update();
  }

  action(int status, PurchaseMoneyResponse response) async {
    EasyLoading.show();
    isLoadding = true;
    await PurchaseMoneyAPIServices.leaveRequestDepHeadUpdate(data: {
      "id": response.id.toString(),
      "products": jsonEncode([]),
      "employee_id": response.employeeId.toString(),
      "status": status.toString(),
      "note": noteController.text
    });
    EasyLoading.dismiss();
    isLoadding = false;
    await getAllData();
    update();
  }
  
}
