import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:neways3/src/utils/functions.dart';

import '../../../utils/constants.dart';
import '../../../utils/httpClient.dart';

class LinkedDeviceService {
  static Future desktopLogin(token) async {
    final box = GetStorage();
    Map<String, String>? headers = {
      "accept": "application/json",
      "authorization": "Bearer ${box.read('token')}"
    };
    var response =
        await httpAuthPost(path: '/app-login', data: {"token": token});
    if (response.statusCode == 200) {
      playScanSound();
      Get.snackbar("Success", "Login Successfully by QR Code",
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full),
          backgroundColor: Colors.black54,
          colorText: Colors.white);
    } else if (response.statusCode == 401) {
      Get.snackbar("Success", jsonDecode(response.body)["message"],
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(DPadding.full),
          backgroundColor: Colors.black54,
          colorText: Colors.white);
    } else {
      return {"error": "Server Error"};
    }
  }

  static Future getLoginDivice() async {
    try {
      var response = await httpAuthGet(path: '/login_divice_list');
      print(jsonDecode(response.body)['data']);
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      } else {
        return null;
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        return null;
      }
      // ignore: avoid_print
      print(e.response?.statusCode);
    }
    return null;
  }

  static Future logoutDivice({data}) async {
    try {
      var response = await httpAuthPost(path: '/logout_divice', data: data);
      if (response.statusCode == 200) {
        Get.snackbar("Success", "Successfull divice logout",
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.all(DPadding.full),
            backgroundColor: Colors.black54,
            colorText: Colors.white);
      } else {
        return false;
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        return {"error": "Server Error"};
      }
      // ignore: avoid_print
      print(e.response?.statusCode);
    }
  }

  static Future checkLogin({data}) async {
    try {
      var response = await httpAuthPost(path: '/check_login', data: data);
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return false;
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        return {"error": "Server Error"};
      }
      // ignore: avoid_print
      print(e.response?.statusCode);
    }
  }
}
