import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:neways3/src/features/workplace/model/PendingApproval.dart';

import '../../../utils/httpClient.dart';

class WorkplaceService {

  static getAllDHeadPendingCount() async {
    try {
      var response = await httpAuthGet(path: '/dHeadAllPendings');
      //print("getAllDHeadPendingCount");
     // print(response.body);

      if (response.statusCode == 200) {
        if(jsonDecode(response.body)['data']==null || jsonDecode(response.body)['data'].length<1) {
          return PendingApprovals(leave: 0, purchase: 0,taDa: 0, advance: 0, emergencyWork: 0, resign: 0, fired: 0);
        }else{
          return PendingApprovals.fromJson(jsonDecode(response.body)['data']);
        }
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        return {"error": "Server Error"};
      }
      print(e.response?.statusCode);
    }

    return null;
  }

  static getAllBossPendingCount() async {
    try {
      var response = await httpAuthGet(path: '/bossAllPendings');
      if (response.statusCode == 200) {

        if(jsonDecode(response.body)['data']==null || jsonDecode(response.body)['data'].length<1) {
          return PendingApprovals(leave: 0, purchase: 0,taDa: 0, advance: 0, emergencyWork: 0, resign: 0, fired: 0);
        }else{
          return PendingApprovals.fromJson(jsonDecode(response.body)['data']);
        }
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