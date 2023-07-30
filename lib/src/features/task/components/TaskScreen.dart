import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/constants.dart';
import '../controllers/TaskController.dart';
import 'DepartmentTaskScreen.dart';
import 'TaskCreateScreen.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return GetBuilder<TaskController>(
        init: TaskController(),
        builder: (controller) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (isDepHead) controller.getEmployee();
                Get.to( TaskCreateScreen());
              },
              backgroundColor: Colors.green,
              child: const Icon(Icons.add),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(DPadding.full),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(DPadding.half),
                                color: DColors.background,
                              ),
                              child: const Icon(Icons.arrow_back,
                                  color: DColors.primary),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Task Manager",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.quicksand(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  color: DColors.primary),
                            ),
                          ),
                          WidthSpace(width: DPadding.full * 1.5),
                        ],
                      ),
                      const HeightSpace(),
                      SingleChildScrollView(
                        controller: controller.scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "My lists",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.quicksand(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            const HeightSpace(),
                            Row(
                              children: [
                                Expanded(
                                  child: Card(
                                    elevation: 5,
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: DPadding.half,
                                          vertical: DPadding.full * 2.5),
                                      child: const Text(
                                        "Reminders",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      controller.departmentName = "Personal";
                                      controller.getData();
                                      controller.update();
                                      Get.to(const DepartmentTaskScreen());
                                    },
                                    child: Card(
                                      elevation: 5,
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: DPadding.half,
                                            vertical: DPadding.full * 2.5),
                                        child: const Text(
                                          "Personal",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const HeightSpace(),
                            Text(
                              "Workspace",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.quicksand(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            const HeightSpace(),
                            GridView.builder(
                                controller: controller.scrollController,
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 200,
                                        childAspectRatio: 3 / 2,
                                        crossAxisSpacing: 20,
                                        mainAxisSpacing: 20),
                                itemCount: controller.departments.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  var department =
                                      controller.departments[index];
                                  return InkWell(
                                    onTap: () {
                                      controller.departmentName =
                                          department['name'].toString();
                                      controller.getData();
                                      controller.update();
                                      Get.to(const DepartmentTaskScreen());
                                    },
                                    child: Card(
                                      elevation: 5,
                                      child: Stack(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: DPadding.half,
                                                vertical: DPadding.full * 2.5),
                                            child: Text(
                                              department['name'].toString(),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                          Positioned(
                                              right: 5,
                                              top: 5,
                                              child: Container(
                                                padding: EdgeInsets.all(
                                                    DPadding.half),
                                                decoration: BoxDecoration(
                                                    color: DColors.card,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100)),
                                                child: Text(
                                                  "${department['task'].toString().length == 1 ? '0' : ''}${department['task'].toString()}",
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
