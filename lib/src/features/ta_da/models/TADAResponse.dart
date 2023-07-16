// To parse this JSON data, do
//
//     final tadaResponse = tadaResponseFromJson(jsonString);

import 'dart:convert';

List<TadaResponse> tadaResponseFromJson(String str) => List<TadaResponse>.from(
    json.decode(str)['data'].map((x) => TadaResponse.fromJson(x)));

String tadaResponseToJson(List<TadaResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TadaResponse {
  TadaResponse({
    this.id,
    this.eDbId,
    this.employeeId,
    this.departmentHeadId,
    this.destinationFrom,
    this.destinationTo,
    this.transportDate,
    this.transportType,
    this.transportDetails,
    this.transportAmount,
    this.foodAmount,
    this.vehicleType,
    this.vehicleTypeReason,
    this.billAttachment,
    this.note,
    this.status,
    this.departmentHeadAproval,
    this.bossAproval,
    this.accountsAproval,
    this.selfAproval,
    this.uploaderInfo,
    this.fullName,
    this.photo,
    this.data,
  });

  dynamic id;
  dynamic eDbId;
  dynamic employeeId;
  dynamic fullName;
  dynamic photo;
  dynamic departmentHeadId;
  dynamic destinationFrom;
  dynamic destinationTo;
  dynamic transportDate;
  dynamic transportType;
  dynamic transportDetails;
  dynamic transportAmount;
  dynamic foodAmount;
  dynamic vehicleType;
  dynamic vehicleTypeReason;
  dynamic billAttachment;
  dynamic note;
  dynamic status;
  dynamic departmentHeadAproval;
  dynamic bossAproval;
  dynamic accountsAproval;
  dynamic selfAproval;
  dynamic uploaderInfo;
  dynamic data;

  factory TadaResponse.fromJson(Map<String, dynamic> json) => TadaResponse(
        id: json["id"],
        eDbId: json["e_db_id"],
        employeeId: json["employee_id"],
        departmentHeadId: json["department_head_id"],
        destinationFrom: json["destination_from"],
        destinationTo: json["destination_to"],
        transportDate: json["transport_date"],
        transportType: json["transport_type"],
        transportDetails: json["transport_details"],
        transportAmount: json["transport_amount"],
        foodAmount: json["food_amount"],
        vehicleType: json["vehicle_type"],
        vehicleTypeReason: json["vehicle_type_reason"],
        billAttachment: json["bill_attachment"],
        note: json["note"],
        status: json["status"],
        departmentHeadAproval: json["department_head_aproval"],
        bossAproval: json["boss_aproval"],
        accountsAproval: json["accounts_aproval"],
        selfAproval: json["self_aproval"],
        uploaderInfo: json["uploader_info"],
        fullName: json["full_name"],
        photo: "http://erp.superhomebd.com/super_home/${json["photo"]}",
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "e_db_id": eDbId,
        "employee_id": employeeId,
        "department_head_id": departmentHeadId,
        "destination_from": destinationFrom,
        "destination_to": destinationTo,
        "transport_date": transportDate,
        "transport_type": transportType,
        "transport_details": transportDetails,
        "transport_amount": transportAmount,
        "food_amount": foodAmount,
        "vehicle_type": vehicleType,
        "vehicle_type_reason": vehicleTypeReason,
        "bill_attachment": billAttachment,
        "note": note,
        "status": status,
        "department_head_aproval": departmentHeadAproval,
        "boss_aproval": bossAproval,
        "accounts_aproval": accountsAproval,
        "self_aproval": selfAproval,
        "uploader_info": uploaderInfo,
        "full_name": fullName,
        "photo": photo,
        "data": data,
      };
}
