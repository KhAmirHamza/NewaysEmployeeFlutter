// ignore_for_file: unused_field, file_names

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:neways3/src/features/login/components/LoginPreviousScreen.dart';
import 'package:neways3/src/features/login/components/LoginScreen.dart';
import 'package:neways3/src/features/main/MainPage.dart';

import '../../../utils/constants.dart';
import '../../../utils/functions.dart';
import '../../../utils/httpClient.dart';
import '../../linked_devices/controller/LinkedDeviceController.dart';
import '../../update_apps/UpdateAppsScreen.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class SplashController extends GetxController {
  Socket socket;
  SplashController(this.socket);
  final box = GetStorage();
  late Timer _timer;
  late BuildContext context;
  final QuickActions quickActions = const QuickActions();

  int _time = 2;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_time == 0) {
          timer.cancel();
          if (box.read('isLogin') == true) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => MainPage(socket, 2)));
            // Get.off(const MainPage(), transition: Transition.rightToLeft);
          } else {
            Navigator.pushReplacement(context,
              //  MaterialPageRoute(builder: (context) => const LoginScreen()));
                MaterialPageRoute(builder: (context) => const LoginPreviousScreen()));
            // Get.off(const LoginScreen(), transition: Transition.rightToLeft);
          }
        } else {
          _time--;
        }
      },
    );
    update();
  }

  @override
  void onInit() {
    super.onInit();
    // FirebaseMessaging.instance.getToken().then((value) {
    //   box.write('device_token', value);
    // });
    _quickAction();
    startTimer();
    //checkExpire();
  }

  _quickAction() {
    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
          type: 'linked_device',
          localizedTitle: 'Link a device',
          icon: 'qr_code_scanner')
    ]);
    quickActions.initialize((String shortcutType) {
      if (shortcutType == "linked_device") {
        if (box.read('isLogin') == true) {
          Get.put(LinkedDeviceController()).scanQR();
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
          Get.snackbar('Message', "Required to login first for link a device!",
              snackPosition: SnackPosition.BOTTOM,
              margin: EdgeInsets.all(DPadding.full));
        }
      }
    });
  }

  setContext(value) {
    context = value;
    update();
  }

  checkExpire() async {
    try {
      await httpAuthGet(path: '/check_expire').then((response) {
        var data = jsonDecode(response.body);
        DateTime expire = DateTime.parse(data['expire']);
        DateTime today = DateTime.now();
        box.write("appVersion", data['version']);
        if (expire.difference(today).inDays < 0 &&
            appVersion != data['version']) {
          Get.offAll(const UpdateAppsScreen(title: 'ae'));
        } else if (appVersion != data['version']) {
          defaultDialog(
            title: "New version ${data['version']} update available!",
            okPress: () async {
              Get.back();
            },
            isAction: false,
            widget: Column(
              children: [
                Wrap(
                  spacing: 8,
                  children: [
                    TextButton(
                        onPressed: () {
                          Get.back();
                          Get.to(const UpdateAppsScreen(title: ''));
                        },
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.green,
                            padding:
                                EdgeInsets.symmetric(horizontal: DPadding.full),
                            backgroundColor: Colors.green.withOpacity(0.2)),
                        child: const Text('Update')),
                    TextButton(
                        onPressed: () => Get.back(),
                        style: TextButton.styleFrom(
                            foregroundColor: DColors.highLight,
                            padding:
                                EdgeInsets.symmetric(horizontal: DPadding.full),
                            backgroundColor:
                                DColors.highLight.withOpacity(0.2)),
                        child: const Text('Not Now')),
                  ],
                ),
              ],
            ),
          );
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
