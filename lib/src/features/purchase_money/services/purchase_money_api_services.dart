// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neways3/src/utils/constants.dart';
import '../models/PurchaseMoneyRequest.dart';
import '../models/PurchaseMoneyResponse.dart';
import '../models/PurchaseMoneyRequestData.dart';
import 'package:neways3/src/utils/httpClient.dart';

class PurchaseMoneyAPIServices {
  static getAllData() async {
    try {
      var response = await httpAuthGet(path: '/purchase_money_request');
      if (response.statusCode == 200) {
        return purchaseMoneyResponseFromJson(response.body);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        return {"error": "Server Error"};
      }
      print(e.response?.statusCode);
    }

    return null;
  }

  static getAllPurchaseMoneyRequestData() async {
    try {
      var response = await httpAuthGet(path: '/purchase_money_request_data');
      if (response.statusCode == 200) {
        return purchaseMoneyRequestDataFromJson(response.body);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        return {"error": "Server Error"};
      }
      print(e.response?.statusCode);
    }

    return null;
  }

  static submit({required data}) async {
    try {
      var response =
          await httpAuthPost(path: '/purchase_money_request', data: data);
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['message'];
      } else if (response.statusCode == 401) {
        return jsonDecode(response.body)['error'];
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        return {"error": "Server Error"};
      }
      print(e.response?.statusCode);
    }

    return null;
  }

  static reSubmit({required data}) async {
    print(data);
    try {
      var response = await httpAuthPost(
          path: '/purchase_money_resubmit_request', data: data);
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['message'];
      } else if (response.statusCode == 401) {
        return jsonDecode(response.body)['error'];
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        return {"error": "Server Error"};
      }
      print(e.response?.statusCode);
    }

    return null;
  }

  static update({required id, required amount}) async {
    try {
      var response =
          await httpAuthGet(path: '/purchase_money_request_update/$id/$amount');
      print(response.body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['message'];
      } else if (response.statusCode == 401) {
        return jsonDecode(response.body)['error'];
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        return {"error": "Server Error"};
      }
      print(e.response?.statusCode);
    }

    return null;
  }

  static delete({required id}) async {
    try {
      var response =
          await httpAuthGet(path: '/purchase_money_request_delete/$id');
      print(response.body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['message'];
      } else if (response.statusCode == 401) {
        return jsonDecode(response.body)['error'];
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        return {"error": "Server Error"};
      }
      print(e.response?.statusCode);
    }

    return null;
  }

  static moneyReceived({required id}) async {
    try {
      var response =
          await httpAuthGet(path: '/purchase_money_request_money_received/$id');
      print(response.body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['message'];
      } else if (response.statusCode == 401) {
        return jsonDecode(response.body)['error'];
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        return {"error": "Server Error"};
      }
      print(e.response?.statusCode);
    }

    return null;
  }

  static getPendingData() async {
    try {
      var response =
          await httpAuthGet(path: '/employee_purchase_money_request');
      print(response.body);
      if (response.statusCode == 200) {
        return purchaseMoneyResponseFromJson(response.body);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        return {"error": "Server Error"};
      }
      print(e.response?.statusCode);
    }

    return null;
  }

  static leaveRequestDepHeadUpdate({required data}) async {
    try {
      var response = await httpAuthPost(
          path: '/purchase_money_request_dep_head_update', data: data);
      print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        Get.snackbar('Error', jsonDecode(response.body)['message'],
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.all(DPadding.full));
        return true;
      } else if (response.statusCode == 401) {
        Get.snackbar('Error', jsonDecode(response.body)['error'],
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.all(DPadding.full));
        return false;
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        return {"error": "Server Error"};
      }
      print(e.response?.statusCode);
    }

    return null;
  }
}
