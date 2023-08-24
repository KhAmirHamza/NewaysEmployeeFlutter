import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:neways3/src/utils/functions.dart';

class NotificationController extends GetxController {
  late Box box;
  List notifications = [];
  bool isLoading = false;
  @override
  void onInit() async {
    super.onInit();
    box = await openBox(name: "notifications");
    await getNofification();
  }

  getNofification() {
    var data = box.toMap().values.toList();
    notifications = [];
    for (var element in data) {
      notifications.add(element);
    }
    //print(notifications);
    isLoading = false;
    update();
  }
}
