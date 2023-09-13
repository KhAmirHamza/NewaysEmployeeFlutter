// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:neways3/src/features/leave/models/LeaveResponse.dart';
import 'package:neways3/src/features/leave/services/leave_api_services.dart';

import '../models/AdvanceSalaryResponse.dart';
import '../services/advance_salary_api_services.dart';

class AdvanceSalaryApproveController extends GetxController {
  late List<AdvanceSalaryResponse> responses = [];
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
    await AdvanceSalaryAPIServices.getPendingData().then((data) {
      if (data is List<AdvanceSalaryResponse>) {
        responses = data;
      }
    });
    EasyLoading.dismiss();
    isLoadding = false;

    update();
  }

  dHeadAndBossApproval({required List<int> ids, required String action}) async {
    EasyLoading.show();
    isLoadding = true;
    await AdvanceSalaryAPIServices.dHeadAndBossApproval(action: action, ids: ids, note: noteController.text);
    EasyLoading.dismiss();
    isLoadding = false;
    noteController.clear();
    await getAllData();
    update();
  }

  approve({required id}) async {
    EasyLoading.show();
    isLoadding = true;
    await AdvanceSalaryAPIServices.depHeadApprove(
        data: {"id": id.toString(), "note": noteController.text});
    EasyLoading.dismiss();
    isLoadding = false;
    noteController.clear();
    await getAllData();
    update();
  }

  reject({required id}) async {
    EasyLoading.show();
    isLoadding = true;
    await AdvanceSalaryAPIServices.depHeadReject(
        data: {"id": id.toString(), "note": noteController.text});
    EasyLoading.dismiss();
    isLoadding = false;
    noteController.clear();
    await getAllData();
    update();
  }
}
