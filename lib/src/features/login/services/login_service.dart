import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:neways3/src/features/login/models/login_request_model.dart';
import 'package:neways3/src/features/login/models/login_response_model.dart';
import 'package:neways3/src/utils/httpClient.dart';

class LoginService {
  static Future login(LoginRequestModel data) async {
    try {
      var response = await httpPost(path: '/login', data: data.toJson());
      if (response.statusCode == 200) {
        return LoginResponseModel.fromJson(jsonDecode(response.body));
      } else {
        return {"error": "Unauthorized user: ${response.body.toString()}"};
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        return {"error": "Server Error"};
      }
      // ignore: avoid_print
      print(e.response?.statusCode);
    }
  }

  static Future setDiviceInfo({data}) async {
    try {
      var response =
          await httpAuthPost(path: '/set_login_divice_info', data: data);
      if (response.statusCode == 200) {
        return true;
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

  static Future sendOtp({required employeeId}) async {
    try {
      var response = await httpGet(
        path: '/send-otp/$employeeId',
      );
      print(response.body);
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

  static Future forgotPassword(data) async {
    try {
      var response = await httpPost(path: '/forgot-password', data: data);
      print(response.body);
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['message'];
      } else {
        return jsonDecode(response.body)['error'];
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
