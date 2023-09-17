import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:neways3/src/features/workplace/model/EmployeeLocation.dart';

import '../../../utils/httpClient.dart';

class MyLocationService{

  static updateLocation({required data}) async {
    try {
      var response = await httpAuthPost(path: '/update_location',
          data: data);
      if (response.statusCode == 200) {
        if(jsonDecode(response.body)['message']!=null) {
          return jsonDecode(response.body)['message'];
        }else{
          return {"message": "Something Went Wrong"};
        }
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return {"error": "Server Error"};
      }
      print(e.response?.statusCode);
    }
    return null;
  }


  static getLocations({ String? employeeId, int skip = 0, int limit = 20}) async {
    print('getLocations called');
    try {
      var response;
      if(employeeId!=null && employeeId.isNotEmpty){
        response = await httpGet(path: '/get_location');
      }else{
        response = await httpGet(path: '/get_location');//?skip=$skip&limit=$limit
      }
      print("response: ${response.body}");
      if (response.statusCode == 200) {
        if(jsonDecode(response.body)!=null) {
          return List<EmployeeLocation>.from(jsonDecode(response.body).map((item)=> EmployeeLocation.fromJson(item)));
        }else{
          return {"message": "Something Went Wrong"};
        }
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