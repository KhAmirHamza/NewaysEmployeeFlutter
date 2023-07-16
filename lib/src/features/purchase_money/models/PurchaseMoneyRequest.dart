// To parse this JSON data, do
//
//     final leaveRequest = leaveRequestFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

PurchaseMoneyRequest leaveRequestFromJson(String str) =>
    PurchaseMoneyRequest.fromJson(json.decode(str));

PurchaseMoneyRequest leaveRequestSuccess(String str) =>
    PurchaseMoneyRequest.fromJson(json.decode(str));

String leaveRequestToJson(PurchaseMoneyRequest data) =>
    json.encode(data.toJson());

class PurchaseMoneyRequest {
  PurchaseMoneyRequest(
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

  factory PurchaseMoneyRequest.fromJson(Map<String, dynamic> json) =>
      PurchaseMoneyRequest(
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
