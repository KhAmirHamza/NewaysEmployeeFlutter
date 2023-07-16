// To parse this JSON data, do
//
//     final profileResponseModel = profileResponseModelFromJson(jsonString);

import 'dart:convert';

ProfileResponseModel profileResponseModelFromJson(String str) =>
    ProfileResponseModel.fromJson(json.decode(str));

String profileResponseModelToJson(ProfileResponseModel data) =>
    json.encode(data.toJson());

class ProfileResponseModel {
  ProfileResponseModel(
      {required this.employeeId,
      this.roleName,
      required this.designationName,
      required this.departmentName,
      required this.fullName,
      this.personalPhone,
      this.email,
      this.photo,
      this.companyPhone,
      this.companyEmail});

  String employeeId;
  String? roleName;
  String designationName;
  String departmentName;
  String fullName;
  String? personalPhone;
  String? email;
  String? photo;
  String? companyPhone;
  String? companyEmail;

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      ProfileResponseModel(
        employeeId: json["employee_id"],
        roleName: json["role_name"],
        designationName: json["designation_name"],
        departmentName: json["department_name"],
        fullName: json["full_name"],
        personalPhone: json["personal_Phone"],
        email: json["email"],
        photo: json["photo"],
        companyPhone: json["Company_phone"],
        companyEmail: json["company_email"],
      );

  Map<String, dynamic> toJson() => {
        "employee_id": employeeId,
        "role_name": roleName,
        "designation_name": designationName,
        "department_name": departmentName,
        "full_name": fullName,
        "personal_Phone": personalPhone,
        "email": email,
        "photo": photo,
        "Company_phone": companyPhone,
        "company_email": companyEmail,
      };
}
