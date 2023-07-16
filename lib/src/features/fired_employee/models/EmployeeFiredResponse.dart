// To parse this JSON data, do
//
//     final employeeFiredResponse = employeeFiredResponseFromJson(jsonString);

import 'dart:convert';

List<EmployeeFiredResponse> employeeFiredResponseFromJson(String str) =>
    List<EmployeeFiredResponse>.from(
        json.decode(str)['data'].map((x) => EmployeeFiredResponse.fromJson(x)));

String employeeFiredResponseToJson(List<EmployeeFiredResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EmployeeFiredResponse {
  EmployeeFiredResponse({
    required this.id,
    required this.employeeId,
    required this.status,
    required this.approval,
    required this.reason,
    required this.fullName,
    required this.photo,
  });

  int id;
  dynamic employeeId;
  dynamic status;
  dynamic approval;
  String reason;
  String fullName;
  String photo;

  factory EmployeeFiredResponse.fromJson(Map<String, dynamic> json) =>
      EmployeeFiredResponse(
        id: json["id"],
        employeeId: json["employee_id"],
        status: json["status"],
        approval: json["approval"],
        reason: json["reason"] ?? '',
        fullName: json["full_name"],
        photo: "http://erp.superhomebd.com/super_home/${json["photo"]}",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "employee_id": employeeId,
        "status": status,
        "approval": approval,
        "reason": reason,
        "full_name": fullName,
        "photo": photo,
      };
}
