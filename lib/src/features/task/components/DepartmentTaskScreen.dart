import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/constants.dart';
import '../../../utils/functions.dart';
import '../controllers/TaskController.dart';
import '../models/TaskResponse.dart';
import 'TaskDetailsScreen.dart';

class DepartmentTaskScreen extends StatelessWidget {
  const DepartmentTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(
        init: TaskController(),
        builder: (controller) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(DPadding.full),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(DPadding.half),
                                color: DColors.background,
                              ),
                              child: const Icon(Icons.arrow_back,
                                  color: DColors.primary),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${controller.departmentName} Task",
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: GoogleFonts.quicksand(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  color: DColors.primary),
                            ),
                          ),
                          WidthSpace(width: DPadding.full * 1.5),
                        ],
                      ),
                      const HeightSpace(),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                controller.selectStatus = 'Backlog';
                                controller.displayData = controller.backLogs!;
                                controller.update();
                              },
                              child: Container(
                                padding: EdgeInsets.all(DPadding.half),
                                decoration: BoxDecoration(
                                    color: controller.selectStatus == 'Backlog'
                                        ? DColors.primary
                                        : Colors.white,
                                    border: Border.all(
                                        color:
                                            controller.selectStatus == 'Backlog'
                                                ? Colors.white
                                                : DColors.primary),
                                    borderRadius:
                                        BorderRadius.circular(DPadding.half)),
                                child: Text(
                                  "Backlog",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: isDepHead ? 12 : 14,
                                      color:
                                          controller.selectStatus == 'Backlog'
                                              ? Colors.white
                                              : DColors.primary),
                                ),
                              ),
                            ),
                          ),
                          const WidthSpace(),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                controller.selectStatus = 'Processing';
                                controller.displayData = controller.processing!;
                                controller.update();
                              },
                              child: Container(
                                padding: EdgeInsets.all(DPadding.half),
                                decoration: BoxDecoration(
                                    color:
                                        controller.selectStatus == 'Processing'
                                            ? DColors.primary
                                            : Colors.white,
                                    border: Border.all(
                                        color: controller.selectStatus ==
                                                'Processing'
                                            ? Colors.white
                                            : DColors.primary),
                                    borderRadius:
                                        BorderRadius.circular(DPadding.half)),
                                child: Text(
                                  "Processing",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: isDepHead ? 12 : 14,
                                      color: controller.selectStatus ==
                                              'Processing'
                                          ? Colors.white
                                          : DColors.primary),
                                ),
                              ),
                            ),
                          ),
                          if (isDepHead) const WidthSpace(),
                          if (isDepHead &&
                              controller.departmentName != "Personal")
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  controller.selectStatus = 'Review';
                                  controller.getReviewData();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(DPadding.half),
                                  decoration: BoxDecoration(
                                      color: controller.selectStatus == 'Review'
                                          ? DColors.primary
                                          : Colors.white,
                                      border: Border.all(
                                          color: controller.selectStatus ==
                                                  'Review'
                                              ? Colors.white
                                              : DColors.primary),
                                      borderRadius:
                                          BorderRadius.circular(DPadding.half)),
                                  child: Text(
                                    "Review",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: isDepHead ? 12 : 14,
                                        color:
                                            controller.selectStatus == 'Review'
                                                ? Colors.white
                                                : DColors.primary),
                                  ),
                                ),
                              ),
                            ),
                          const WidthSpace(),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                controller.selectStatus = 'Completed';
                                controller.displayData = controller.complete!;
                                controller.update();
                              },
                              child: Container(
                                padding: EdgeInsets.all(DPadding.half),
                                decoration: BoxDecoration(
                                    color:
                                        controller.selectStatus == 'Completed'
                                            ? DColors.primary
                                            : Colors.white,
                                    border: Border.all(
                                        color: controller.selectStatus ==
                                                'Completed'
                                            ? Colors.white
                                            : DColors.primary),
                                    borderRadius:
                                        BorderRadius.circular(DPadding.half)),
                                child: Text(
                                  "Completed",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: isDepHead ? 12 : 14,
                                      color:
                                          controller.selectStatus == 'Completed'
                                              ? Colors.white
                                              : DColors.primary),
                                ),
                              ),
                            ),
                          ),
                          const WidthSpace(),
                        ],
                      ),
                      const HeightSpace(),
                      Expanded(
                        child: ListView.builder(
                          controller: controller.scrollController,
                          shrinkWrap: true,
                          itemCount: controller.displayData.length,
                          itemBuilder: (context, index) {
                            TaskResponse response =
                                controller.displayData[index];
                            return Visibility(
                              visible: response.title != null,
                              child: InkWell(
                                onTap: () {
                                  controller.task = response;
                                  controller.getFeedback(id: response.id);
                                  controller.getComments(id: response.id);
                                  controller.update();
                                  Get.to(const TaskDetailsScreen());
                                },
                                child: Card(
                                  elevation: 2,
                                  child: Container(
                                    padding: EdgeInsets.all(DPadding.full),
                                    child: Row(
                                      children: [
                                        controller.selectStatus == 'Backlog'
                                            ? const Icon(
                                                Icons.check_box_outline_blank,
                                                color: DColors.primary,
                                              )
                                            : (controller.selectStatus ==
                                                    'Processing'
                                                ? const Icon(
                                                    Icons.check_box_outlined,
                                                    color: Colors.blue,
                                                  )
                                                : const Icon(
                                                    Icons.check_box_rounded,
                                                    color: Colors.green,
                                                  )),
                                        const WidthSpace(),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      response.title.toString(),
                                                      softWrap: true,
                                                      style: const TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  const WidthSpace(),
                                                  const Icon(
                                                    Icons.star,
                                                    color: Colors.orange,
                                                    size: 15,
                                                  ),
                                                  Text(response.priorityRate
                                                      .toString()),
                                                ],
                                              ),
                                              HeightSpace(
                                                  height: DPadding.half / 4),
                                              Row(
                                                children: [
                                                  if (response.deadlineAt !=
                                                      null)
                                                    RichText(
                                                      text: TextSpan(children: [
                                                        WidgetSpan(
                                                            child: Icon(
                                                          Icons.calendar_month,
                                                          size: 15,
                                                          color: Colors
                                                              .grey.shade400,
                                                        )),
                                                        TextSpan(
                                                            text:
                                                                " ${getDate(DateTime.parse(response.deadlineAt.toString()))}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                                fontSize: 12))
                                                      ]),
                                                    ),
                                                  if (response.deadlineAt !=
                                                      null)
                                                    const WidthSpace(),
                                                  if (response.assignedTo
                                                              .toString() ==
                                                          GetStorage().read(
                                                              'employeeId') &&
                                                      response.assignedTo
                                                              .toString() !=
                                                          response.assignedBy
                                                              .toString())
                                                    Expanded(
                                                      child: RichText(
                                                        text:
                                                            TextSpan(children: [
                                                          WidgetSpan(
                                                              child: Icon(
                                                            Icons.person,
                                                            size: 15,
                                                            color: Colors
                                                                .grey.shade400,
                                                          )),
                                                          TextSpan(
                                                              text:
                                                                  " ${response.assignedByName}",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade400,
                                                                  fontSize: 12))
                                                        ]),
                                                      ),
                                                    ),
                                                  if (response.assignedBy
                                                              .toString() ==
                                                          GetStorage().read(
                                                              'employeeId') &&
                                                      response.assignedTo
                                                              .toString() !=
                                                          response.assignedBy
                                                              .toString())
                                                    Expanded(
                                                      child: RichText(
                                                        text:
                                                            TextSpan(children: [
                                                          WidgetSpan(
                                                              child: Icon(
                                                            Icons.person,
                                                            size: 15,
                                                            color: Colors
                                                                .grey.shade400,
                                                          )),
                                                          TextSpan(
                                                              text:
                                                                  " ${response.assignedToName}",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade400,
                                                                  fontSize: 12))
                                                        ]),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ]),
              ),
            ),
          );
        });
  }
}
