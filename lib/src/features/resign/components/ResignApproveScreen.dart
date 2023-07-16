// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/functions.dart';
import '../../fired_employee/widgets/getStatus.dart';
import '../bloc/ResignApproveController.dart';
import 'package:neways3/src/utils/constants.dart';

import '../models/EmployeeResignResponse.dart';

class ResignApproveScreen extends StatelessWidget {
  const ResignApproveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: DColors.background,
        appBar: AppBar(
          leading: InkWell(
              onTap: () => Get.back(),
              child: const Icon(Icons.arrow_back_ios_new_rounded)),
          title: const Text("Resign Approvel"),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () async {
                  await Get.put(ResignApproveController()).getAllData();
                },
                icon: const Icon(Icons.replay_outlined)),
          ],
        ),
        body: GetBuilder<ResignApproveController>(
          init: ResignApproveController(),
          builder: ((controller) => controller.isDataEmpty
              ? const Center(
                  child: Text("Data Not Fount"),
                )
              : ListView.builder(
                  itemCount: controller.responses.length,
                  itemBuilder: (context, index) {
                    EmployeeResignResponse response =
                        controller.responses[index];

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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  WidthSpace(width: DPadding.full),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.network(
                                            response.photo.toString(),
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.fill),
                                      ),
                                      HeightSpace(height: DPadding.half),
                                      Text(
                                        response.fullName.toString(),
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton.icon(
                                          onPressed: () => defaultDialog(
                                              title:
                                                  "Are you sure accept this request?",
                                              okPress: () async {
                                                Get.back();
                                                await controller.action(
                                                    "approve", response);
                                              },
                                              widget: const SizedBox()),
                                          style: TextButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: DPadding.full),
                                              backgroundColor:
                                                  DColors.background),
                                          icon:
                                              const Icon(Icons.check, size: 18),
                                          label: const Text('Accept')),
                                      const WidthSpace(),
                                      TextButton.icon(
                                          onPressed: () => defaultDialog(
                                                title:
                                                    "Are you sure reject this request?",
                                                okPress: () async {
                                                  Get.back();
                                                  await controller.action(
                                                      "reject", response);
                                                  Get.back();
                                                },
                                                widget: const SizedBox(),
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
                              const Divider(),
                              HeightSpace(height: DPadding.full),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Reason (${getDate(response.resignDay)})',
                                      style: TextStyle(
                                          color: Colors.blueGrey.shade600,
                                          fontWeight: FontWeight.bold)),
                                  HeightSpace(height: DPadding.half / 2),
                                  Text(
                                    response.reason,
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
        ));
  }
}
