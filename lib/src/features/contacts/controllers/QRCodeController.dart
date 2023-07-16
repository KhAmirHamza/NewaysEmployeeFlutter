// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:neways3/src/features/contacts/models/employee_response_model.dart';
import 'package:neways3/src/features/contacts/services/contact_service.dart';
import 'package:neways3/src/utils/constants.dart';
import 'package:neways3/src/utils/functions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class QRCodeController extends GetxController {
  final qrKey = GlobalKey();
  bool isLoading = false;

  void takeScreenShot() async {
    isLoading = true;
    update();
    PermissionStatus res;
    res = await Permission.storage.request();
    if (res.isGranted) {
      final boundary =
          qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      // We can increse the size of QR using pixel ratio
      final image = await boundary.toImage(pixelRatio: 5.0);
      final byteData = await (image.toByteData(format: ImageByteFormat.png));
      if (byteData != null) {
        final pngBytes = byteData.buffer.asUint8List();
        // getting directory of our phone
        final directory = (await getApplicationDocumentsDirectory()).path;
        final imgFile = File(
            '$directory/${DateTime.now()}${GetStorage().read('name')}.png');
        imgFile.writeAsBytes(pngBytes);
        GallerySaver.saveImage(imgFile.path).then((success) async {
          isLoading = false;
          update();
          Get.snackbar("Success", "QR Code image saving to gallery",
              snackPosition: SnackPosition.BOTTOM,
              margin: EdgeInsets.all(DPadding.full),
              backgroundColor: Colors.black,
              colorText: Colors.white);
          //In here you can show snackbar or do something in the backend at successfull download
        });
      }
    }
  }

  Future<void> scanQR() async {
    print("Call ....................");
    String qrCodeScanRes;
    try {
      qrCodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);

      var result = stringToMap(qrCodeScanRes);
      EmployeeResponseModel employee = EmployeeResponseModel(
          employeeId: result['employeeId'],
          fullName: result['name'],
          photo: result['avatar'],
          designationName: result['designation']);
      await ContactService.addContact(employee).then((value) {
        // if (value.runtimeType == ConversationModel) {
        //   // Get.back();
        //   Get.to(IndividualChatScreen(user: value));
        // } else {
        //   print(value);
        // }
      });
    } on PlatformException {
      qrCodeScanRes = 'Failed to get platform version.';
    }
    // if (!mounted) return;

    // scanQRcode = qrCodeScanRes;
    update();
    return;
  }
}
