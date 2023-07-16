// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../models/PurchaseMoneyResponse.dart';
import '../services/purchase_money_api_services.dart';

class PurchaseMoneyController extends GetxController {
  late TabController controller;
  TextEditingController amountController = TextEditingController();
  late List<PurchaseMoneyResponse> responses = [];
  late List<PurchaseMoneyResponse> tempResponses = [];
  late bool isLoadding = false;
  late bool isAll = true;
  late bool isReject = false;
  late bool isPending = false;
  late bool isApprove = false;

  @override
  void onInit() {
    super.onInit();
    getAllData();
  }

  getAllData() async {
    EasyLoading.show();
    isLoadding = true;
    isAll = true;
    isReject = false;
    isPending = false;
    isApprove = false;
    await PurchaseMoneyAPIServices.getAllData().then((data) {
      if (data.runtimeType == List<PurchaseMoneyResponse>) {
        responses = data;
        tempResponses = data;
      }
    });
    EasyLoading.dismiss();
    isLoadding = false;

    update();
  }

  getPending() async {
    isAll = false;
    isReject = false;
    isPending = true;
    isApprove = false;
    responses = [];
    tempResponses.forEach((element) {
      if (((element.status.toString() == '0' &&
              element.dHeadApproval.toString() == '0') ||
          (element.status.toString() == '1' &&
              element.dHeadApproval.toString() == '0') ||
          (element.dHeadApproval.toString() == '1' &&
              element.status.toString() == '1') ||
          (element.dHeadApproval.toString() != '2' &&
              element.status.toString() == '1'))) {
        print(element.status);
        print(element.dHeadApproval);
        responses.add(element);
      }
    });
    update();
  }

  getApprove() async {
    isAll = false;
    isReject = false;
    isPending = false;
    isApprove = true;
    responses = [];
    tempResponses.forEach((element) {
      if ((element.status.toString() == '4' ||
          element.status.toString() == '2')) {
        print(element.status);
        print(element.dHeadApproval);
        responses.add(element);
      }
    });
    update();
  }

  getReject() async {
    isAll = false;
    isReject = true;
    isPending = false;
    isApprove = false;
    responses = [];
    tempResponses.forEach((element) {
      if ((element.status.toString() == '3' ||
          element.dHeadApproval.toString() == '2')) {
        print(element.status);
        print(element.dHeadApproval);
        responses.add(element);
      }
    });
    update();
  }

  accept(id) async {
    EasyLoading.show();
    await PurchaseMoneyAPIServices.update(id: id, amount: amountController.text)
        .then((data) {
      Get.back();
      Get.snackbar('Message', data!,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16));
    });
    EasyLoading.dismiss();
    getAllData();
    update();
  }

  delete(id) async {
    EasyLoading.show();
    await PurchaseMoneyAPIServices.delete(id: id).then((data) {
      Get.back();
      Get.snackbar('Message', data!,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16));
    });
    EasyLoading.dismiss();
    getAllData();
  }

  moneyReceived(id) async {
    EasyLoading.show();
    await PurchaseMoneyAPIServices.moneyReceived(id: id).then((data) {
      Get.back();
      Get.snackbar('Message', data!,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16));
    });
    EasyLoading.dismiss();
    getAllData();
  }
}
