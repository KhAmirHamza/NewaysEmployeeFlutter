// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neways3/src/utils/textfiled.dart';
import '../controllers/PurchaseMoneyRequestController.dart';
import 'package:neways3/src/utils/constants.dart';

class PurchaseMoneyAddItemScreen extends StatelessWidget {
  const PurchaseMoneyAddItemScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PurchaseMoneyRequestController>(
        init: PurchaseMoneyRequestController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Add Purchase Money Item'),
              centerTitle: true,
              elevation: 0,
            ),
            body: Padding(
              padding: EdgeInsets.all(DPadding.half),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeightSpace(),
                    AppTextField(
                      textEditingController: controller.itemController,
                      title: "Item",
                      hint: "Choose Purchase Item",
                      isListSelected: true,
                      list: controller.items,
                    ),
                    const HeightSpace(),
                    Text(
                      "Quantity",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const HeightSpace(),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(DPadding.half / 2),
                      ),
                      child: TextFormField(
                        controller: controller.qtyController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          hintText: "Enter Item Quantity ",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    HeightSpace(height: DPadding.full),
                    SizedBox(
                      height: 40,
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: DColors.primary,
                        ),
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          await controller.setPurchaseItem();

                          // Get.snackbar('Success', "Item Add Successfull",
                          //     snackPosition: SnackPosition.BOTTOM,
                          //     margin: EdgeInsets.all(DPadding.full));
                        },
                        child: Text("Add Item".toUpperCase()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
