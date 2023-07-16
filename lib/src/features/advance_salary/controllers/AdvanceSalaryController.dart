// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:neways3/src/features/leave/models/LeaveRequest.dart';
import 'package:neways3/src/features/leave/services/leave_api_services.dart';

import '../models/AdvanceSalaryResponse.dart';
import '../services/advance_salary_api_services.dart';

class AdvanceSalaryController extends GetxController {
  late TabController controller;
  late List<AdvanceSalaryResponse> responses = [];
  late bool isLoadding = false;
  TextEditingController reasonController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  String? message;

  @override
  void onInit() {
    super.onInit();
    getAllData();
  }

  getAllData() async {
    EasyLoading.show();
    isLoadding = true;
    await AdvanceSalaryAPIServices.getAllData().then((data) {
      if (data is List<AdvanceSalaryResponse>) {
        responses = data;
      }
    });
    EasyLoading.dismiss();
    isLoadding = false;

    update();
  }

  customDate({DateTime? date, required int day}) {
    date = date ?? DateTime.now();
    return DateTime(date.year, date.month, date.day + day);
  }

  submitRequest() async {
    if (amountController.text.isEmpty) {
      message = "Amount must be required";
      return false;
    }
    EasyLoading.show();
    isLoadding = true;
    await AdvanceSalaryAPIServices.submit(
      data: {"amount": amountController.text, "note": reasonController.text},
    ).then((data) async {
      message = data;
      await getAllData();
    });
    EasyLoading.dismiss();
    isLoadding = false;
    clear();
    update();
    return true;
  }

  clear() {
    reasonController.clear();
    amountController.clear();
  }
}
