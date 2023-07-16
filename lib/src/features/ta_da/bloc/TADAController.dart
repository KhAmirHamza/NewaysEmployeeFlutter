import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../../utils/constants.dart';
import '../models/TADAResponse.dart';
import '../services/TADAAPIServices.dart';

class TADAController extends GetxController {
  List<SelectedListItem> locations = [
    SelectedListItem(name: "Corporate Office"),
    SelectedListItem(name: "Super Hostel 3"),
    SelectedListItem(name: "Super Hostel 4"),
    SelectedListItem(name: "Super Hostel 5"),
    SelectedListItem(name: "Super Hostel 6"),
    SelectedListItem(name: "Super Hostel 7"),
    SelectedListItem(name: "Super Hostel 8"),
    SelectedListItem(name: "Super Hostel 9"),
    SelectedListItem(name: "Super Hostel 10"),
    SelectedListItem(name: "Super Hostel 11"),
    SelectedListItem(name: "Super Hostel 12"),
    SelectedListItem(name: "Other"),
  ];
  List<SelectedListItem> transportType = [
    SelectedListItem(name: "One Way"),
    SelectedListItem(name: "Up Down"),
  ];
  List<SelectedListItem> transportList = [
    SelectedListItem(name: "Bus"),
    SelectedListItem(name: "Riksha"),
    SelectedListItem(name: "CNG"),
    SelectedListItem(name: "Pathaw"),
    SelectedListItem(name: "Ubar"),
    SelectedListItem(name: "Vane"),
    SelectedListItem(name: "Truck"),
  ];

  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  TextEditingController transportAmountController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TextEditingController transportTypeController = TextEditingController();
  TextEditingController foodAmountController = TextEditingController();
  TextEditingController transportationDetailController =
      TextEditingController();
  TextEditingController vehicleTypeController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController vehicleTypeReasonController = TextEditingController();
  String message = '';
  List<TadaResponse> responses = [];

  @override
  void onInit() {
    super.onInit();
    getAllData();
  }

  getAllData() async {
    EasyLoading.show();
    await TADAAPIServices.getAllData().then((data) {
      print(data);
      if (data.runtimeType == List<TadaResponse>) {
        responses = data;
      }
    });
    EasyLoading.dismiss();

    update();
  }

  submit() async {
    if (fromController.text.isEmpty) {
      Get.snackbar('Wrong', "Destination from must be required",
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full));
      return false;
    } else if (toController.text.isEmpty) {
      Get.snackbar('Wrong', "Destination To must be required",
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full));
      return false;
    } else if (transportAmountController.text.isEmpty) {
      Get.snackbar('Wrong', "Transport amount must be required",
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full));
      return false;
    } else if (transportTypeController.text.isEmpty) {
      Get.snackbar('Wrong', "Transport type must be required",
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full));
      return false;
    } else if (vehicleTypeController.text.isEmpty) {
      Get.snackbar('Wrong', "Vehicle type must be required",
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full));
      return false;
    }
    EasyLoading.show();
    await TADAAPIServices.submit(
      data: {
        "transport_date":
            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
        "destination_from": fromController.text,
        "destination_to": toController.text,
        "transport_type": transportTypeController.text,
        "transport_details": transportationDetailController.text,
        "transport_amount": transportAmountController.text,
        "food_amount": foodAmountController.text,
        "vehicle_type": vehicleTypeController.text,
        "vehicle_type_reason": vehicleTypeReasonController.text,
        "note": noteController.text,
      },
    ).then((data) async {
      print(data);
      message = data;
      await getAllData();
    });
    EasyLoading.dismiss();
    clear();
    update();
    return true;
  }

  delete(id) async {
    EasyLoading.show();
    await TADAAPIServices.delete(id: id).then((data) {
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
    await TADAAPIServices.moneyReceived(id: id).then((data) {
      Get.back();
      Get.snackbar('Message', data!,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16));
    });
    EasyLoading.dismiss();
    getAllData();
  }

  clear() {
    fromController.clear();
    toController.clear();
    transportAmountController.clear();
    selectedDate = DateTime.now();
    transportTypeController.clear();
    foodAmountController.clear();
    transportationDetailController.clear();
    vehicleTypeController.clear();
    noteController.clear();
    vehicleTypeReasonController.clear();
  }
}
