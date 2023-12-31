// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:neways3/src/utils/httpClient.dart';

import '../models/AdvanceSalaryResponse.dart';

class AdvanceSalaryAPIServices {
  static getAllData() async {
    try {
      var response = await httpAuthGet(path: '/advance_salary');
     // print(response.body);
      if (response.statusCode == 200) {
        return advanceSalaryResponseFromJson(response.body);
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
      var response = await httpAuthPost(path: '/advance_salary', data: data);
    //  print(response.body);
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
      var response = await httpAuthGet(path: '/employee_advance_salary');
     // print(response.body);
      if (response.statusCode == 200) {
        return advanceSalaryResponseFromJson(response.body);
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        return {"error": "Server Error"};
      }
      print(e.response?.statusCode);
    }

    return null;
  }

  static depHeadApprove({required data}) async {
    try {
      var response = await httpAuthPost(
          path: '/advance_salary_dep_head_approve', data: data);
     // print(response.body);
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

  static depHeadReject({required data}) async {
    try {
      var response = await httpAuthPost(
          path: '/advance_salary_dep_head_reject', data: data);
     // print(response.body);
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


  static dHeadAndBossApproval({required String action, required List<int> ids, required String note}) async {
    try {
      //print("request data");
      //print(ids.toString());
      //print(action.toString());
      //print(note.toString());
      //return;
      var response = await httpAuthPost(path: '/advance_salary_dhead_and_boss_approval/$action', data: {'ids': jsonEncode(ids), 'note': note});
      //print("response.body");
     // print(response.body);
      if (response.statusCode == 200) {
        //print("response");
        //print(response.body);
        return jsonDecode(response.body)['message'];
      } else if (response.statusCode == 401) {
        return jsonDecode(response.body)['error'];
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return {"error": "Server Error"};
      }
      print(e.response?.statusCode);
    }
    return null;
  }
}
