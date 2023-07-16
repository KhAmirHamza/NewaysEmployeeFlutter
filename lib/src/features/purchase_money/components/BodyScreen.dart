// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/PurchaseMoneyController.dart';
import '../controllers/PurchaseMoneyRequestController.dart';
import '../models/PurchaseMoneyResponse.dart';
import '../widgets/getStatus.dart';
import 'package:neways3/src/utils/constants.dart';
import 'package:neways3/src/utils/functions.dart';

import 'PurchaseMoneyRequestScreen.dart';

class BodyScreen extends StatelessWidget {
  const BodyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PurchaseMoneyController>(
      init: PurchaseMoneyController(),
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
                    padding: EdgeInsets.all(DPadding.half),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                response.projectName ?? "None",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            getStatus(
                                aproval: response.status,
                                hAproval: response.dHeadApproval),
                          ],
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Purpose',
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
                        const HeightSpace(),
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
                        Visibility(
                            visible: response.status == '0' ||
                                response.status == '1' ||
                                response.status == '3' ||
                                response.dHeadApproval.toString() == '2' ||
                                response.status == '5',
                            child: const Divider()),
                        Visibility(
                          visible: (response.status == '1' &&
                                  response.dHeadApproval == 0) ||
                              (response.status == '1' &&
                                  response.dHeadApproval == 1 &&
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
                          visible: response.status == '3' ||
                              response.dHeadApproval.toString() == '2' ||
                              response.status == '5',
                          child: Align(
                            alignment: Alignment.center,
                            child: TextButton.icon(
                                onPressed: () async {
                                  await Get.put(
                                          PurchaseMoneyRequestController())
                                      .setResubmitData(response);
                                  await Get.to(
                                      const PurchaseMoneyRequestScreen());
                                  await controller.getAllData();
                                },
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.cyan,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: DPadding.full),
                                    backgroundColor:
                                        Colors.cyan.withOpacity(0.2)),
                                icon: const Icon(Icons.recycling, size: 18),
                                label: const Text('Re-Submit')),
                          ),
                        ),
                        Visibility(
                          visible: response.status == '4',
                          child: Align(
                            alignment: Alignment.center,
                            child: TextButton.icon(
                                onPressed: () => defaultDialog(
                                      title:
                                          "Are you received your purchase money?",
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
                        Visibility(
                          visible: response.status == '0',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton.icon(
                                  onPressed: () {
                                    // controller.amountController.text =
                                    //     response.requestAmount.toString();
                                    defaultDialog(
                                      title:
                                          "Are you sure accept this request?",
                                      okPress: () async {
                                        if (controller
                                            .amountController.text.isEmpty) {
                                          Get.snackbar('Wrong',
                                              "Amount must be required",
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              margin: EdgeInsets.all(
                                                  DPadding.full));
                                        }
                                        await controller.accept(response.id);
                                      },
                                      widget: Container(
                                        height: 45,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(
                                              DPadding.half / 2),
                                        ),
                                        child: TextFormField(
                                          controller:
                                              controller.amountController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 8),
                                            border: const OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                            hintText: "Enter Purchase Amount",
                                            hintStyle: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: DPadding.full),
                                      backgroundColor: DColors.background),
                                  icon: const Icon(Icons.check, size: 18),
                                  label: const Text('Approve')),
                              TextButton.icon(
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
                            ],
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
