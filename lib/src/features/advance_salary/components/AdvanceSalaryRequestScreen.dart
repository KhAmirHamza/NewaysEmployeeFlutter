// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neways3/src/utils/constants.dart';

import '../controllers/AdvanceSalaryController.dart';

class AdvanceSalaryRequestScreen extends StatelessWidget {
  const AdvanceSalaryRequestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdvanceSalaryController>(
        init: AdvanceSalaryController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Advance Salary Request'),
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
                    Text(
                      "Requested Amount",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const HeightSpace(),
                    Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(DPadding.half / 2),
                      ),
                      child: TextFormField(
                        controller: controller.amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          hintText: "Enter Amount",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ),
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
                        borderRadius: BorderRadius.circular(DPadding.half / 2),
                      ),
                      child: TextFormField(
                        controller: controller.reasonController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          hintText: "Enter advance money reason",
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
                        child: Text("Request For Advance Salary".toUpperCase()),
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
