// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:neways3/src/features/leave/models/LeaveResponse.dart';
import 'package:neways3/src/features/leave/services/leave_api_services.dart';

class LeaveApproveController extends GetxController {
  late List<LeaveResponse> leaves = [];
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
    await LeaveAPIServices.getPendingData(0).then((data) {
      if (data.runtimeType == List<LeaveResponse>) {
        leaves = data;
      }
    });
    EasyLoading.dismiss();
    isLoadding = false;

    update();
  }

  action(int status, LeaveResponse leave) async {
    EasyLoading.show();
    isLoadding = true;
    await LeaveAPIServices.leaveRequestDepHeadUpdate(data: {
      "id": leave.id.toString(),
      "e_db_id": leave.eDbId.toString(),
      "employee_id": leave.employeeId.toString(),
      "status": status.toString(),
      "note": noteController.text
    });
    noteController.text = "";
    EasyLoading.dismiss();
    isLoadding = false;
    getAllData();
  }
}
