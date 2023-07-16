// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/BodyScreen.dart';
import '../controllers/PurchaseMoneyRequestController.dart';
import './PurchaseMoneyRequestScreen.dart';
import '../controllers/PurchaseMoneyController.dart';
import 'package:neways3/src/utils/constants.dart';

class PurchaseMoneyScreen extends StatelessWidget {
  PurchaseMoneyScreen({super.key});
  final controller = Get.put(PurchaseMoneyController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DColors.background,
      appBar: AppBar(
        leading: InkWell(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back_ios_new_rounded)),
        title: const Text("Purchase Money"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () async {
                await Get.put(PurchaseMoneyController()).getAllData();
              },
              icon: const Icon(Icons.replay_outlined)),
        ],
      ),
      floatingActionButton: TextButton.icon(
        onPressed: () async {
          await Get.put(PurchaseMoneyRequestController()).clear();
          await Get.to(const PurchaseMoneyRequestScreen());
          await controller.getAllData();
        },
        style: TextButton.styleFrom(
          backgroundColor: DColors.card,
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(29)),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Purchase Money Request'),
      ),
      body: GetBuilder<PurchaseMoneyController>(
          init: PurchaseMoneyController(),
          builder: (controller) {
            return Column(
              children: [
                const HeightSpace(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: DPadding.full),
                  child: Row(
                    children: [
                      Expanded(
                          child: InkWell(
                        onTap: () async {
                          await controller.getAllData();
                        },
                        child: Container(
                          padding: EdgeInsets.all(DPadding.half),
                          decoration: BoxDecoration(
                              color: controller.isAll
                                  ? Colors.blue
                                  : DColors.primary,
                              borderRadius:
                                  BorderRadius.circular(DPadding.half)),
                          alignment: Alignment.center,
                          child: const Text(
                            "All",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )),
                      const WidthSpace(),
                      Expanded(
                          child: InkWell(
                        onTap: () async {
                          await controller.getPending();
                        },
                        child: Container(
                          padding: EdgeInsets.all(DPadding.half),
                          decoration: BoxDecoration(
                              color: controller.isPending
                                  ? Colors.blue
                                  : DColors.primary,
                              borderRadius:
                                  BorderRadius.circular(DPadding.half)),
                          alignment: Alignment.center,
                          child: const Text(
                            "Pending",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )),
                      const WidthSpace(),
                      Expanded(
                          child: InkWell(
                        onTap: () async {
                          await controller.getApprove();
                        },
                        child: Container(
                          padding: EdgeInsets.all(DPadding.half),
                          decoration: BoxDecoration(
                              color: controller.isApprove
                                  ? Colors.blue
                                  : DColors.primary,
                              borderRadius:
                                  BorderRadius.circular(DPadding.half)),
                          alignment: Alignment.center,
                          child: const Text(
                            "Approve",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )),
                      const WidthSpace(),
                      Expanded(
                          child: InkWell(
                        onTap: () async {
                          await controller.getReject();
                        },
                        child: Container(
                          padding: EdgeInsets.all(DPadding.half),
                          decoration: BoxDecoration(
                              color: controller.isReject
                                  ? Colors.blue
                                  : DColors.primary,
                              borderRadius:
                                  BorderRadius.circular(DPadding.half)),
                          alignment: Alignment.center,
                          child: const Text(
                            "Reject",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
                const Expanded(child: BodyScreen()),
              ],
            );
          }),
    );
  }
}
