import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../utils/httpClient.dart';
import '../models/EmployeeResignResponse.dart';

class ResignAPIService {
  static submit({required data}) async {
    try {
      var response =
          await httpAuthPost(path: '/employee_self_resign_request', data: data);
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

  static getAllData() async {
    try {
      var response = await httpAuthGet(path: '/employee_resign_list');
      if (response.statusCode == 200) {
        print(response.body);
        return employeeResignResponseFromJson(response.body);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        return {"error": "Server Error"};
      }
      print(e.response?.statusCode);
    }

    return null;
  }

  static update({required id, required status}) async {
    try {
      var response = await httpAuthPost(
          path: '/employee_resign_request_dep_head_update',
          data: {"resign_req_id": id.toString(), "approve_resign": status});
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
}
