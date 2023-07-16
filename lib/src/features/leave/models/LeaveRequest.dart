// To parse this JSON data, do
//
//     final leaveRequest = leaveRequestFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

LeaveRequest leaveRequestFromJson(String str) =>
    LeaveRequest.fromJson(json.decode(str));

LeaveRequest leaveRequestSuccess(String str) =>
    LeaveRequest.fromJson(json.decode(str));

String leaveRequestToJson(LeaveRequest data) => json.encode(data.toJson());

class LeaveRequest {
  LeaveRequest(
      {this.startDate,
      this.endDate,
      this.howManyDays,
      this.note,
      this.isHalfDay,
      this.success});

  dynamic startDate;
  dynamic endDate;
  dynamic howManyDays;
  dynamic note;
  dynamic isHalfDay;
  dynamic success;

  factory LeaveRequest.fromJson(Map<String, dynamic> json) => LeaveRequest(
        startDate: json["start_date"],
        endDate: json["end_date"],
        howManyDays: json["how_many_days"],
        note: json["note"],
        isHalfDay: json["isHalfDay"],
        success: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "start_date": startDate,
        "end_date": endDate,
        "how_many_days": howManyDays,
        "note": note,
        "isHalfDay": isHalfDay,
      };
}
