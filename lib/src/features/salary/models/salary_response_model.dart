// To parse this JSON data, do
//
//     final salaryResponseModel = salaryResponseModelFromJson(jsonString);

import 'dart:convert';

List<SalaryResponseModel> salaryResponseModelFromJson(List data) =>
    List<SalaryResponseModel>.from(
        data.map((x) => SalaryResponseModel.fromJson(x)));

String salaryResponseModelToJson(List<SalaryResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SalaryResponseModel {
  SalaryResponseModel({
    this.id,
    this.uniqueId,
    this.employeeId,
    this.month,
    this.year,
    this.dateFull,
    this.totalNumberOfDays,
    this.fullDayLeave,
    this.halfDayLeave,
    this.totalAttendance,
    this.totalAbsent,
    this.festivalDeautyBonus,
    this.attendanceBonus,
    this.performanceBonus,
    this.performanceBonusPercentage,
    this.basicSallary,
    this.attendenceWiseSallary,
    this.slaryDeduction,
    this.missAttDeduction,
    this.extraSalary,
    this.advanceSalary,
    this.totalSallary,
    this.salaryPayMethod,
    this.note,
    this.status,
    this.withdrawStatus,
    this.uploaderInfo,
    this.data,
    this.branchId,
  });

  dynamic id;
  dynamic uniqueId;
  dynamic employeeId;
  dynamic month;
  dynamic year;
  dynamic dateFull;
  dynamic totalNumberOfDays;
  dynamic fullDayLeave;
  dynamic halfDayLeave;
  dynamic totalAttendance;
  dynamic totalAbsent;
  dynamic festivalDeautyBonus;
  dynamic attendanceBonus;
  dynamic performanceBonus;
  dynamic performanceBonusPercentage;
  dynamic basicSallary;
  dynamic attendenceWiseSallary;
  dynamic slaryDeduction;
  dynamic missAttDeduction;
  dynamic extraSalary;
  dynamic advanceSalary;
  dynamic totalSallary;
  dynamic salaryPayMethod;
  dynamic note;
  dynamic status;
  dynamic withdrawStatus;
  dynamic uploaderInfo;
  dynamic data;
  dynamic branchId;

  factory SalaryResponseModel.fromJson(Map<String, dynamic> json) =>
      SalaryResponseModel(
        id: json["id"],
        uniqueId: json["unique_id"],
        employeeId: json["employee_id"],
        month: json["month"],
        year: json["year"],
        dateFull: json["date_full"],
        totalNumberOfDays: json["total_number_of_days"],
        fullDayLeave: json["full_day_leave"],
        halfDayLeave: json["half_day_leave"],
        totalAttendance: json["total_attendance"],
        totalAbsent: json["total_absent"],
        festivalDeautyBonus: json["festival_deauty_bonus"],
        attendanceBonus: json["attendance_bonus"],
        performanceBonus: json["performance_bonus"],
        performanceBonusPercentage: json["performance_bonus_percentage"],
        basicSallary: json["basic_sallary"],
        attendenceWiseSallary: json["attendence_wise_sallary"],
        slaryDeduction: json["slary_deduction"],
        missAttDeduction: json["miss_att_deduction"],
        extraSalary: json["extra_salary"],
        advanceSalary: json["advance_salary"],
        totalSallary: json["total_sallary"],
        salaryPayMethod: json["salary_pay_method"],
        note: json["note"],
        status: json["status"],
        withdrawStatus: json["withdraw_status"],
        uploaderInfo: json["uploader_info"],
        data: json["data"],
        branchId: json["branch_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "unique_id": uniqueId,
        "employee_id": employeeId,
        "month": month,
        "year": year,
        "date_full": dateFull,
        "total_number_of_days": totalNumberOfDays,
        "full_day_leave": fullDayLeave,
        "half_day_leave": halfDayLeave,
        "total_attendance": totalAttendance,
        "total_absent": totalAbsent,
        "festival_deauty_bonus": festivalDeautyBonus,
        "attendance_bonus": attendanceBonus,
        "performance_bonus": performanceBonus,
        "performance_bonus_percentage": performanceBonusPercentage,
        "basic_sallary": basicSallary,
        "attendence_wise_sallary": attendenceWiseSallary,
        "slary_deduction": slaryDeduction,
        "miss_att_deduction": missAttDeduction,
        "extra_salary": extraSalary,
        "advance_salary": advanceSalary,
        "total_sallary": totalSallary,
        "salary_pay_method": salaryPayMethod,
        "note": note,
        "status": status,
        "withdraw_status": withdrawStatus,
        "uploader_info": uploaderInfo,
        "data": data,
        "branch_id": branchId,
      };
}
