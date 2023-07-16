import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants.dart';
import '../../../utils/functions.dart';
import '../bloc/ResignAppliedController.dart';

class ResignAppliedScreen extends StatelessWidget {
  const ResignAppliedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DColors.background,
      appBar: AppBar(
        leading: InkWell(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back_ios_new_rounded)),
        title: const Text("Resign Request"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
          padding: EdgeInsets.all(DPadding.full),
          child: GetBuilder<ResignAppliedController>(
              init: ResignAppliedController(),
              builder: (controller) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeightSpace(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Last working day",
                          style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        const HeightSpace(),
                        Container(
                          height: 45,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(DPadding.half / 2),
                          ),
                          child: TextButton.icon(
                              onPressed: () async {
                                controller.lastdate = await pickDate(
                                  context,
                                  firstDate: DateTime.now()
                                      .subtract(const Duration(days: 365)),
                                );
                                controller.update();
                              },
                              icon: const Icon(Icons.calendar_month_rounded),
                              label: Text(getDate(controller.lastdate))),
                        ),
                      ],
                    ),
                    const HeightSpace(),
                    Text(
                      "Resign Reason",
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const HeightSpace(),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(DPadding.half / 2),
                      ),
                      child: TextFormField(
                        controller: controller.reasonController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(DPadding.full),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          hintText: "Enter Resign Reason ",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    HeightSpace(height: DPadding.full),
                    SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            side: const BorderSide(color: DColors.primary)),
                        onPressed: () => controller.submit(),
                        child: Text("Submit".toUpperCase()),
                      ),
                    ),
                  ],
                );
              })),
    );
  }
}
