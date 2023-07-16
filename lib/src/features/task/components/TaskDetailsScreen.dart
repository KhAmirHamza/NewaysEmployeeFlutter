import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/constants.dart';
import '../../../utils/functions.dart';
import '../controllers/TaskController.dart';
import '../models/TaskCommentResponse.dart';

class TaskDetailsScreen extends StatelessWidget {
  const TaskDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(
        init: TaskController(),
        builder: (controller) {
          return Scaffold(
            floatingActionButton: controller.isCommets
                ? const SizedBox()
                : FloatingActionButton(
                    onPressed: () {
                      controller.isCommets = true;
                      controller.update();
                    },
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.insert_comment),
                  ),
            body: Stack(
              children: [
                SafeArea(
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
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          controller.task!.title.toString(),
                                          style: const TextStyle(
                                              fontSize: 21,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: DPadding.full,
                                            vertical: DPadding.half),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              DPadding.full),
                                          color: controller.task!.status == 0
                                              ? Colors.grey
                                              : (controller.task!.status == 1
                                                  ? Colors.blue
                                                  : Colors.green),
                                        ),
                                        child: Text(
                                          controller.task!.status == 0
                                              ? "Backlog".toUpperCase()
                                              : (controller.task!.status == 1
                                                  ? "Processing".toUpperCase()
                                                  : "Completed".toUpperCase()),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ),
                                  const HeightSpace(),
                                  Row(
                                    children: [
                                      if (controller.task!.deadlineAt != null)
                                        RichText(
                                          text: TextSpan(children: [
                                            WidgetSpan(
                                                child: Icon(
                                              Icons.calendar_month,
                                              size: 15,
                                              color: Colors.grey.shade400,
                                            )),
                                            TextSpan(
                                                text:
                                                    " ${getDate(DateTime.parse(controller.task!.deadlineAt.toString()))} (deadline)",
                                                style: TextStyle(
                                                    color: Colors.grey.shade400,
                                                    fontSize: 12))
                                          ]),
                                        ),
                                      if (controller.task!.deadlineAt != null)
                                        const WidthSpace(),
                                      if (controller.task!.assignedTo
                                                  .toString() ==
                                              GetStorage().read('employeeId') &&
                                          controller.task!.assignedTo
                                                  .toString() !=
                                              controller.task!.assignedBy
                                                  .toString())
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(children: [
                                              WidgetSpan(
                                                  child: Icon(
                                                Icons.person,
                                                size: 15,
                                                color: Colors.grey.shade400,
                                              )),
                                              TextSpan(
                                                  text:
                                                      " ${controller.task!.assignedByName}",
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade400,
                                                      fontSize: 12))
                                            ]),
                                          ),
                                        ),
                                      if (controller.task!.assignedBy
                                                  .toString() ==
                                              GetStorage().read('employeeId') &&
                                          controller.task!.assignedTo
                                                  .toString() !=
                                              controller.task!.assignedBy
                                                  .toString())
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(children: [
                                              WidgetSpan(
                                                  child: Icon(
                                                Icons.person,
                                                size: 15,
                                                color: Colors.grey.shade400,
                                              )),
                                              TextSpan(
                                                  text:
                                                      " ${controller.task!.assignedToName} (Assigned)",
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade400,
                                                      fontSize: 12))
                                            ]),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const HeightSpace(),
                                  Text(
                                    controller.task!.description,
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey.shade800),
                                  ),
                                  const HeightSpace(),
                                  if (controller.task!.taskImage != null)
                                    if (controller.task!.taskImage.isNotEmpty)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            DPadding.full),
                                        child: InkWell(
                                          onTap: () {
                                            _openCustomDialog(context,
                                                img:
                                                    "http://erp.superhomebd.com/super_home/assets/uploads/task_list/${controller.task!.taskImage}");
                                          },
                                          child: ExtendedImage.network(
                                            "http://erp.superhomebd.com/super_home/assets/uploads/task_list/${controller.task!.taskImage}",
                                            width: Get.size.width,
                                          ),
                                        ),
                                      ),
                                  const HeightSpace(),
                                  Visibility(
                                    visible: controller.feedbacks.isNotEmpty,
                                    child: Text(
                                      "Feedback",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade900,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const HeightSpace(),
                                  ListView.builder(
                                      controller: controller.scrollController,
                                      shrinkWrap: true,
                                      itemCount: controller.feedbacks.length,
                                      itemBuilder: (context, index) {
                                        dynamic feedback =
                                            controller.feedbacks[index];

                                        return Card(
                                          elevation: 0,
                                          color: Colors.grey.shade100,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  feedback['feedback'],
                                                  textAlign: TextAlign.justify,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color:
                                                          Colors.grey.shade800),
                                                ),
                                                if (feedback['task_files'] !=
                                                    null)
                                                  if (feedback['task_files']
                                                      .isNotEmpty)
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              DPadding.full),
                                                      child: InkWell(
                                                        onTap: () {
                                                          _openCustomDialog(
                                                              context,
                                                              img:
                                                                  "http://erp.superhomebd.com/super_home/assets/uploads/task_list/${feedback['task_files']}");
                                                        },
                                                        child: ExtendedImage
                                                            .network(
                                                          "http://erp.superhomebd.com/super_home/assets/uploads/task_list/${feedback['task_files']}",
                                                          width: Get.size.width,
                                                        ),
                                                      ),
                                                    ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                  const HeightSpace(),
                                  Visibility(
                                    visible: controller.comments.isNotEmpty,
                                    child: Text(
                                      "Comments",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade900,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const HeightSpace(),
                                  ListView.builder(
                                      controller: controller.scrollController,
                                      shrinkWrap: true,
                                      itemCount: controller.comments.length,
                                      itemBuilder: (context, index) {
                                        TaskCommentResponse response =
                                            controller.comments[index];
                                        if (response.employeeId == null) {
                                          return const SizedBox();
                                        } else {
                                          return Card(
                                            elevation: 0,
                                            color: DColors.background,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(80),
                                                        child: Image.network(
                                                          response.photo,
                                                          width: 45,
                                                          height: 45,
                                                          fit: BoxFit.fitHeight,
                                                        ),
                                                      ),
                                                      const WidthSpace(),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            response.fullName,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade800,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18),
                                                          ),
                                                          Text(
                                                            getDate(DateTime
                                                                .parse(response
                                                                    .createdAt
                                                                    .toString())),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade500,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  const HeightSpace(),
                                                  Text(
                                                    response.comment,
                                                    textAlign:
                                                        TextAlign.justify,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors
                                                            .grey.shade800),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                      }),
                                  HeightSpace(height: DPadding.full * 2),
                                ],
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
                Visibility(
                  visible: controller.isCommets,
                  child: Positioned(
                    bottom: DPadding.full,
                    left: DPadding.full,
                    right: DPadding.full,
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: DPadding.full),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(35.0),
                            boxShadow: const [
                              BoxShadow(
                                  offset: Offset(0, 2),
                                  blurRadius: 7,
                                  color: Colors.grey)
                            ],
                          ),
                          child: TextField(
                            controller: controller.commentController,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (value) {
                              controller.sendComment(value);
                            },
                            decoration: const InputDecoration(
                                hintText: "Comments hear...",
                                hintStyle: TextStyle(color: DColors.primary),
                                border: InputBorder.none),
                          ),
                        )),
                        FloatingActionButton(
                          onPressed: () {
                            controller.isCommets = false;
                            controller.update();
                          },
                          backgroundColor: Colors.red,
                          mini: true,
                          child: const Icon(Icons.close),
                        )
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: !controller.isCommets &&
                      (controller.task!.status == 0 ||
                          (controller.task!.status == 1)) &&
                      controller.task!.assignedTo.toString() ==
                          GetStorage().read('employeeId'),
                  child: Positioned(
                    bottom: DPadding.full,
                    left: DPadding.full,
                    right: DPadding.full,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            if (controller.task!.status == 0) {
                              accept(context);
                            } else if (controller.task!.status == 1 &&
                                controller.task!.assignedTo !=
                                    controller.task!.assignedBy) {
                              sendReview(context);
                            } else if (controller.task!.assignedTo ==
                                controller.task!.assignedBy) {
                              defaultDialog(
                                title: "Are you sure confirm this task?",
                                okPress: () async {
                                  Get.back();
                                  await controller
                                      .completeTask(controller.task!.id);
                                  Get.back();
                                },
                                widget: const SizedBox(),
                              );
                            }
                          },
                          style: TextButton.styleFrom(
                            elevation: 8,
                            foregroundColor: Colors.white,
                            backgroundColor: controller.task!.status == 0
                                ? Colors.green
                                : Colors.blue,
                          ),
                          icon: const Icon(Icons.task_alt),
                          label: Text(controller.task!.status == 0
                              ? "Accept this task"
                              : (controller.task!.assignedTo ==
                                      controller.task!.assignedBy
                                  ? "Complete Task"
                                  : "Send Review")),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: !controller.isCommets &&
                      isDepHead &&
                      controller.task!.assignedTo.toString() !=
                          GetStorage().read('employeeId') &&
                      (controller.task!.status == 1 &&
                          controller.task!.status != 2),
                  child: Positioned(
                    bottom: DPadding.full,
                    left: DPadding.full,
                    right: DPadding.full,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            defaultDialog(
                              title: "Are you sure confirm this task?",
                              okPress: () async {
                                Get.back();
                                await controller
                                    .completeTask(controller.task!.id);
                                Get.back();
                              },
                              widget: const SizedBox(),
                            );
                          },
                          style: TextButton.styleFrom(
                            elevation: 8,
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green,
                          ),
                          icon: const Icon(Icons.task),
                          label: const Text("Complete Task"),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  accept(context) {
    return defaultDialog(
      title: "Accept Task",
      isAction: false,
      okPress: () async {
        Get.back();
      },
      widget: GetBuilder<TaskController>(
          init: TaskController(),
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "End Date",
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const HeightSpace(),
                Container(
                  height: 45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(DPadding.half / 2),
                  ),
                  child: TextButton.icon(
                      onPressed: () async {
                        controller.deadline = await pickDate(
                          context,
                          firstDate: DateTime.now()
                              .subtract(const Duration(days: 365)),
                        );
                        controller.update();
                      },
                      icon: const Icon(Icons.calendar_month_rounded),
                      label: Text(getDate(controller.deadline))),
                ),
                const HeightSpace(),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                      onPressed: () {
                        Get.back();
                        controller.accept(controller.task!.id);
                      },
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.green,
                          padding:
                              EdgeInsets.symmetric(horizontal: DPadding.full),
                          backgroundColor: Colors.green.withOpacity(0.2)),
                      child: const Text('Accept')),
                ),
              ],
            );
          }),
    );
  }

  sendReview(context) {
    return defaultDialog(
      title: "Send Task",
      isAction: false,
      okPress: () async {
        Get.back();
      },
      widget: GetBuilder<TaskController>(
          init: TaskController(),
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(DPadding.half / 2),
                  ),
                  child: TextFormField(
                    controller: controller.feedbackController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      hintText: "Enter Feedback",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const HeightSpace(),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                      onPressed: () {
                        Get.back();
                        controller.sendReview(controller.task!.id);
                      },
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.green,
                          padding:
                              EdgeInsets.symmetric(horizontal: DPadding.full),
                          backgroundColor: Colors.green.withOpacity(0.2)),
                      child: const Text('Send')),
                ),
              ],
            );
          }),
    );
  }

  void _openCustomDialog(context, {required String img}) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: SafeArea(
                child: Container(
                  padding: EdgeInsets.all(DPadding.half),
                  // width: double.infinity,
                  child: InkWell(
                    onTap: (() => Get.back()),
                    child: ExtendedImage.network(
                      img,
                      fit: BoxFit.contain,
                      enableLoadState: true,
                      mode: ExtendedImageMode.gesture,
                      initGestureConfigHandler: (state) {
                        return GestureConfig(
                          minScale: 0.9,
                          animationMinScale: 0.7,
                          maxScale: 3.0,
                          animationMaxScale: 3.5,
                          speed: 1.0,
                          inertialSpeed: 100.0,
                          initialScale: 1.0,
                          inPageView: false,
                          initialAlignment: InitialAlignment.center,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) => Container());
  }
}
