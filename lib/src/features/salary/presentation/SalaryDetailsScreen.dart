// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neways3/src/features/salary/controller/SalaryController.dart';
import 'package:neways3/src/features/salary/models/salary_response_model.dart';
import 'package:neways3/src/utils/constants.dart';
import 'package:neways3/src/utils/functions.dart';

class SalaryDetailsScreen extends StatelessWidget {
  SalaryResponseModel salary;
  SalaryDetailsScreen({Key? key, required this.salary}) : super(key: key);

  final controller = Get.put(SalaryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeightSpace(height: DPadding.full),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: EdgeInsets.only(left: DPadding.half),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(DPadding.half),
                      color: DColors.background,
                    ),
                    child: const Icon(Icons.arrow_back, color: DColors.primary),
                  ),
                ),
                Expanded(
                    child: Text(
                  "Salary Statement",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: DColors.primary),
                ))
              ],
            ),
            Container(
              padding: EdgeInsets.all(DPadding.half),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${getMonth(salary.month, isFullName: true)} ${salary.year}",
                        style: GoogleFonts.quicksand(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700),
                      ),
                      Text(
                        "৳ ${salary.totalSallary}",
                        style: GoogleFonts.barlowCondensed(
                            fontSize: 24,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                  HeightSpace(height: DPadding.full),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Name",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            controller.box.read("name"),
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Employee ID",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            controller.box.read("employeeId"),
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const HeightSpace(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Full Day Leave",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${salary.fullDayLeave} Days",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Half Day Leave",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${salary.halfDayLeave} Days",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const HeightSpace(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Absent",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${salary.totalAbsent} Days",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Attendence",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${salary.totalAttendance} Days",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const HeightSpace(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Salary Deduction",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "৳ ${salary.slaryDeduction}",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ],
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Miss Attendence Deduction",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "৳ ${salary.missAttDeduction}",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.normal,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const HeightSpace(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Advance Salary",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "৳ ${salary.advanceSalary}",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Basic Salary",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "৳ ${salary.basicSallary}",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const HeightSpace(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Festival Bonus",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "৳ ${salary.festivalDeautyBonus}",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.normal,
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Performance Bonus",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "৳ ${salary.performanceBonus} (${salary.performanceBonusPercentage} %)",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.normal,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const HeightSpace(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Attendance Bonus",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "৳ ${salary.attendanceBonus}",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.normal,
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Attendance Wise Salary",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "৳ ${salary.attendenceWiseSallary}",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.normal,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const HeightSpace(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Extra Salary",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "৳ ${salary.extraSalary}",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.normal,
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Extra Bonus",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "৳ 0.0",
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.normal,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
