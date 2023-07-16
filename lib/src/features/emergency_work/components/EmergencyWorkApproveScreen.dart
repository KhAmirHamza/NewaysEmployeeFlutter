// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neways3/src/utils/constants.dart';

import '../../../utils/functions.dart';
import '../controllers/EmergencyWorkApproveController.dart';
import '../models/EmergencyWorkResponse.dart';
import '../widgets/getStatus.dart';

class EmergencyWorkApproveScreen extends StatelessWidget {
  const EmergencyWorkApproveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DColors.background,
      appBar: AppBar(
        leading: InkWell(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back_ios_new_rounded)),
        title: const Text("Emergency Work Approve"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () async {
                await Get.put(EmergencyWorkApproveController()).getAllData();
              },
              icon: const Icon(Icons.replay_outlined)),
        ],
      ),
      body: GetBuilder<EmergencyWorkApproveController>(
        init: EmergencyWorkApproveController(),
        builder: ((controller) => (controller.isLoadding == false &&
                controller.responses.isEmpty)
            ? const Center(
                child: Text("Data Not Found!"),
              )
            : ListView.builder(
                itemCount: controller.responses.length,
                itemBuilder: (context, index) {
                  EmergencyWorkResponse response = controller.responses[index];
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      response.employeeName.toString(),
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade800),
                                    ),
                                    const HeightSpace(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${response.day} ${getMonth(response.month)} ${response.year}",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey.shade800),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                getStatus(
                                    status:
                                        int.parse(response.status.toString())),
                              ],
                            ),
                            const HeightSpace(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Note',
                                    style: TextStyle(
                                        color: Colors.blueGrey.shade600,
                                        fontWeight: FontWeight.bold)),
                                HeightSpace(height: DPadding.half / 2),
                                Text(
                                  response.note == null
                                      ? ''
                                      : response.note.toString(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton.icon(
                                    onPressed: () => defaultDialog(
                                          title:
                                              "Are you sure approve this request?",
                                          okPress: () async {
                                            await controller.depHeadPermit(
                                                id: response.id,
                                                status: 'approve');
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
                                              controller:
                                                  controller.noteController,
                                              maxLines: 3,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 8),
                                                border:
                                                    const OutlineInputBorder(
                                                        borderSide:
                                                            BorderSide.none),
                                                hintText: "Enter Note ",
                                                hintStyle: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    style: TextButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: DPadding.full),
                                        backgroundColor: DColors.background),
                                    icon: const Icon(Icons.check, size: 18),
                                    label: const Text('Approve')),
                                TextButton.icon(
                                    onPressed: () => defaultDialog(
                                          title:
                                              "Are you sure reject this request?",
                                          okPress: () async {
                                            await controller.depHeadPermit(
                                                id: response.id,
                                                status: 'reject');
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
                                              controller:
                                                  controller.noteController,
                                              maxLines: 3,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 8),
                                                border:
                                                    const OutlineInputBorder(
                                                        borderSide:
                                                            BorderSide.none),
                                                hintText: "Enter Note ",
                                                hintStyle: TextStyle(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    style: TextButton.styleFrom(
                                        foregroundColor: DColors.highLight,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: DPadding.full),
                                        backgroundColor:
                                            DColors.highLight.withOpacity(0.2)),
                                    icon: const Icon(Icons.close, size: 18),
                                    label: const Text('Reject')),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )),
      ),
    );
  }
}
