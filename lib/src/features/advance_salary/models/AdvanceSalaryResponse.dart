// To parse this JSON data, do
//
//     final advanceSalaryResponse = advanceSalaryResponseFromJson(jsonString);

import 'dart:convert';

List<AdvanceSalaryResponse> advanceSalaryResponseFromJson(String str) =>
    List<AdvanceSalaryResponse>.from(
        json.decode(str)["data"].map((x) => AdvanceSalaryResponse.fromJson(x)));

String advanceSalaryResponseToJson(List<AdvanceSalaryResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AdvanceSalaryResponse {
  AdvanceSalaryResponse({
    this.id,
    this.eDbId,
    this.employeeId,
    this.fullName,
    this.photo,
    this.dHeadId,
    this.amount,
    this.note,
    this.aproval,
    this.aprovalAccount,
    this.status,
    this.uploaderInfo,
    this.requestMonth,
    this.data,
  });

  dynamic id;
  dynamic eDbId;
  dynamic employeeId;
  dynamic fullName;
  dynamic photo;
  dynamic dHeadId;
  dynamic amount;
  dynamic note;
  dynamic aproval;
  dynamic aprovalAccount;
  dynamic status;
  dynamic uploaderInfo;
  dynamic requestMonth;
  dynamic data;

  factory AdvanceSalaryResponse.fromJson(Map<String, dynamic> json) =>
      AdvanceSalaryResponse(
        id: json["id"],
        eDbId: json["e_db_id"],
        employeeId: json["employee_id"],
        fullName: json["full_name"],
        photo: "http://erp.superhomebd.com/super_home/${json["photo"]}",
        dHeadId: json["d_head_id"],
        amount: json["amount"],
        note: json["note"],
        aproval: json["aproval"],
        aprovalAccount: json["aproval_account"],
        status: json["status"],
        uploaderInfo: json["uploader_info"],
        requestMonth: json["request_month"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "e_db_id": eDbId,
        "employee_id": employeeId,
        "full_name": fullName,
        "photo": photo,
        "d_head_id": dHeadId,
        "amount": amount,
        "note": note,
        "aproval": aproval,
        "aproval_account": aprovalAccount,
        "status": status,
        "uploader_info": uploaderInfo,
        "request_month": requestMonth,
        "data": data,
      };
}
