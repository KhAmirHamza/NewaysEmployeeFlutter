// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:neways3/src/utils/constants.dart';
import '../models/EmergencyWorkResponse.dart';
import '../services/emergency_work_api_services.dart';

class EmergencyWorkApproveController extends GetxController {
  late List<EmergencyWorkResponse> responses = [];
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

    isBoss?
    //true?
        await EmergencyWorkAPIServices.getBossPendingData().then((data){
          if(data is List<EmergencyWorkResponse>){
            responses = data;
          }
        })
        :
    await EmergencyWorkAPIServices.getPendingData().then((data) {
      print(data.runtimeType);
      if (data is List<EmergencyWorkResponse>) {
        responses = data;
      }
    });
    EasyLoading.dismiss();
    isLoadding = false;

    update();
  }

  depHeadPermit({id, status}) async {
    EasyLoading.show();
    isLoadding = true;
    await EmergencyWorkAPIServices.depHeadPermit(data: {
      "id": id.toString(),
      "approval_type": status,
      "note": noteController.text
    });
    EasyLoading.dismiss();
    isLoadding = false;
    noteController.clear();
    await getAllData();
    update();
  }
}
