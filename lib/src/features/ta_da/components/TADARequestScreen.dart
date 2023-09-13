// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/functions.dart';
import '../bloc/TADAController.dart';
import 'package:neways3/src/utils/textfiled.dart';
import 'package:neways3/src/utils/constants.dart';

class TADARequestScreen extends StatelessWidget {
  const TADARequestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TADAController>(
        init: TADAController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('TA/DA Request'),
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Destination From",
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
                                  readOnly: true,
                                  onTap: (() {
                                    onTextFieldTap(context,
                                        list: controller.locations,
                                        title: 'From', callback: (value) {
                                      controller.fromController.text = value;
                                      controller.update();
                                    });
                                  }),
                                  controller: controller.fromController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    hintText: "Select From ",
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              if(controller.fromController.text.toString()=="Other")
                                const HeightSpace(),
                              if(controller.fromController.text.toString()=="Other")
                                Text(
                                "Other Destination",
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                              if(controller.fromController.text.toString()=="Other")
                                const HeightSpace(),
                              if(controller.fromController.text.toString()=="Other")
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(DPadding.half / 2),
                                ),
                                child: TextField(
                                  controller: controller.fromOtherController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 8),
                                      border: const OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      hintText: "Enter other destination ",
                                      hintStyle: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    )
                                ),
                              )
                            ],
                          ),
                        ),
                        const WidthSpace(),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Destination To",
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
                                  readOnly: true,
                                  onTap: (() {
                                    onTextFieldTap(context,
                                        list: controller.locations,
                                        title: 'To', callback: (value) {
                                      controller.toController.text = value;
                                      controller.update();
                                    });
                                  }),
                                  controller: controller.toController,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    hintText: "Select To ",
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              if(controller.toController.text.toString()=="Other")
                              const HeightSpace(),
                              if(controller.toController.text.toString()=="Other")
                              Text(
                                "Other Destination",
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                              if(controller.toController.text.toString()=="Other")
                              const HeightSpace(),
                              if(controller.toController.text.toString()=="Other")
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(DPadding.half / 2),
                                ),
                                child: TextField(
                                    controller: controller.toOtherController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 8),
                                      border: const OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      hintText: "Enter other destination ",
                                      hintStyle: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14,
                                      ),
                                    )
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const HeightSpace(),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Select Date",
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                              const HeightSpace(),
                              Container(
                                height: 45,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius:
                                      BorderRadius.circular(DPadding.half / 2),
                                ),
                                child: TextButton.icon(
                                    onPressed: () async {
                                      controller.selectedDate = await pickDate(
                                        context,
                                        firstDate: DateTime.now().subtract(
                                            const Duration(days: 365)),
                                      );
                                      controller.update();
                                    },
                                    icon: const Icon(
                                        Icons.calendar_month_rounded),
                                    label:
                                        Text(getDate(controller.selectedDate))),
                              ),
                            ],
                          ),
                        ),
                        const WidthSpace(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Transport Amount",
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
                                  controller:
                                      controller.transportAmountController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    hintText: "Enter Transport Amount ",
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const HeightSpace(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Food Amount(If Used)",
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
                            controller: controller.foodAmountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              hintText: "Enter Food Amount",
                              hintStyle: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const HeightSpace(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Transport Type",
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
                            readOnly: true,
                            onTap: (() {
                              onTextFieldTap(context,
                                  list: controller.transportType,
                                  title: 'Transport Type', callback: (value) {
                                controller.transportTypeController.text = value;
                                controller.update();
                              });
                            }),
                            controller: controller.transportTypeController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              hintText: "Select Transport Type ",
                              hintStyle: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const HeightSpace(),
                    AppTextFieldMultiSelection(
                      textEditingController: controller.vehicleTypeController,
                      title: "Vehicle Type",
                      hint: "Vehicle Type",
                      list: controller.transportList,
                    ),
                    const HeightSpace(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Transportation Detail/Reason",
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
                            controller:
                                controller.transportationDetailController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              hintText: "Enter Detail",
                              hintStyle: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const HeightSpace(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Note",
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
                            controller: controller.noteController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              hintText: "Enter Note",
                              hintStyle: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const HeightSpace(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Vehicle Type Reason",
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
                            controller: controller.vehicleTypeReasonController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              hintText: "Enter Reason",
                              hintStyle: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const HeightSpace(),
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
                          await controller.submit();

                          // Get.snackbar('Success', "Item Add Successfull",
                          //     snackPosition: SnackPosition.BOTTOM,
                          //     margin: EdgeInsets.all(DPadding.full));
                        },
                        child: Text("Submit Request".toUpperCase()),
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
