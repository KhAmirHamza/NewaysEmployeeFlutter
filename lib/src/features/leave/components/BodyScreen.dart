// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/LeaveController.dart';
import '../models/LeaveResponse.dart';
import '../widgets/getStatus.dart';
import 'package:neways3/src/utils/constants.dart';
import 'package:neways3/src/utils/functions.dart';

class BodyScreen extends StatelessWidget {
  const BodyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LeaveController>(
      init: LeaveController(),
      builder: ((controller) => ListView.builder(
            itemCount: controller.leaves.length,
            itemBuilder: (context, index) {
              LeaveResponse leave = controller.leaves[index];
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: DPadding.half, vertical: DPadding.half),
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: EdgeInsets.all(DPadding.half),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getStatus(
                            aproval: leave.aproval, hAproval: leave.hAproval),
                        const HeightSpace(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Leave Start',
                                    style: TextStyle(
                                        color: Colors.blueGrey.shade600,
                                        fontWeight: FontWeight.normal)),
                                HeightSpace(height: DPadding.half / 2),
                                RichText(
                                    text: TextSpan(children: [
                                  WidgetSpan(
                                      child: Icon(
                                    Icons.calendar_month_rounded,
                                    size: 18,
                                    color: Colors.blueGrey.shade700,
                                  )),
                                  TextSpan(
                                      text:
                                          " ${numToMonth(leave.startDays.toString())}",
                                      style: TextStyle(
                                          color: Colors.blueGrey.shade700,
                                          fontWeight: FontWeight.bold)),
                                ])),
                              ],
                            ),
                            Text(
                                "${leave.howManyDays == '0.5' ? 'Half Day' : leave.howManyDays + ' Days'}",
                                style: TextStyle(
                                    color: Colors.blueGrey.shade800,
                                    fontWeight: FontWeight.bold)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Leave End',
                                    style: TextStyle(
                                        color: Colors.blueGrey.shade600,
                                        fontWeight: FontWeight.normal)),
                                HeightSpace(height: DPadding.half / 2),
                                RichText(
                                    text: TextSpan(children: [
                                  WidgetSpan(
                                      child: Icon(
                                    Icons.calendar_month_rounded,
                                    size: 18,
                                    color: Colors.blueGrey.shade700,
                                  )),
                                  TextSpan(
                                      text:
                                          " ${numToMonth(leave.endDate.toString())}",
                                      style: TextStyle(
                                          color: Colors.blueGrey.shade700,
                                          fontWeight: FontWeight.bold)),
                                ])),
                              ],
                            ),
                          ],
                        ),
                        HeightSpace(height: DPadding.full),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Leave Reason',
                                style: TextStyle(
                                    color: Colors.blueGrey.shade600,
                                    fontWeight: FontWeight.bold)),
                            HeightSpace(height: DPadding.half / 2),
                            Text(
                              leave.note,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }
}
