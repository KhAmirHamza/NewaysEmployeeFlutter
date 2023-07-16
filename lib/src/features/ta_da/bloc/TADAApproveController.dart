import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../models/TADAResponse.dart';
import '../services/TADAAPIServices.dart';

class TADAApproveController extends GetxController {
  List<TadaResponse> responses = [];

  @override
  void onInit() {
    super.onInit();
    getAllData();
  }

  getAllData() async {
    EasyLoading.show();
    await TADAAPIServices.getPendingData().then((data) {
      print(data);
      if (data.runtimeType == List<TadaResponse>) {
        responses = data;
      }
    });
    EasyLoading.dismiss();

    update();
  }

  approved(id) async {
    EasyLoading.show();
    await TADAAPIServices.approved(id: id).then((data) {
      Get.back();
      Get.snackbar('Message', data!,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16));
    });
    EasyLoading.dismiss();
    getAllData();
  }

  rejected(id) async {
    EasyLoading.show();
    await TADAAPIServices.reject(id: id).then((data) {
      Get.back();
      Get.snackbar('Message', data!,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16));
    });
    EasyLoading.dismiss();
    getAllData();
  }

  clear() {}
}
