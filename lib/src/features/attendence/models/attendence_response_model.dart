// To parse this JSON data, do
//
//     final attendenceResponseModel = attendenceResponseModelFromJson(jsonString);

import 'dart:convert';

List<AttendenceResponseModel> attendenceResponseModelFromJson(List data) =>
    List<AttendenceResponseModel>.from(
        data.map((x) => AttendenceResponseModel.fromJson(x)));

String attendenceResponseModelToJson(List<AttendenceResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AttendenceResponseModel {
  AttendenceResponseModel({
    this.id,
    this.eDbId,
    this.employeeId,
    this.attendance,
    this.checkin,
    this.checkout,
    this.note,
    this.days,
    this.month,
    this.years,
    this.uploaderInfo,
    this.data,
    this.date,
    this.sn,
  });

  dynamic id;
  dynamic eDbId;
  dynamic employeeId;
  dynamic attendance;
  dynamic checkin;
  dynamic checkout;
  dynamic note;
  dynamic days;
  dynamic month;
  dynamic years;
  dynamic uploaderInfo;
  dynamic data;
  DateTime? date;
  dynamic sn;

  factory AttendenceResponseModel.fromJson(Map<String, dynamic> json) =>
      AttendenceResponseModel(
        id: json["id"],
        eDbId: json["e_db_id"],
        employeeId: json["employee_id"],
        attendance: json["attendance"],
        checkin: json["checkin"],
        checkout: json["checkout"],
        note: json["note"],
        days: json["days"],
        month: json["month"],
        years: json["years"],
        uploaderInfo: json["uploader_info"],
        data: json["data"],
        date: json["date"] == null
            ? null
            : (json["date"].toString().length > 11
                ? DateTime.parse(json["date"].toString())
                : DateTime.parse("${json["date"]} 00:00:00")),
        sn: json["sn"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "e_db_id": eDbId,
        "employee_id": employeeId,
        "attendance": attendance,
        "checkin": checkin,
        "checkout": checkout,
        "note": note,
        "days": days,
        "month": month,
        "years": years,
        "uploader_info": uploaderInfo,
        "data": data,
        "date": date,
        "sn": sn,
      };
}
