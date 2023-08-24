import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neways3/src/features/task/components/DepartmentTaskScreen.dart';

import '../../../utils/constants.dart';
import '../../contacts/controllers/ContactController.dart';
import '../../contacts/models/employee_response_model.dart';
import '../../contacts/presentation/ContactDetailsScreen.dart';
import '../widgets/ContactPerson.dart';

class DHeadTaskApproval extends StatefulWidget {

  @override
  State<DHeadTaskApproval> createState() => _DHeadTaskApprovalState();
}

class _DHeadTaskApprovalState extends State<DHeadTaskApproval> {

  ContactController? contactController;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //contactController==null? contactController = ContactController(): {};
    //  contactController!.getAllEmployee(size: 20, department_name: "S & IT");
    });

    return SafeArea(
      child: Scaffold(
        body: GetBuilder<ContactController>(
          init: ContactController(departmentName: "S & IT"),
            builder: (controller) {
            print("Check loop: Step:1");
             // contactController = controller;
              //controller.checkLoop();
             // controller.getAllEmployee(size: 20, department_name: "S & IT");
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: DPadding.full, vertical: DPadding.half),
                child: Column(
                  children: [
                    Text("Select Employee", style: DTextStyle.textTitleStyle2),
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
                              onChanged: (value) => controller.search(value, departmentName: "S & IT"),
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
                                          builder: (context) => const DepartmentTaskScreen(departmentName: "S & IT",),
                                        ));
                                  }
                                  return ContactPerson(employee: employee, onItemTap:onItemTap);
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
