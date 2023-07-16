// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../models/EmergencyWorkResponse.dart';
import '../services/emergency_work_api_services.dart';

class EmergencyWorkController extends GetxController {
  late List<EmergencyWorkResponse> responses = [];
  late bool isLoadding = false;

  @override
  void onInit() {
    super.onInit();
    getAllData();
  }

  getAllData() async {
    EasyLoading.show();
    isLoadding = true;
    await EmergencyWorkAPIServices.getAllData().then((data) {
      if (data is List<EmergencyWorkResponse>) {
        responses = data;
      }
    });
    EasyLoading.dismiss();
    isLoadding = false;

    update();
  }
}
