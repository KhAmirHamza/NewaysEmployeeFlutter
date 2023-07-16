// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:neways3/src/features/leave/models/LeaveRequest.dart';
import 'package:neways3/src/features/leave/models/LeaveResponse.dart';
import 'package:neways3/src/features/leave/services/leave_api_services.dart';

class LeaveController extends GetxController {
  late TabController controller;
  late List<LeaveResponse> leaves = [];
  late bool isLoadding = false;
  TextEditingController leaveReasonController = TextEditingController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  TextEditingController howManyDaysController = TextEditingController();
  bool isFullDay = true;
  String? message;

  @override
  void onInit() {
    super.onInit();
    startDate = customDate(day: 0);
    endDate = customDate(day: 0);
    getAllData();
  }

  getAllData() async {
    EasyLoading.show();
    isLoadding = true;
    await LeaveAPIServices.getAllData().then((data) {
      if (data.runtimeType == List<LeaveResponse>) {
        leaves = data;
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
    if (!isFullDay) {
      endDate = startDate;
    } else {
      howManyDaysController.text =
          ((endDate.difference(startDate).inHours / 24).round() + 1).toString();
      print(howManyDaysController.text);
    }
    if (double.parse(howManyDaysController.text) < 0.5) {
      message = "Leave duration not valid!";
      return false;
    }
    EasyLoading.show();
    isLoadding = true;
    await LeaveAPIServices.submit(
      data: LeaveRequest(
          startDate: "${startDate.year}-${startDate.month}-${startDate.day}",
          endDate: "${endDate.year}-${endDate.month}-${endDate.day}",
          howManyDays: howManyDaysController.text,
          note: leaveReasonController.text,
          isHalfDay: isFullDay ? '0' : '1'),
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

  seleceDayType(value) {
    isFullDay = value;
    if (!isFullDay) {
      startDate = customDate(day: 0);
    } else {
      startDate = customDate(day: 1);
    }
    howManyDaysController.text = value ? '' : '0.5';
    update();
  }

  clear() {
    leaveReasonController.clear();
    startDate = DateTime.now();
    endDate = DateTime.now();
    howManyDaysController.clear();
  }
}
