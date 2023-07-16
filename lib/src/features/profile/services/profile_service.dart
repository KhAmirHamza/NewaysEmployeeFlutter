// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:neways3/src/features/profile/models/profile_response_model.dart';
import 'package:neways3/src/utils/httpClient.dart';

class ProfileService {
  static Future me() async {
    final box = GetStorage();
    var response = await httpAuthPost(path: '/me', data: {});
    // print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      return ProfileResponseModel.fromJson(jsonDecode(response.body));
    } else {
      return {"error": "Server Error"};
    }
  }
}
