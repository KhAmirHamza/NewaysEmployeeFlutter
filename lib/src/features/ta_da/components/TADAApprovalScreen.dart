import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/appbar.dart';
import '../../../utils/constants.dart';
import '../../../utils/functions.dart';
import '../bloc/TADAApproveController.dart';
import '../bloc/TADAController.dart';
import '../models/TADAResponse.dart';
import '../widgets/getStatus.dart';

class TADAApprovalScreen extends StatelessWidget {
  const TADAApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        title: "TA/DA Approve",
        actions: [
          IconButton(
              onPressed: () async {
                await Get.put(TADAApproveController()).getAllData();
              },
              icon: const Icon(Icons.replay_outlined)),
        ],
      ),
      body: GetBuilder<TADAApproveController>(
        init: TADAApproveController(),
        builder: ((controller) => ListView.builder(
              itemCount: controller.responses.length,
              itemBuilder: (context, index) {
                TadaResponse response = controller.responses[index];
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: DPadding.half, vertical: DPadding.half),
                  child: Card(
                    elevation: 0,
                    color: Colors.grey.shade200,
                    child: Padding(
                      padding: EdgeInsets.all(DPadding.half),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.network(
                                        response.photo!.toString(),
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.fill),
                                  ),
                                  const WidthSpace(),
                                  Text(
                                    response.fullName!.toString(),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Text(response.transportDate,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blueGrey.shade600,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const HeightSpace(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('From',
                                      style: TextStyle(
                                          color: Colors.blueGrey.shade600,
                                          fontWeight: FontWeight.normal)),
                                  HeightSpace(height: DPadding.half / 2),
                                  Text(response.destinationFrom,
                                      style: TextStyle(
                                          color: Colors.blueGrey.shade600,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('To',
                                      style: TextStyle(
                                          color: Colors.blueGrey.shade600,
                                          fontWeight: FontWeight.normal)),
                                  HeightSpace(height: DPadding.half / 2),
                                  Text(response.destinationTo,
                                      style: TextStyle(
                                          color: Colors.blueGrey.shade600,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                          HeightSpace(height: DPadding.full),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Transport Type',
                                      style: TextStyle(
                                          color: Colors.blueGrey.shade600,
                                          fontWeight: FontWeight.normal)),
                                  HeightSpace(height: DPadding.half / 2),
                                  Text(
                                      "${response.vehicleType} (${response.transportType})",
                                      style: TextStyle(
                                          color: Colors.blueGrey.shade600,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('Transport Amount',
                                      style: TextStyle(
                                          color: Colors.blueGrey.shade600,
                                          fontWeight: FontWeight.normal)),
                                  HeightSpace(height: DPadding.half / 2),
                                  Text("BDT ${response.transportAmount}",
                                      style: TextStyle(
                                          color: Colors.blueGrey.shade600,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                          HeightSpace(height: DPadding.full),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Note',
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
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton.icon(
                                  onPressed: () => defaultDialog(
                                        title:
                                            "Are you sure approved this TA/DA?",
                                        okPress: () async {
                                          await controller
                                              .approved(response.id);
                                        },
                                        widget: const SizedBox(),
                                      ),
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.green,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: DPadding.full),
                                      backgroundColor:
                                          Colors.green.withOpacity(0.2)),
                                  icon: const Icon(Icons.check, size: 18),
                                  label: const Text('Approve')),
                              TextButton.icon(
                                  onPressed: () => defaultDialog(
                                        title:
                                            "Are you sure Reject this request?",
                                        okPress: () async {
                                          await controller
                                              .rejected(response.id);
                                        },
                                        widget: const SizedBox(),
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
