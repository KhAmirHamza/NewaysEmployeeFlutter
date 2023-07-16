// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/LeaveApproveController.dart';
import '../models/LeaveResponse.dart';
import '../widgets/getStatus.dart';
import 'package:neways3/src/utils/constants.dart';
import 'package:neways3/src/utils/functions.dart';

class LeaveApproveScreen extends StatelessWidget {
  const LeaveApproveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DColors.background,
      appBar: AppBar(
        leading: InkWell(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back_ios_new_rounded)),
        title: const Text("Leave Approve"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () async {
                await Get.put(LeaveApproveController()).getAllData();
              },
              icon: const Icon(Icons.replay_outlined)),
        ],
      ),
      body: body(),
    );
  }

  Widget body() {
    return GetBuilder<LeaveApproveController>(
      init: LeaveApproveController(),
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
                    padding: EdgeInsets.all(DPadding.full),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(leave.photo,
                                  width: 80, height: 80, fit: BoxFit.fill),
                            ),
                            WidthSpace(width: DPadding.full),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    leave.fullName,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  HeightSpace(height: DPadding.half),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton.icon(
                                          onPressed: () => defaultDialog(
                                                title:
                                                    "Are you sure approve this request?",
                                                okPress: () async {
                                                  await controller.action(
                                                      1, leave);
                                                  Get.back();
                                                },
                                                widget: Container(
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade100,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            DPadding.half / 2),
                                                  ),
                                                  child: TextFormField(
                                                    controller: controller
                                                        .noteController,
                                                    maxLines: 3,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              horizontal: 8,
                                                              vertical: 8),
                                                      border:
                                                          const OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide
                                                                      .none),
                                                      hintText:
                                                          "Enter Leave Approve Note ",
                                                      hintStyle: TextStyle(
                                                        color: Colors
                                                            .grey.shade600,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          style: TextButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: DPadding.full),
                                              backgroundColor:
                                                  DColors.background),
                                          icon:
                                              const Icon(Icons.check, size: 18),
                                          label: const Text('Approve')),
                                      TextButton.icon(
                                          onPressed: () => defaultDialog(
                                                title:
                                                    "Are you sure reject this request?",
                                                okPress: () async {
                                                  await controller.action(
                                                      2, leave);
                                                  Get.back();
                                                },
                                                widget: Container(
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade100,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            DPadding.half / 2),
                                                  ),
                                                  child: TextFormField(
                                                    controller: controller
                                                        .noteController,
                                                    maxLines: 3,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              horizontal: 8,
                                                              vertical: 8),
                                                      border:
                                                          const OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide
                                                                      .none),
                                                      hintText:
                                                          "Enter Leave Reject Note ",
                                                      hintStyle: TextStyle(
                                                        color: Colors
                                                            .grey.shade600,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          style: TextButton.styleFrom(
                                              foregroundColor:
                                                  DColors.highLight,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: DPadding.full),
                                              backgroundColor: DColors.highLight
                                                  .withOpacity(0.2)),
                                          icon:
                                              const Icon(Icons.close, size: 18),
                                          label: const Text('Reject')),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
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
