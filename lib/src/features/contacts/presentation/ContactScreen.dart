// ignore_for_file: file_names, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:neways3/src/features/contacts/controllers/ContactController.dart';
import 'package:neways3/src/features/contacts/models/employee_response_model.dart';
import 'package:neways3/src/features/contacts/presentation/ContactDetailsScreen.dart';
import 'package:neways3/src/features/task/widgets/ContactPerson.dart';
import 'package:neways3/src/utils/constants.dart';
import 'package:flutter_switch/flutter_switch.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));


    return SafeArea(
      child: Scaffold(
        body: GetBuilder<ContactController>(
            init: ContactController(),
            builder: (controller) {
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: DPadding.full, vertical: DPadding.half),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Contacts", style: DTextStyle.textTitleStyle2),
                        Visibility(
                          visible:
                              GetStorage().read("roleName") == "Super Admin",
                          child: FlutterSwitch(
                            activeText: "Active",
                            inactiveText: "In-Active",
                            value: controller.isEmployeeStatus,
                            valueFontSize: 13.0,
                            width: 95,
                            height: 32,
                            activeColor: DColors.primary,
                            activeTextColor: Colors.white,
                            inactiveColor: Colors.black,
                            inactiveTextColor: Colors.white,
                            borderRadius: 30.0,
                            showOnOff: true,
                            onToggle: (val) {
                              controller.isEmployeeStatus = val;
                              controller.update();
                              controller.getAllEmployee(size: 20);
                            },
                          ),
                        ),
                      ],
                    ),
                    HeightSpace(height: DPadding.half),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius:
                                  BorderRadius.circular(DPadding.half / 2),
                            ),
                            child: TextField(
                              controller: controller.searchController,
                              onChanged: (value) => controller.search(value),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 0),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  hintText: "Search",
                                  hintStyle: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14),
                                  prefixIcon: const Icon(Icons.search)),
                            ),
                          ),
                          HeightSpace(height: DPadding.full),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Neways International Company",
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              Visibility(
                                visible: GetStorage().read("roleName") ==
                                    "Super Admin",
                                child: Text(
                                  "(${controller.isEmployeeStatus ? 'Current Employee' : 'Ex-Employee'})",
                                  style: TextStyle(color: Colors.grey.shade800),
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                controller: controller.scrollController,
                                itemCount: controller.employees.length,
                                itemBuilder: (context, index) {
                                  EmployeeResponseModel employee =
                                      controller.employees[index];
                                  onItemTap(EmployeeResponseModel selectedEmployee){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ContactDetailsScreen(employee: selectedEmployee),
                                        ));
                                  }
                                  return ContactPerson(employee: employee, onItemTap: onItemTap,);
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}

