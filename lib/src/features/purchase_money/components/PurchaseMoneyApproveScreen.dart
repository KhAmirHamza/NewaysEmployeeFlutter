// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/appbar.dart';
import '../controllers/PurchaseMoneyApproveController.dart';
import '../models/PurchaseMoneyResponse.dart';
import 'package:neways3/src/utils/constants.dart';
import 'package:neways3/src/utils/functions.dart';

class PurchaseMoneyApproveScreen extends StatelessWidget {
  const PurchaseMoneyApproveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DColors.background,
      appBar: buildAppBar(title: "Purchase Money Approve", actions: [
        IconButton(
            onPressed: () async {
              await Get.put(PurchaseMoneyApproveController()).getAllData();
            },
            icon: const Icon(Icons.replay_outlined)),
      ]),
      body: body(),
    );
  }

  Widget body() {
    return GetBuilder<PurchaseMoneyApproveController>(
      init: PurchaseMoneyApproveController(),
      builder: ((controller) => ListView.builder(
            itemCount: controller.responses.length,
            itemBuilder: (context, index) {
              PurchaseMoneyResponse response = controller.responses[index];
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
                              child: Image.network(response.photo!.toString(),
                                  width: 80, height: 80, fit: BoxFit.fill),
                            ),
                            WidthSpace(width: DPadding.full),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    response.fullName!.toString(),
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
                                                  await controller.action(
                                                      1, response);
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
                                                      hintText:
                                                          "Enter Purchase Money Approve Note ",
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
                                                  await controller.action(
                                                      2, response);
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
                                                      hintText:
                                                          "Enter Purchase Money Reject Note ",
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
                        Text(
                          response.projectName ?? "No Project Name",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const HeightSpace(),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Request Amount',
                                      style: TextStyle(
                                          color: Colors.blueGrey.shade600,
                                          fontWeight: FontWeight.bold)),
                                  HeightSpace(height: DPadding.half / 2),
                                  Text(
                                    '${response.requestAmount} BDT',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: response.dHeadApproval == 1,
                              child: Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('Final Amount',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            color: Colors.blueGrey.shade600,
                                            fontWeight: FontWeight.bold)),
                                    HeightSpace(height: DPadding.half / 2),
                                    Text(
                                      '${response.amount} BDT',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        HeightSpace(height: DPadding.full),
                        Visibility(
                          visible: response.products.isNotEmpty,
                          child: Wrap(
                            children: response.products.isEmpty
                                ? []
                                : response.products
                                    .map((e) => Container(
                                        padding: EdgeInsets.all(DPadding.half),
                                        margin: EdgeInsets.only(
                                            right: DPadding.half,
                                            bottom: DPadding.half),
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(
                                                DPadding.half)),
                                        child: Text(
                                            "${e.name} (${e.requestedQty})")))
                                    .toList(),
                          ),
                        ),
                        HeightSpace(height: DPadding.full),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Purpose Reason',
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
