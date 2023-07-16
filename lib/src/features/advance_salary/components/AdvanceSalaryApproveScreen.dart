// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/AdvanceSalaryApproveController.dart';
import '../models/AdvanceSalaryResponse.dart';
import '../widgets/getStatus.dart';
import 'package:neways3/src/utils/constants.dart';
import 'package:neways3/src/utils/functions.dart';

class AdvanceSalaryApproveScreen extends StatelessWidget {
  const AdvanceSalaryApproveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DColors.background,
      appBar: AppBar(
        leading: InkWell(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back_ios_new_rounded)),
        title: const Text("Advance Salary Approve"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () async {
                await Get.put(AdvanceSalaryApproveController()).getAllData();
              },
              icon: const Icon(Icons.replay_outlined)),
        ],
      ),
      body: body(),
    );
  }

  Widget body() {
    return GetBuilder<AdvanceSalaryApproveController>(
      init: AdvanceSalaryApproveController(),
      builder: ((controller) => ListView.builder(
            itemCount: controller.responses.length,
            itemBuilder: (context, index) {
              AdvanceSalaryResponse response = controller.responses[index];
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
                              child: Image.network(response.photo,
                                  width: 80, height: 80, fit: BoxFit.fill),
                            ),
                            WidthSpace(width: DPadding.full),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    response.fullName,
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
                                                  await controller.approve(
                                                      id: response.id);
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
                                                      hintText: "Enter Note ",
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
                                                  await controller.reject(
                                                      id: response.id);
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
                                                      hintText: "Enter Note ",
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Amount',
                                style: TextStyle(
                                    color: Colors.blueGrey.shade600,
                                    fontWeight: FontWeight.bold)),
                            HeightSpace(height: DPadding.half / 2),
                            Text(
                              "BDT ${response.amount}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade800),
                            ),
                          ],
                        ),
                        const HeightSpace(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Reason',
                                style: TextStyle(
                                    color: Colors.blueGrey.shade600,
                                    fontWeight: FontWeight.bold)),
                            HeightSpace(height: DPadding.half / 2),
                            Text(
                              response.note,
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
