// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neways3/src/features/salary/controller/SalaryController.dart';
import 'package:neways3/src/features/salary/models/salary_response_model.dart';
import 'package:neways3/src/utils/constants.dart';
import 'package:neways3/src/utils/functions.dart';

import './SalaryDetailsScreen.dart';

class SalaryScreen extends StatelessWidget {
  const SalaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SalaryController>(
          init: SalaryController(),
          builder: (controller) {
            return SafeArea(
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
                          child: const Icon(Icons.arrow_back,
                              color: DColors.primary),
                        ),
                      ),
                      Expanded(
                          child: Text(
                        "Salary Payslip",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: DColors.primary),
                      ))
                    ],
                  ),
                  HeightSpace(height: DPadding.full),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(DPadding.half),
                      child: ListView.builder(
                        itemCount: controller.salaries.length,
                        itemBuilder: (context, index) =>
                            SalaryCard(salary: controller.salaries[index]),
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}

class SalaryCard extends StatelessWidget {
  SalaryResponseModel salary;
  SalaryCard({
    required this.salary,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SalaryDetailsScreen(salary: salary)));
      },
      child: Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(DPadding.half),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${getMonth(salary.month, isFullName: true)} ${salary.year}",
                    style: GoogleFonts.quicksand(
                        color: Colors.grey.shade800,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const HeightSpace(),
                  Text(
                    "Days ${salary.totalAttendance}",
                    style: GoogleFonts.quicksand(
                        color: Colors.grey.shade800,
                        fontSize: 16,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    Icons.subdirectory_arrow_right_outlined,
                    color: Colors.grey.shade300,
                  ),
                  const HeightSpace(),
                  Text(
                    "৳ ${salary.totalSallary}",
                    style: GoogleFonts.barlowCondensed(
                        color: Colors.grey.shade800,
                        fontSize: 20,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
