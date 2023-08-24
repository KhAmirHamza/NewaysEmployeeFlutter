// ignore_for_file: unused_field, file_names

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:neways3/src/features/login/components/LoginPreviousScreen.dart';
import 'package:neways3/src/features/login/components/LoginScreen.dart';
import 'package:neways3/src/features/main/MainPage.dart';
import 'package:store_redirect/store_redirect.dart';

import '../../../utils/constants.dart';
import '../../../utils/functions.dart';
import '../../../utils/httpClient.dart';
import '../../linked_devices/controller/LinkedDeviceController.dart';
import '../../update_apps/UpdateAppsScreen.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashController extends GetxController {
  Socket socket;
  SplashController(this.socket);
  final box = GetStorage();
  late Timer _timer;
  late BuildContext context;
  final QuickActions quickActions = const QuickActions();

  int _time = 2;

  Future<void> startTimer() async {
    Box notificationBox = await openBox(name: "notifications");
    int navigationIndex = notificationBox.get("route", defaultValue: "Workspace")=="Chat"?0:2;
    print("navigationIndex: $navigationIndex");

    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_time == 0) {
          timer.cancel();
          if (box.read('isLogin') == true) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => MainPage(socket, navigationIndex)));
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

    checkExpire();

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
      await httpAuthGet(path: '/check_expire').then((response) async {
        var data = jsonDecode(response.body);
        print("CheckExpire: ${response.body}");
        PackageInfo packageInfo = await PackageInfo.fromPlatform();

        String appName = packageInfo.appName;
        String packageName = packageInfo.packageName;
        String version = packageInfo.version;
        String buildNumber = packageInfo.buildNumber;
        //print("appName: $appName");
        //print("packageName: $packageName");
        //print("version: $version");
        //print("buildNumber: $buildNumber");


        String versionFromAPI =
        data['version'];
         //'1.0.6';

        DateTime expire = DateTime.parse(data['expire']);
        DateTime today = DateTime.now();
        box.write("appVersion",versionFromAPI);
        //print("today: $today");
       // print("expire.difference(today).inDays: ${expire.difference(today).inDays}");
        if (expire.difference(today).inDays < 0 &&
            version != versionFromAPI) {
          //print("Step:1");
          StoreRedirect.redirect();
          // Get.offAll(
          //     UpdateAppsScreen(title: 'ae', version: version)
          // );
        } else if (version != versionFromAPI) {
          //print("Step:2");
          defaultDialog(
            title: "New version $versionFromAPI update available!",
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
                          StoreRedirect.redirect();
                         // Get.to(UpdateAppsScreen(title: '', version: version,));
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
        }else{
          startTimer();
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
