// To parse this JSON data, do
//
//     final employeeResignResponse = employeeResignResponseFromJson(jsonString);

import 'dart:convert';

List<EmployeeResignResponse> employeeResignResponseFromJson(String str) =>
    List<EmployeeResignResponse>.from(json
        .decode(str)['data']
        .map((x) => EmployeeResignResponse.fromJson(x)));

String employeeResignResponseToJson(List<EmployeeResignResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EmployeeResignResponse {
  EmployeeResignResponse({
    required this.id,
    required this.employeeId,
    required this.status,
    required this.approval,
    required this.resignDay,
    this.reason,
    required this.fullName,
    required this.photo,
  });

  dynamic id;
  dynamic employeeId;
  dynamic status;
  dynamic approval;
  DateTime resignDay;
  dynamic reason;
  String fullName;
  String photo;

  factory EmployeeResignResponse.fromJson(Map<String, dynamic> json) =>
      EmployeeResignResponse(
        id: json["id"],
        employeeId: json["employee_id"],
        status: json["status"],
        approval: json["approval"],
        resignDay: DateTime.parse(json["resign_day"]),
        reason: json["reason"] ?? '',
        fullName: json["full_name"],
        photo: "http://erp.superhomebd.com/super_home/${json["photo"]}",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "employee_id": employeeId,
        "status": status,
        "approval": approval,
        "resign_day":
            "${resignDay.year.toString().padLeft(4, '0')}-${resignDay.month.toString().padLeft(2, '0')}-${resignDay.day.toString().padLeft(2, '0')}",
        "reason": reason,
        "full_name": fullName,
        "photo": photo,
      };
}
