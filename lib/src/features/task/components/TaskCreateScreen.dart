import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neways3/src/features/task/widgets/TaskCheckBox.dart';

import '../../../utils/constants.dart';
import '../../../utils/functions.dart';
import '../../../utils/textfiled.dart';
import '../controllers/TaskController.dart';

class TaskCreateScreen extends StatelessWidget {

  TaskCreateScreen({super.key});
  
  @override
  Widget build(BuildContext context) {

    return GetBuilder<TaskController>(
        init: TaskController(),
        builder: (controller) {
          return Scaffold(
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
                                  "Create New Task",
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
                                  const HeightSpace(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Title",
                                        style: TextStyle(
                                            color: Colors.grey.shade700),
                                      ),
                                      const HeightSpace(),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(
                                              DPadding.half / 2),
                                        ),
                                        child: TextFormField(
                                          controller:
                                              controller.titleController,
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 8),
                                            border: const OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                            hintText: "Enter Task Title",
                                            hintStyle: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const HeightSpace(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Description",
                                        style: TextStyle(
                                            color: Colors.grey.shade700),
                                      ),
                                      const HeightSpace(),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(
                                              DPadding.half / 2),
                                        ),
                                        child: TextFormField(
                                          controller:
                                              controller.descriptionController,
                                          maxLines: 8,
                                          maxLength: 1000,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 8),
                                            border: const OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                            hintText: "Enter Task Description",
                                            hintStyle: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (isDepHead)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const HeightSpace(),
                                        Text(
                                          "Benefit",
                                          style: TextStyle(
                                              color: Colors.grey.shade700),
                                        ),
                                        const HeightSpace(),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(
                                                DPadding.half / 2),
                                          ),
                                          child: TextFormField(
                                            controller:
                                                controller.benefitController,
                                            maxLines: 4,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 8),
                                              border: const OutlineInputBorder(
                                                  borderSide: BorderSide.none),
                                              hintText: "Enter Task Benefit",
                                              hintStyle: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (isDepHead)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const HeightSpace(),
                                        Text(
                                          "Task Type",
                                          style: TextStyle(
                                              color: Colors.grey.shade700),
                                        ),
                                        const HeightSpace(),

                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.circular(DPadding.half / 2),
                                            color: Colors.grey.shade100
                                          ),
                                          child: Column( children: [
                                            Row(
                                              children: [
                                                TaskCheckBox(controller),
                                                const Text("Performance bonus point for this Task")
                                              ],),

                                            if (isDepHead && controller.isCheckBoxChecked)
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(15,0,15,10),
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey.shade50,
                                                      border: Border.all(color: Colors.green, width: 1),
                                                      borderRadius: BorderRadius.circular(
                                                          DPadding.half / 2),
                                                    ),
                                                    child: TextFormField(
                                                      controller:
                                                      controller.pointController,
                                                      keyboardType: TextInputType.number,
                                                      decoration: InputDecoration(
                                                        contentPadding:
                                                        const EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 8),
                                                        border: const OutlineInputBorder(
                                                            borderSide: BorderSide.none),
                                                        hintText:
                                                        "5 to 100%",
                                                        hintStyle: TextStyle(
                                                          color: Colors.grey.shade400,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          ],)
                                        ),

                                        // RadioListTile(
                                        //   title: const Text("Regular"),
                                        //   value: "regular",
                                        //   groupValue: controller.taskType,
                                        //   onChanged: (value) {
                                        //     controller.taskType =
                                        //         value.toString();
                                        //     controller.update();
                                        //   },
                                        // ),
                                        // RadioListTile(
                                        //   title: const Text("Challenging"),
                                        //   value: "challenging",
                                        //   groupValue: controller.taskType,
                                        //   onChanged: (value) {
                                        //     controller.taskType =
                                        //         value.toString();
                                        //     controller.update();
                                        //   },
                                        // ),
                                      ],
                                    ),

                                  const HeightSpace(height: 15,),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Deadline",
                                              style: TextStyle(
                                                  color: Colors.grey.shade700),
                                            ),
                                            const HeightSpace(),
                                            Container(
                                              height: 45,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        DPadding.half / 2),
                                              ),
                                              child: TextButton.icon(
                                                  onPressed: () async {
                                                    controller.deadline =
                                                        await pickDate(
                                                      context,
                                                      firstDate: DateTime.now()
                                                          .subtract(
                                                              const Duration(
                                                                  days: 365)),
                                                    );
                                                    controller.update();
                                                  },
                                                  icon: const Icon(Icons
                                                      .calendar_month_rounded),
                                                  label: Text(getDate(
                                                      controller.deadline))),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const WidthSpace(),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Priority",
                                              style: TextStyle(
                                                  color: Colors.grey.shade700),
                                            ),
                                            const HeightSpace(),
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () =>
                                                      controller.makeRating(1),
                                                  child: Icon(
                                                    Icons.star,
                                                    color: controller.isOneStar
                                                        ? Colors.orange
                                                        : Colors.grey,
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () =>
                                                      controller.makeRating(2),
                                                  child: Icon(
                                                    Icons.star,
                                                    color: controller.isTwoStar
                                                        ? Colors.orange
                                                        : Colors.grey,
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () =>
                                                      controller.makeRating(3),
                                                  child: Icon(
                                                    Icons.star,
                                                    color:
                                                        controller.isThreeStar
                                                            ? Colors.orange
                                                            : Colors.grey,
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () =>
                                                      controller.makeRating(4),
                                                  child: Icon(
                                                    Icons.star,
                                                    color: controller.isFourStar
                                                        ? Colors.orange
                                                        : Colors.grey,
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () =>
                                                      controller.makeRating(5),
                                                  child: Icon(
                                                    Icons.star,
                                                    color: controller.isFiveStar
                                                        ? Colors.orange
                                                        : Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const HeightSpace(),
                                  if (isDepHead)
                                    AppTextField(
                                      textEditingController:
                                          controller.employeeController,
                                      title: "Assigned To",
                                      hint: "Choose Employee",
                                      isListSelected: true,
                                      list: controller.employees,
                                    ),
                                  HeightSpace(height: DPadding.full * 5),
                                ],
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
                Positioned(
                  bottom: DPadding.full,
                  left: DPadding.full,
                  right: DPadding.full,
                  child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding:
                              EdgeInsets.symmetric(vertical: DPadding.full),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50))),
                      onPressed: () async {
                        await controller.create();
                      },
                      child: Text("Create".toUpperCase())),
                )
              ],
            ),
          );
        });
  }
}
