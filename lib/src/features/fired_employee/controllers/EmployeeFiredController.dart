// ignore_for_file: file_names

import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../utils/constants.dart';
import '../models/EmployeeFiredResponse.dart';
import '../models/FiredEmployee.dart';
import '../services/employee_fired_api_services.dart';

class EmployeeFiredController extends GetxController {
  late TabController controller;
  TextEditingController firedReasonController = TextEditingController();
  TextEditingController employeeController = TextEditingController();
  DateTime lastWorkingDate = DateTime.now();
  late List<EmployeeFiredResponse> responses = [];
  late List<EmployeeFiredResponse> responsesPending = [];
  List<SelectedListItem> employees = [];
  late bool isLoadding = false;
  late bool isDataEmpty = false;
  late bool isPendingDataEmpty = false;
  String? message;

  @override
  void onInit() {
    super.onInit();
    getAllData();
    getEmployeeFiredBossPendingList();
  }

  getAllData() async {
    EasyLoading.show();
    isLoadding = true;
    await EmployeeFiredAPIServices.getAllData().then((data) {
      if (data.runtimeType == List<EmployeeFiredResponse>) {
        responses = data;
        isDataEmpty = data.isEmpty;
      }
    });
    EasyLoading.dismiss();
    isLoadding = false;
    update();
  }

  getEmployeeFiredBossPendingList() async {
    EasyLoading.show();
    isLoadding = true;
    await EmployeeFiredAPIServices.getEmployeeFiredBossPendingList().then((data) {
      if (data.runtimeType == List<EmployeeFiredResponse>) {
        responsesPending = data;
        isPendingDataEmpty = data.isEmpty;
      }
    });
    EasyLoading.dismiss();
    isLoadding = false;
    update();
  }

  getEmployee() async {
    EasyLoading.show();
    isLoadding = true;
    await EmployeeFiredAPIServices.getAllEmployee().then((data) {
      if (data.runtimeType == List<Employee>) {
        for (Employee element in data) {
          employees.add(SelectedListItem(
              name: element.fullName, value: element.id.toString()));
        }
      }
    });
    EasyLoading.dismiss();
    isLoadding = false;

    update();
  }

  delete(id) async {
    EasyLoading.show();
    await EmployeeFiredAPIServices.delete(id: id).then((data) {
      Get.back();
      print(data);
      Get.snackbar('Message', data,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16));
    });
    EasyLoading.dismiss();
    getAllData();
  }

  submitRequest() async {
    if (employeeController.text.isEmpty) {
      Get.snackbar('Success', "Employee must be required",
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full));
      return false;
    } else if (firedReasonController.text.isEmpty) {
      Get.snackbar('Success', "Fired reason must be required",
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full));
      return false;
    }
    EasyLoading.show();
    isLoadding = true;
    await EmployeeFiredAPIServices.submit(
      data: {
        "employee_id": employeeController.text.split(' - ')[0],
        "reason": firedReasonController.text,
        "last_working_date": lastWorkingDate.toString(),
      },
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
    lastWorkingDate = DateTime.now();
    firedReasonController.clear();
  }



  action(String status, EmployeeFiredResponse response) async {
    EasyLoading.show();
    await EmployeeFiredAPIServices.update(id: response.id, status: status).then((msg) {
      Get.snackbar('Message', msg,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full));
    });
    EasyLoading.dismiss();
    await getAllData();
    update();
  }
}
