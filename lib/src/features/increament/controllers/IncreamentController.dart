import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../models/IncreamentResponse.dart';
import '../services/increament_service.dart';

class IncreamentController extends GetxController {
  List<Increament> data = [];
  @override
  void onInit() async {
    super.onInit();
    await getData();
  }

  getData() async {
    await EasyLoading.show();
    IncreamentService.getData().then((value) {
      if (value is IncreamentResponse) {
        data = [];
        print(value.increaments);
        for (Increament element in value.increaments) {
          data.add(Increament(
              amount: element.amount, data: element.data, status: true));
        }
        for (Increament element in value.decreaments) {
          data.add(Increament(
              amount: element.amount, data: element.data, status: false));
        }
        update();
      }
    });
    update();
    EasyLoading.dismiss();
  }
}
