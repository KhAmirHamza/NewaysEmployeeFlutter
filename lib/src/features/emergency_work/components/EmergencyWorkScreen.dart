// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neways3/src/utils/constants.dart';

import '../../../utils/functions.dart';
import '../controllers/EmergencyWorkController.dart';
import '../models/EmergencyWorkResponse.dart';
import '../widgets/getStatus.dart';

class EmergencyWorkScreen extends StatelessWidget {
  const EmergencyWorkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DColors.background,
      appBar: AppBar(
        leading: InkWell(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back_ios_new_rounded)),
        title: const Text("Emergency Work"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () async {
                await Get.put(EmergencyWorkController()).getAllData();
              },
              icon: const Icon(Icons.replay_outlined)),
        ],
      ),
      body: GetBuilder<EmergencyWorkController>(
        init: EmergencyWorkController(),
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
                                      "${response.day} ${getMonth(response.month)} ${response.year}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade800),
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
