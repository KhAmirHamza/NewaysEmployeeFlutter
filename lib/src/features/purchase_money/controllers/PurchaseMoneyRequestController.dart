// ignore_for_file: file_names

import 'dart:convert';

import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:neways3/src/utils/constants.dart';
import '../models/PurchaseMoneyRequestData.dart';
import '../models/PurchaseMoneyResponse.dart';
import '../services/purchase_money_api_services.dart';

class PurchaseMoneyRequestController extends GetxController {
  late bool isLoadding = false;
  TextEditingController projectController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController purposeController = TextEditingController();
  TextEditingController employeeController = TextEditingController();
  TextEditingController itemController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  List<SelectedListItem> items = [];
  List<SelectedListItem> employees = [];
  List purchaseItems = [];
  dynamic id;
  bool isEmployee = false;
  bool isUpdate = false;
  String? message;

  @override
  void onInit() {
    super.onInit();
    getAllData();
  }

  getAllData() async {
    EasyLoading.show();
    isLoadding = true;
    await PurchaseMoneyAPIServices.getAllPurchaseMoneyRequestData()
        .then((data) {
      if (data.runtimeType == PurchaseMoneyRequestData) {
        for (RequestProduct element in data.products) {
          items.add(SelectedListItem(
              name: element.name, value: element.id.toString()));
        }
        for (Employee element in data.employees) {
          employees.add(SelectedListItem(
              name: element.fullName, value: element.id.toString()));
        }
      }
    });
    EasyLoading.dismiss();
    isLoadding = false;

    update();
  }

  setPurchaseItem() {
    if (itemController.text.isEmpty) {
      Get.snackbar('Success', "Item must be required",
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full));
      return false;
    } else if (qtyController.text.isEmpty) {
      Get.snackbar('Success', "Quantity must be required",
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full));
      return false;
    }
    // purchaseItems.

    purchaseItems.add({
      "id": itemController.text.split(' - ')[0],
      "name": itemController.text.split(' - ')[1],
      "quantity": qtyController.text,
    });
    itemController.clear();
    qtyController.clear();
    update();
    Get.back();
    return true;
  }

  customDate({DateTime? date, required int day}) {
    date = date ?? DateTime.now();
    return DateTime(date.year, date.month, date.day + day);
  }

  submitRequest() async {
    if (projectController.text.isEmpty) {
      Get.snackbar('Wrong', "Project Name must be required",
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full));
      return false;
    } else if (projectController.text.length>30) {
      Get.snackbar('Wrong', "Project Name must be within 30 Characters",
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full));
      return false;
    } else if (amountController.text.isEmpty) {
      Get.snackbar('Wrong', "Amount must be required",
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full));
      return false;
    }
    // else if (purposeController.text.isEmpty) {
    //   Get.snackbar('Wrong', "Money purpose must be required",
    //       snackPosition: SnackPosition.BOTTOM,
    //       margin: EdgeInsets.all(DPadding.full));
    //   return false;
    // }
    else if (purchaseItems.isEmpty) {
      Get.snackbar('Wrong', "At least one item must be required",
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full));
      return false;
    }
    EasyLoading.show();
    isLoadding = true;
    await PurchaseMoneyAPIServices.submit(
      data: {
        "amount": amountController.text,
        "note": "", //purposeController.text
        "projectName": projectController.text,
        "employee": employeeController.text.split(" - ")[0],
        "products": jsonEncode(purchaseItems)
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

  setEmployee(value) {
    isEmployee = value;
    if (isEmployee) {
      amountController.text = '0';
    }
    update();
  }

  Future pickDate(BuildContext context, {DateTime? initialDate}) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      // firstDate: DateTime.now().subtract(const Duration(days: 0)),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year, DateTime.now().month,
          DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day),
    );

    if (newDate == null) return;
    // return '${date.day}/${date.month}/${date.year}';
    // startDate = newDate;
    update();
    return newDate;
  }

  setResubmitData(PurchaseMoneyResponse data) {
    purchaseItems = [];
    id = data.id;
    projectController.text = data.projectName.toString();
    amountController.text = data.requestAmount.toString();
    purposeController.text = data.note.toString();
    employeeController.text = data.projectName.toString();
    for (var element in data.products) {
      purchaseItems.add({
        "id": element.id,
        "name": element.name,
        "quantity": element.requestedQty,
      });
    }
    isUpdate = true;
    update();
  }

  reSubmitRequest() async {
    if (projectController.text.isEmpty) {
      Get.snackbar('Wrong', "Project Name must be required",
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full));
      return false;
    } else if (amountController.text.isEmpty) {
      Get.snackbar('Wrong', "Amount must be required",
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full));
      return false;
    } else if (purposeController.text.isEmpty) {
      Get.snackbar('Wrong', "Money purpose must be required",
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full));
      return false;
    }
    EasyLoading.show();
    isLoadding = true;
    await PurchaseMoneyAPIServices.reSubmit(
      data: {
        "id": id.toString(),
        "amount": amountController.text,
        "note": purposeController.text,
        "projectName": projectController.text,
        "products": jsonEncode(purchaseItems)
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
    amountController.clear();
    purposeController.clear();
    projectController.clear();
    employeeController.clear();
    purchaseItems = [];
    isUpdate = false;
  }
}
