// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neways3/src/utils/constants.dart';

import '../controllers/AdvanceSalaryController.dart';
import 'AdvanceSalaryRequestScreen.dart';
import 'BodyScreen.dart';

class AdvanceSalaryScreen extends StatelessWidget {
  const AdvanceSalaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DColors.background,
      appBar: AppBar(
        leading: InkWell(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back_ios_new_rounded)),
        title: const Text("Advance Salary"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () async {
                await Get.put(AdvanceSalaryController()).getAllData();
              },
              icon: const Icon(Icons.replay_outlined)),
        ],
      ),
      floatingActionButton: TextButton.icon(
        onPressed: () => Get.to(const AdvanceSalaryRequestScreen()),
        style: TextButton.styleFrom(
          backgroundColor: DColors.card,
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(29)),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Advance Salary Request'),
      ),
      body: const BodyScreen(),
    );
  }
}
