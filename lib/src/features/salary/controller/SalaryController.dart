// ignore_for_file: file_names

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:neways3/src/features/salary/models/salary_response_model.dart';
import 'package:neways3/src/features/salary/services/salary_service.dart';

class SalaryController extends GetxController {
  List<SalaryResponseModel> salaries = [];
  final box = GetStorage();
  @override
  void onInit() {
    super.onInit();
    getAllSalary();
  }

  getAllSalary() async {
    EasyLoading.show();
    await SalaryService.salaries().then((value) {
      if (value is List<SalaryResponseModel>) {
        salaries = value;
      } else {
        // error
      }
    });
    update();
    EasyLoading.dismiss();
    return true;
  }
}
