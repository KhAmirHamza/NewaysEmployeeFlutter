// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neways3/src/features/attendence/controller/AttendenceController.dart';
import 'package:neways3/src/features/attendence/models/attendence_response_model.dart';
import 'package:neways3/src/features/attendence/widgets/AbsentWidget.dart';
import 'package:neways3/src/features/attendence/widgets/HalfDayWidget.dart';
import 'package:neways3/src/features/attendence/widgets/PresentWidget.dart';
import 'package:neways3/src/utils/constants.dart';
import 'package:neways3/src/utils/functions.dart';

class AttendenceScreen extends StatelessWidget {
  AttendenceScreen({Key? key}) : super(key: key);
  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    int totalDays =
        DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day;
    return Scaffold(
      body: GetBuilder<AttendenceController>(
          init: AttendenceController(),
          builder: (controller) {
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeightSpace(height: DPadding.half),
                  Row(
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
                          "Attendence",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.quicksand(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: DColors.primary),
                        ),
                      ),
                    ],
                  ),
                  HeightSpace(height: DPadding.full),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(DPadding.half),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(DPadding.half),
                      border: Border.all(color: DColors.primary),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton.icon(
                          onPressed: () => controller.pickMonth(context,
                              initialDate: controller.date),
                          icon: const Icon(Icons.calendar_month_outlined),
                          label: Text(
                              "${getMonth(controller.date.month, isFullName: true)} ${controller.date.year} (${controller.attendences.length})")),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        controller: scrollController,
                        itemCount: totalDays,
                        itemBuilder: (context, index) {
                          int day = index + 1;
                          AttendenceResponseModel response = controller
                              .attendences
                              .firstWhere((element) => element.days == day,
                                  orElse: (() => AttendenceResponseModel()));
                          return AttendenceDay(
                              day: day,
                              date: controller.date,
                              attendenceResponseModel: response);
                        }),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class AttendenceDay extends StatelessWidget {
  final int day;
  final DateTime date;
  AttendenceResponseModel attendenceResponseModel;
  AttendenceDay({
    required this.day,
    required this.date,
    required this.attendenceResponseModel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isFuture = (day > DateTime.now().day) &&
        (date.month == DateTime.now().month) &&
        (date.year == DateTime.now().year);
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(
          horizontal: DPadding.half, vertical: DPadding.half / 2),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DPadding.half),
      ),
      child: SizedBox(
        height: 75,
        // padding: EdgeInsets.all(DPadding.half),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(DPadding.full),
              decoration: BoxDecoration(
                color: attendenceResponseModel.days == null
                    ? (!isFuture ? Colors.red : Colors.grey)
                    : Colors.green,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(DPadding.half),
                  bottomLeft: Radius.circular(DPadding.half),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "$day",
                    style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Day",
                    style: GoogleFonts.quicksand(
                        color: Colors.grey.shade100,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(DPadding.half),
                child: Row(
                  children: [
                    PresentWidget(
                        attendenceResponseModel: attendenceResponseModel),
                    const WidthSpace(),
                    AbsentWidget(
                        isAbsent: attendenceResponseModel.days == null,
                        isFuture: isFuture),
                    const WidthSpace(),
                    HalfDayWidget(
                        attendenceResponseModel: attendenceResponseModel),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Check In",
//                                 style: TextStyle(
//                                     color: Colors.grey.shade800,
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               Text(
//                                 "08:00 AM",
//                                 style: TextStyle(
//                                     color: Colors.grey.shade800, fontSize: 12),
//                               ),
//                             ],
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Text(
//                                 "Check Out",
//                                 style: TextStyle(
//                                   color: Colors.grey.shade700,
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(
//                                 "07:00 PM",
//                                 style: TextStyle(
//                                     color: Colors.grey.shade700, fontSize: 12),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),