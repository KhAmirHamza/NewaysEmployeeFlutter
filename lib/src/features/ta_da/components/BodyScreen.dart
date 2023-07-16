import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants.dart';
import '../../../utils/functions.dart';
import '../bloc/TADAController.dart';
import '../models/TADAResponse.dart';
import '../widgets/getStatus.dart';

class BodyScreen extends StatelessWidget {
  const BodyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TADAController>(
      init: TADAController(),
      builder: ((controller) => ListView.builder(
            itemCount: controller.responses.length,
            itemBuilder: (context, index) {
              TadaResponse response = controller.responses[index];
              print(response.departmentHeadAproval);
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
                            Text(response.transportDate,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.blueGrey.shade600,
                                    fontWeight: FontWeight.bold)),
                            getStatus(response: response),
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
                        Visibility(
                            visible: (response.status == '1' &&
                                    response.departmentHeadAproval == '0' &&
                                    response.accountsAproval == '0' &&
                                    response.bossAproval == '0' &&
                                    response.selfAproval == '0') ||
                                (response.status == '1' &&
                                    response.departmentHeadAproval == '1' &&
                                    response.accountsAproval == '0' &&
                                    response.bossAproval == '0' &&
                                    response.selfAproval == '0' &&
                                    isDepHead) ||
                                (response.departmentHeadAproval == '1' &&
                                    response.bossAproval == '1' &&
                                    response.accountsAproval == '1' &&
                                    response.selfAproval == '0'),
                            child: const Divider()),
                        Visibility(
                          visible: (response.status == '1' &&
                                  response.departmentHeadAproval == '0' &&
                                  response.accountsAproval == '0' &&
                                  response.bossAproval == '0' &&
                                  response.selfAproval == '0') ||
                              (response.status == '1' &&
                                  response.departmentHeadAproval == '1' &&
                                  response.accountsAproval == '0' &&
                                  response.bossAproval == '0' &&
                                  response.selfAproval == '0' &&
                                  isDepHead),
                          child: Align(
                            alignment: Alignment.center,
                            child: TextButton.icon(
                                onPressed: () => defaultDialog(
                                      title:
                                          "Are you sure delete this request?",
                                      okPress: () async {
                                        await controller.delete(response.id);
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
                                label: const Text('Delete')),
                          ),
                        ),
                        Visibility(
                          visible: (response.departmentHeadAproval == '1' &&
                              response.bossAproval == '1' &&
                              response.accountsAproval == '1' &&
                              response.selfAproval == '0'),
                          child: Align(
                            alignment: Alignment.center,
                            child: TextButton.icon(
                                onPressed: () => defaultDialog(
                                      title:
                                          "Are you received your TA/DA money?",
                                      okPress: () async {
                                        await controller
                                            .moneyReceived(response.id);
                                      },
                                      widget: const SizedBox(),
                                    ),
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.blue,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: DPadding.full),
                                    backgroundColor:
                                        Colors.blue.withOpacity(0.2)),
                                icon: const Icon(Icons.payments, size: 18),
                                label: const Text('Money Received')),
                          ),
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
