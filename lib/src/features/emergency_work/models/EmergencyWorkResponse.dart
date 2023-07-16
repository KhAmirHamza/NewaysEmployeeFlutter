// To parse this JSON data, do
//
//     final emergencyWorkResponse = emergencyWorkResponseFromJson(jsonString);

import 'dart:convert';

List<EmergencyWorkResponse> emergencyWorkResponseFromJson(String str) =>
    List<EmergencyWorkResponse>.from(
        json.decode(str)['data'].map((x) => EmergencyWorkResponse.fromJson(x)));

String emergencyWorkResponseToJson(List<EmergencyWorkResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EmergencyWorkResponse {
  EmergencyWorkResponse({
    this.id,
    this.departmentName,
    this.employeeId,
    this.employeeName,
    this.year,
    this.month,
    this.day,
    this.fullDate,
    this.note,
    this.status,
  });

  dynamic id;
  dynamic departmentName;
  dynamic employeeId;
  dynamic employeeName;
  dynamic year;
  dynamic month;
  dynamic day;
  dynamic fullDate;
  dynamic note;
  dynamic status;

  factory EmergencyWorkResponse.fromJson(Map<String, dynamic> json) =>
      EmergencyWorkResponse(
        id: json["id"],
        departmentName: json["department_name"],
        employeeId: json["employee_id"],
        employeeName: json["employee_name"],
        year: json["year"],
        month: json["month"],
        day: json["day"],
        fullDate: json["full_date"],
        note: json["note"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "department_name": departmentName,
        "employee_id": employeeId,
        "employee_name": employeeName,
        "year": year,
        "month": month,
        "day": day,
        "full_date": fullDate,
        "note": note,
        "status": status,
      };
}
