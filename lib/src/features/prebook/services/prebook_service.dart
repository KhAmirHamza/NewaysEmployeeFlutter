import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:neways3/src/features/prebook/models/Prebook.dart';
import 'package:neways3/src/utils/httpClient.dart';
import 'package:http/http.dart' as http;

class PrebookService{
  static Future prebookEmployee(Prebook data) async {
    try {
      print("Prebook Employee Data: ${data.toJson()}");

      var response = await httpPost(path: '/prebook', data: data.toJson());
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        return Prebook.fromJson(jsonDecode(response.body));
      } else {
        print(response.body);
        return {"error": "Unable to Prebook Employee"};
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return {"error": "Server Error"};
      }
      // ignore: avoid_print
      print(e.response?.statusCode);
    }
  }
}