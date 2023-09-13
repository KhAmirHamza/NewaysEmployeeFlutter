// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neways3/src/utils/textfiled.dart';
import '../controllers/PurchaseMoneyRequestController.dart';
import 'package:neways3/src/utils/constants.dart';

import 'PurchaseMoneyAddItemScreen.dart';

class PurchaseMoneyRequestScreen extends StatelessWidget {
  const PurchaseMoneyRequestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PurchaseMoneyRequestController>(
        init: PurchaseMoneyRequestController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                  'Purchase Money ${controller.isUpdate ? 'Re-submit' : 'Request'}'),
              centerTitle: true,
              elevation: 0,
            ),
            body: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(DPadding.half),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const HeightSpace(),
                          Text(
                            "Project Name",
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          const HeightSpace(),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius:
                                  BorderRadius.circular(DPadding.half / 2),
                            ),
                            child: TextFormField(
                              controller: controller.projectController,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                hintText: "Enter Project Name (Max 30 Characters)",
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          const HeightSpace(),
                          Text(
                            "Amount (Price)",
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          const HeightSpace(),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius:
                                  BorderRadius.circular(DPadding.half / 2),
                            ),
                            child: TextFormField(
                              controller: controller.amountController,
                              keyboardType: TextInputType.number,
                              readOnly: controller.isEmployee,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                hintText: "Enter Project Amount ",
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                         /* const HeightSpace(),
                          Text(
                            "Purpose",
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          const HeightSpace(),
                          Container(
                            height: 65,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius:
                                  BorderRadius.circular(DPadding.half / 2),
                            ),
                            child: TextFormField(
                              controller: controller.purposeController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                hintText: "Enter Request Purpose ",
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),*/
                          HeightSpace(height: DPadding.full),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller.purchaseItems.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.all(DPadding.half),
                                margin: EdgeInsets.symmetric(
                                    vertical: DPadding.half),
                                decoration: BoxDecoration(
                                    color: DColors.card,
                                    borderRadius:
                                        BorderRadius.circular(DPadding.half)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Item (Qty)",
                                          style: TextStyle(
                                              color: DColors.primary,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const HeightSpace(),
                                        Text(
                                          "${controller.purchaseItems[index]["name"]} (${controller.purchaseItems[index]["quantity"]})",
                                          style: const TextStyle(
                                              color: DColors.primary),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          controller.purchaseItems
                                              .removeAt(index);
                                          controller.update();
                                        },
                                        icon: const Icon(Icons.delete_forever,
                                            color: Colors.red))
                                  ],
                                ),
                              );
                            },
                          ),
                          HeightSpace(height: DPadding.full),
                          SizedBox(
                            height: 40,
                            width: double.infinity,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  side:
                                      const BorderSide(color: DColors.primary)),
                              onPressed: () =>
                                  Get.to(const PurchaseMoneyAddItemScreen()),
                              child: Text("Add Item".toUpperCase()),
                            ),
                          ),
                          HeightSpace(height: DPadding.full),
                          Visibility(
                            visible: !controller.isUpdate,
                            child: Row(
                              children: [
                                SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Checkbox(
                                        value: controller.isEmployee,
                                        onChanged: (value) =>
                                            controller.setEmployee(value))),
                                const WidthSpace(),
                                const Text("Forward Requisition?")
                              ],
                            ),
                          ),
                          HeightSpace(height: DPadding.full),
                          Visibility(
                            visible: controller.isEmployee,
                            child: AppTextField(
                              textEditingController:
                                  controller.employeeController,
                              title: "Employee",
                              hint: "Choose Employee Account",
                              isListSelected: true,
                              list: controller.employees,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    var status;
                    if (controller.isUpdate) {
                      status = await controller.reSubmitRequest();
                    } else {
                      status = await controller.submitRequest();
                    }
                    if (status == true) {
                      Get.back();
                    }
                    Get.snackbar('Message', controller.message!,
                        snackPosition: SnackPosition.BOTTOM,
                        margin: EdgeInsets.all(DPadding.full));
                  },
                  child: Container(
                    // height: 40,
                    width: double.infinity,
                    color: DColors.primary,
                    padding: EdgeInsets.all(DPadding.full),
                    alignment: Alignment.center,
                    child: Text(
                      controller.isUpdate
                          ? "Re-Request For Purchase Money".toUpperCase()
                          : "Request For Purchase Money".toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
