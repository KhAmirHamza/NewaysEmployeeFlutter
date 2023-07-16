// ignore_for_file: file_names

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:neways3/src/features/wallet/services/wallet_service.dart';
import 'package:neways3/src/features/wallet/models/wallet_response_model.dart';

import '../models/current_salary_response_model.dart';

class WalletController extends GetxController {
  WalletResponseModel wallet = WalletResponseModel(attend: 0, basicSalary: 0);
  CurrentSalaryResponseModel currentSalary = CurrentSalaryResponseModel(
      attend: 0, basicSalary: 0, increament: 0, decreament: 0);
  @override
  void onInit() {
    super.onInit();
    getWallet();
  }

  getWallet() async {
    EasyLoading.show();
    await WalletService.currentSalary().then((value) {
      if (value.runtimeType == CurrentSalaryResponseModel) {
        currentSalary = value;
      } else {
        // error...
      }
      return true;
    });
    // await WalletService.wallet().then((value) {
    //   if (value.runtimeType == WalletResponseModel) {
    //     wallet = value;
    //   } else {
    //     // error...
    //   }
    //   return true;
    // });
    EasyLoading.dismiss();
    update();
  }
}
