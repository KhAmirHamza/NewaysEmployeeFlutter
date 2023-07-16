// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:neways3/src/features/leave/controllers/LeaveController.dart';
import 'package:neways3/src/utils/constants.dart';
import 'package:neways3/src/utils/functions.dart';

class LeaveRequestScreen extends StatelessWidget {
  const LeaveRequestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LeaveController>(
        init: LeaveController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Leave Request'),
              centerTitle: true,
              elevation: 0,
            ),
            body: Padding(
              padding: EdgeInsets.all(DPadding.half),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeightSpace(),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: controller.isFullDay
                                    ? DColors.primary
                                    : DColors.white,
                                border: Border.all(color: DColors.primary),
                                borderRadius:
                                    BorderRadius.circular(DPadding.half)),
                            child: RadioListTile(
                              dense: true,
                              activeColor: controller.isFullDay
                                  ? DColors.white
                                  : DColors.primary,
                              title: const Text("Full Days"),
                              selected: controller.isFullDay,
                              value: true,
                              groupValue: controller.isFullDay,
                              onChanged: (value) =>
                                  controller.seleceDayType(value),
                            ),
                          ),
                        ),
                        const WidthSpace(),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: !controller.isFullDay
                                    ? DColors.primary
                                    : DColors.white,
                                border: Border.all(color: DColors.primary),
                                borderRadius:
                                    BorderRadius.circular(DPadding.half)),
                            child: RadioListTile(
                              dense: true,
                              activeColor: !controller.isFullDay
                                  ? DColors.white
                                  : DColors.primary,
                              title: const Text("Half Day"),
                              selected: !controller.isFullDay,
                              value: false,
                              groupValue: controller.isFullDay,
                              onChanged: (value) =>
                                  controller.seleceDayType(value),
                            ),
                          ),
                        ),
                      ],
                    ),
                    HeightSpace(height: DPadding.full),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Leave Start Date",
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                              const HeightSpace(),
                              Container(
                                height: 45,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius:
                                      BorderRadius.circular(DPadding.half / 2),
                                ),
                                child: TextButton.icon(
                                    onPressed: () async {
                                      controller.startDate =
                                          await pickDate(context);
                                      controller.update();
                                    },
                                    icon: const Icon(
                                        Icons.calendar_month_rounded),
                                    label: Text(getDate(controller.startDate))),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: controller.isFullDay,
                          child: const WidthSpace(),
                        ),
                        Visibility(
                            visible: controller.isFullDay,
                            child: Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Leave End Date",
                                    style:
                                        TextStyle(color: Colors.grey.shade700),
                                  ),
                                  const HeightSpace(),
                                  Container(
                                    height: 45,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(
                                          DPadding.half / 2),
                                    ),
                                    child: TextButton.icon(
                                        onPressed: () async {
                                          controller.endDate =
                                              await pickDate(context);
                                          controller.update();
                                        },
                                        icon: const Icon(
                                            Icons.calendar_month_rounded),
                                        label:
                                            Text(getDate(controller.endDate))),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                    const HeightSpace(),
                    Text(
                      "Leave Reason",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const HeightSpace(),
                    Container(
                      height: 65,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(DPadding.half / 2),
                      ),
                      child: TextFormField(
                        controller: controller.leaveReasonController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          hintText: "Enter Leave Reason ",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    HeightSpace(height: DPadding.full),
                    SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          var status = await controller.submitRequest();
                          if (status == true) {
                            Get.back();
                          }
                          Get.snackbar('Message', controller.message!,
                              snackPosition: SnackPosition.BOTTOM,
                              margin: EdgeInsets.all(DPadding.full));
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: DColors.primary,
                        ),
                        child: Text("Request For Leave".toUpperCase()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
