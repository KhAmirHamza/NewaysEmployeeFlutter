// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:neways3/src/features/leave/models/LeaveRequest.dart';
import 'package:neways3/src/features/leave/models/LeaveResponse.dart';
import 'package:neways3/src/utils/httpClient.dart';

class LeaveAPIServices {
  static getAllData() async {
    try {
      var response = await httpAuthGet(path: '/leave_request');
      if (response.statusCode == 200) {
        print(response.body);
        return leaveResponseFromJson(response.body);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        return {"error": "Server Error"};
      }
      print(e.response?.statusCode);
    }

    return null;
  }

  static submit({required LeaveRequest data}) async {
    try {
      print(data.toJson());
      var response =
          await httpAuthPost(path: '/leave_request', data: data.toJson());
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

  static getPendingData() async {
    try {
      var response = await httpAuthGet(path: '/employee_leave_request');
      print(response.body);
      if (response.statusCode == 200) {
        return leaveResponseFromJson(response.body);
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
          path: '/leave_request_dep_head_update', data: data);
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
