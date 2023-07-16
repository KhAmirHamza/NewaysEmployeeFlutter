// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neways3/src/utils/textfiled.dart';
import '../../../utils/functions.dart';
import '../controllers/EmployeeFiredController.dart';
import 'package:neways3/src/utils/constants.dart';

class EmployeeFiredRequestScreen extends StatelessWidget {
  const EmployeeFiredRequestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmployeeFiredController>(
        init: EmployeeFiredController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Employee Fired Request'),
              centerTitle: true,
              elevation: 0,
            ),
            body: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(DPadding.half),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const HeightSpace(),
                          AppTextField(
                            textEditingController:
                                controller.employeeController,
                            title: "Employee",
                            hint: "Choose Employee",
                            isListSelected: true,
                            list: controller.employees,
                          ),
                          const HeightSpace(),
                          Text(
                            "Last Working Date",
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
                                  controller.lastWorkingDate = await pickDate(
                                      context,
                                      firstDate: DateTime(2015, 1, 1));
                                  controller.update();
                                },
                                icon: const Icon(Icons.calendar_month_rounded),
                                label:
                                    Text(getDate(controller.lastWorkingDate))),
                          ),
                          const HeightSpace(),
                          Text(
                            "Reason",
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          const HeightSpace(),
                          Container(
                            height: 65,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius:
                                  BorderRadius.circular(DPadding.half / 2),
                            ),
                            child: TextFormField(
                              controller: controller.firedReasonController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                hintText: "Enter fired reason ",
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          HeightSpace(height: DPadding.full),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    var status = await controller.submitRequest();
                    if (status == true) {
                      Get.back();
                    }
                    Get.snackbar('Message', controller.message!,
                        snackPosition: SnackPosition.BOTTOM,
                        margin: EdgeInsets.all(DPadding.full));
                  },
                  child: Container(
                    // height: 40,
                    width: double.infinity,
                    color: DColors.highLight,
                    padding: EdgeInsets.all(DPadding.full),
                    alignment: Alignment.center,
                    child: Text(
                      "Request For Fired".toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
