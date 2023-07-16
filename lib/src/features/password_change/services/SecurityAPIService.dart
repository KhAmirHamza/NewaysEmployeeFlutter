import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:neways3/src/utils/httpClient.dart';

class SecurityAPIService {
  static change({required data}) async {
    try {
      var response = await httpAuthPost(path: '/change-password', data: data);
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
