// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/BodyScreen.dart';
import 'EmployeeFiredRequestScreen.dart';
import '../controllers/EmployeeFiredController.dart';
import 'package:neways3/src/utils/constants.dart';

class FiredEmployeeScreen extends StatelessWidget {
  const FiredEmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DColors.background,
      appBar: AppBar(
        leading: InkWell(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back_ios_new_rounded)),
        title: const Text("Fired Employee"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () async {
                await Get.put(EmployeeFiredController()).getAllData();
              },
              icon: const Icon(Icons.replay_outlined)),
        ],
      ),
      floatingActionButton: TextButton.icon(
        onPressed: () async {
          await Get.put(EmployeeFiredController()).getEmployee();
          await Get.to(const EmployeeFiredRequestScreen());
        },
        style: TextButton.styleFrom(
          backgroundColor: DColors.card,
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(29)),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Fired Request'),
      ),
      body: const BodyScreen(),
    );
  }
}
