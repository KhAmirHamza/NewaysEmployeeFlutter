// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:neways3/src/utils/httpClient.dart';

import '../models/EmergencyWorkResponse.dart';

class EmergencyWorkAPIServices {
  static getAllData() async {
    try {
      var response = await httpAuthGet(path: '/emergency_work_permit');
      if (response.statusCode == 200) {
        print(response.body);
        return emergencyWorkResponseFromJson(response.body);
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
      var response = await httpAuthGet(path: '/employee_emergency_work_permit');
      print(response.body);
      if (response.statusCode == 200) {
        return emergencyWorkResponseFromJson(response.body);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        return {"error": "Server Error"};
      }
      print(e.response?.statusCode);
    }

    return null;
  }

  static depHeadPermit({required data}) async {
    try {
      var response = await httpAuthPost(
          path: '/dep_head_emergency_work_permit', data: data);
      print(response.body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['message'];
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
