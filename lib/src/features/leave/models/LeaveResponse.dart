// To parse this JSON data, do
//
//     final leaveResponse = leaveResponseFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

List<LeaveResponse> leaveResponseFromJson(String str) =>
    List<LeaveResponse>.from(
        json.decode(str)['data'].map((x) => LeaveResponse.fromJson(x)));
String leaveResponseToJson(List<LeaveResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LeaveResponse {
  LeaveResponse({
    this.id,
    this.uniqueId,
    this.eDbId,
    this.employeeId,
    this.fullName,
    this.photo,
    this.startDays,
    this.howManyDays,
    this.endDate,
    this.holdUnhold,
    this.days,
    this.month,
    this.year,
    this.note,
    this.status,
    this.hAproval,
    this.hId,
    this.aproval,
    this.uploaderInfo,
    this.data,
    this.leaveLock,
    this.createdAt,
  });

  dynamic id;
  dynamic uniqueId;
  dynamic eDbId;
  dynamic employeeId;
  dynamic fullName;
  dynamic photo;
  dynamic startDays;
  dynamic howManyDays;
  dynamic endDate;
  dynamic holdUnhold;
  dynamic days;
  dynamic month;
  dynamic year;
  dynamic note;
  dynamic status;
  dynamic hAproval;
  dynamic hId;
  dynamic aproval;
  dynamic uploaderInfo;
  dynamic data;
  dynamic leaveLock;
  dynamic createdAt;

  factory LeaveResponse.fromJson(Map<String, dynamic> json) => LeaveResponse(
        id: json["id"],
        uniqueId: json["unique_id"],
        eDbId: json["e_db_id"],
        employeeId: json["employee_id"],
        fullName: json["full_name"],
        photo: "http://erp.superhomebd.com/super_home/${json["photo"]}",
        startDays: json["start_days"],
        howManyDays: json["how_many_days"],
        endDate: json["end_date"],
        holdUnhold: json["hold_unhold"],
        days: json["days"],
        month: json["month"],
        year: json["year"],
        note: json["note"],
        status: json["status"],
        hAproval: json["h_aproval"],
        hId: json["h_id"],
        aproval: json["aproval"],
        uploaderInfo: json["uploader_info"],
        data: json["data"],
        leaveLock: json["leave_lock"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "unique_id": uniqueId,
        "e_db_id": eDbId,
        "employee_id": employeeId,
        "full_name": fullName,
        "photo": photo,
        "start_days": startDays,
        "how_many_days": howManyDays,
        "end_date": endDate,
        "hold_unhold": holdUnhold,
        "days": days,
        "month": month,
        "year": year,
        "note": note,
        "status": status,
        "h_aproval": hAproval,
        "h_id": hId,
        "aproval": aproval,
        "uploader_info": uploaderInfo,
        "data": data,
        "leave_lock": leaveLock,
        "created_at": createdAt,
      };
}
