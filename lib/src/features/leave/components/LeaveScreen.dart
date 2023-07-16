// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neways3/src/features/leave/components/LeaveRequestScreen.dart';
import 'package:neways3/src/features/leave/components/BodyScreen.dart';
import 'package:neways3/src/features/leave/controllers/LeaveController.dart';
import 'package:neways3/src/utils/constants.dart';

class LeaveScreen extends StatelessWidget {
  const LeaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DColors.background,
      appBar: AppBar(
        leading: InkWell(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back_ios_new_rounded)),
        title: const Text("Leave"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () async {
                await Get.put(LeaveController()).getAllData();
              },
              icon: const Icon(Icons.replay_outlined)),
        ],
      ),
      floatingActionButton: TextButton.icon(
        onPressed: () => Get.to(const LeaveRequestScreen()),
        style: TextButton.styleFrom(
          backgroundColor: DColors.card,
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(29)),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Leave Request'),
      ),
      body: const BodyScreen(),
    );
  }
}
