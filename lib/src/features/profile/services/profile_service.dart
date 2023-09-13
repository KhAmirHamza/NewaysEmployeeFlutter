// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:neways3/src/features/login/models/Holiday.dart';
import 'package:neways3/src/features/profile/models/profile_response_model.dart';
import 'package:neways3/src/utils/httpClient.dart';

class ProfileService {
  static Future me() async {
    final box = GetStorage();
    var response = await httpAuthPost(path: '/me', data: {});
    box.write('assign_group', jsonDecode(response.body)['assign_group']);
    print('Response body: ${box.read('assign_group')}');

    if (response.statusCode == 200) {
      return ProfileResponseModel.fromJson(jsonDecode(response.body));
    } else {
      return {"error": "Server Error"};
    }
  }


  static Future getHolidays() async {
    try {
      var response = await httpAuthGet(path: '/get_holidays');
      //print("HolidayData: 1");
     // print(response.body);
      if (response.statusCode == 200) {
        //print("HolidayData: 2");
       //print(response.body);
       return List<Holiday>.from(jsonDecode(response.body)['holidays'].map((element)=>  Holiday.fromJson(element)));
      } else {
        return {"error": "Unauthorized user: ${response.body.toString()}"};
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
