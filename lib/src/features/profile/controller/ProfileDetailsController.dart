import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/profile_response_model.dart';
import '../services/profile_service.dart';

class ProfileDetailsController extends GetxController {
  ProfileResponseModel? profile;
  final box = GetStorage();
  @override
  void onInit() {
    super.onInit();
    getData();
  }

  getData() async {
    EasyLoading.show();
    await ProfileService.me().then((value) {
      if (value is ProfileResponseModel) {
        profile = value;
      } else {
        // error
      }
    });
    update();
    EasyLoading.dismiss();
    return true;
  }
}
