import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:neways3/src/features/requisition/controllers/RequisitionController.dart';
import 'package:neways3/src/features/requisition/models/Requisition.dart';
import 'package:neways3/src/utils/httpClient.dart';
import 'package:http/http.dart' as http;

class RequisitionService{

  static Future getAllAvailableRequisition(int branchId, int departmentId, RequisitionController controller) async{
    try {
      var response = await httpGet(path: '/requisition_approval_list/$branchId/$departmentId');

      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        List<dynamic> result = jsonDecode(response.body);
        controller.requisitions.clear();
        for (var element in result) {
          controller.requisitions.add(Requisition.fromJson(element));
        }
      } else {
        print(response.body);
        return {"error": "Unable to getAllAvailableRequisition"};
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return {"error": "Server Error"};
      }
      // ignore: avoid_print
      print(e.response?.statusCode);
    }
  }
  
  static Future updateRequisitionApprovalStatus(String requisition_id, String requisition_type) async {
    try {
      var data = {
        'requisition_id': requisition_id,
        'requisition_type': requisition_type,
      };

      var response = await httpPost(path: '/department-head-requisition-approval', data: data);
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        return jsonDecode(response.body)['message'];
      } else {
        print(jsonDecode(response.body));
        return {"error": "Unable to updateRequisitionApprovalStatus"};
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