// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:dio/dio.dart';
import '../models/EmployeeFiredResponse.dart';
import '../models/FiredEmployee.dart';
import 'package:neways3/src/utils/httpClient.dart';

class EmployeeFiredAPIServices {
  static getAllData() async {
    try {
      var response = await httpAuthGet(path: '/employee_fired_list');
      if (response.statusCode == 200) {
        print(response.body);
        return employeeFiredResponseFromJson(response.body);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        return {"error": "Server Error"};
      }
      print(e.response?.statusCode);
    }

    return null;
  }

  static getAllEmployee() async {
    try {
      var response = await httpAuthGet(path: '/dep_employees');
      if (response.statusCode == 200) {
        return firedEmployeeDataFromJson(response.body);
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
          await httpAuthPost(path: '/employee_fired_request', data: data);
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
          await httpAuthGet(path: '/employee_fired_request_delete/$id');
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
}
