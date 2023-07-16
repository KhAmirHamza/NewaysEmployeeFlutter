// ignore_for_file: deprecated_member_use, no_logic_in_create_state, library_private_types_in_public_api

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:neways3/src/utils/appbar.dart';
import 'package:neways3/src/utils/constants.dart';
import 'package:better_open_file/better_open_file.dart';
// import 'package:open_file/open_file.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as path;

import '../../utils/size_config.dart';

class UpdateAppsScreen extends StatefulWidget {
  final String title;
  const UpdateAppsScreen({super.key, required this.title});

  @override
  _UpdateAppsScreenState createState() => _UpdateAppsScreenState(title);
}

class _UpdateAppsScreenState extends State<UpdateAppsScreen> {
  final String title;
  _UpdateAppsScreenState(this.title);

  final Dio _dio =
      Dio(BaseOptions(connectTimeout: const Duration(seconds: 5000)));
  final String _fileUrl =
      'http://erp.superhomebd.com/neways_employee_mobile_application/assets/apps/Neways3.apk';
  final String _fileName = "Neways3.apk";
  String btnText = 'Download';
  bool downloading = false;
  var storage = GetStorage();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  double _progress = 0;
  final android = const AndroidNotificationDetails(
      'appsDownload', //channel id
      'Download', //channel name
      priority: Priority.high,
      importance: Importance.max);

  @override
  void initState() {
    super.initState();
    systemUi();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      const initSettings = InitializationSettings(
          android: android, iOS: DarwinInitializationSettings());
      flutterLocalNotificationsPlugin.initialize(initSettings);
    });
    _requestPermissions();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  systemUi() {
    setState(() {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor: DColors.primary,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.title == 'ae'
          ? AppBar(
              leading: const SizedBox(),
              title: const Text("Update System"),
              centerTitle: true,
            )
          : buildAppBar(title: "Update System"),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const HeightSpace(),
            Image.asset(
              "assets/images/expire.png",
              height: Get.size.height * 0.4, //40%
            ),
            SizedBox(height: Get.size.height * 0.08),
            Text(
              widget.title == 'ae'
                  ? "Application Version Expired! Please Update"
                  : "Check & Update Application To Latest Version ! Click The Button Below",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: getProportionateScreenWidth(18),
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Spacer(),
            SizedBox(
                width: Get.size.width,
                height: 45,
                child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: DColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(DPadding.full * 2))),
                    onPressed: () {
                      if (storage.read('appVersion') != appVersion &&
                          !downloading)
                        _download();
                      else if (downloading) {
                        Get.snackbar('Warning',
                            'Oops! Application is downloading the latest version',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.orange,
                            colorText: Colors.white,
                            margin: EdgeInsets.all(DPadding.full));
                      } else {
                        Get.snackbar('Updated',
                            'Congratulations! Application is running on the latest version',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                            margin: EdgeInsets.all(DPadding.full));
                      }
                    },
                    child: Text(btnText))),
            Spacer(),
          ],
        ),
      )),
    );
  }

  Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      var path;
      await getExternalStorageDirectory().then((value) => path = value);
      return path;
    }
    return await getApplicationDocumentsDirectory();
  }

  Future<bool> _requestPermissions() async {
    var permission = await Permission.storage.status;
    if (permission.isDenied) {
      await [
        Permission.storage,
      ].request();
    }
    return permission == PermissionStatus.granted;
  }

  void _onReceiveProgress(int received, int total) {
    if (total != -1) {
      setState(() {
        _progress = (received / total * 100);
        btnText = 'Downloading ${_progress.toStringAsFixed(0)}%';
      });
    }
    if (_progress == 100) {
      setState(() => btnText = 'Install');
    }
    ;
  }

  Future _onSelectNotification(String json) async {
    final obj = jsonDecode(json);

    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: Text('${obj['error']}'),
        ),
      );
    }
  }

/*  Future<void> _showProgressNotification(double c) async {
      await Future<void>.delayed(const Duration(seconds: 1), () async {
        final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('channel id',
            'channel name',
            'channel description',
            channelShowBadge: false,
            importance: Importance.max,
            priority: Priority.high,
            onlyAlertOnce: true,
            showProgress: true,
            maxProgress: 100,
            progress: int.parse(c.toStringAsFixed(0)));
        final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(
            0,
            'progress notification title',
            'progress notification body',
            platformChannelSpecifics,
            payload: 'item x');
      });
  }*/

  Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
    const iOS = DarwinNotificationDetails();
    final platform = NotificationDetails(android: android, iOS: iOS);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];

    await flutterLocalNotificationsPlugin.show(
        0, // notification id
        isSuccess ? 'Success' : 'Failure',
        isSuccess
            ? 'Update has been downloaded successfully!'
            : 'There was an error while downloading the update.',
        platform,
        payload: json);
  }

  Future<void> _startDownload(String savePath) async {
    await EasyLoading.show(
      status: 'Loading',
      maskType: EasyLoadingMaskType.black,
    );
    setState(() => downloading = true);
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };
    print(_fileUrl);
    print(savePath);
    try {
      EasyLoading.dismiss();
      final response = await _dio.download(_fileUrl, savePath,
          onReceiveProgress: _onReceiveProgress);
      print(response.data);
      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;
    } on DioError catch (e) {
      print(e.message);
      if (e.type == DioErrorType.unknown) {
        EasyLoading.dismiss().whenComplete(() {
          // snackBarHttpResponse(context, 001)
        });
      } else {
        EasyLoading.dismiss().whenComplete(() {
          // snackBarHttpResponse(context, 408)
        });
      }
    } catch (ex) {
      result['error'] = ex.toString();
      setState(() => btnText = 'Download');
    } finally {
      await _showNotification(result);
    }
    setState(() => downloading = false);
  }

  Future<void> _download() async {
    if (Platform.isIOS) {
      String _url = storage.read('ioslink');
      await canLaunch(_url)
          ? await launch(_url, forceSafariVC: false, forceWebView: false)
          : throw 'Could not download, visit Neways3 Store';
    } else {
      final dir = await _getDownloadDirectory();
      final isPermissionStatusGranted = await _requestPermissions();

      if (isPermissionStatusGranted) {
        final savePath = path.join(dir.path, _fileName);
        if (_progress == 100) {
          print(savePath);
          await OpenFile.open(savePath);
        } else {
          await _startDownload(savePath);
        }
      }
    }
  }
}
