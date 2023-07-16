import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/appbar.dart';
import '../../../utils/constants.dart';
import '../bloc/TADAController.dart';
import 'BodyScreen.dart';
import 'TADARequestScreen.dart';

class TADAScreen extends StatelessWidget {
  const TADAScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        title: "TA/DA",
        actions: [
          IconButton(
              onPressed: () async {
                await Get.put(TADAController()).getAllData();
              },
              icon: const Icon(Icons.replay_outlined)),
        ],
      ),
      floatingActionButton: TextButton.icon(
        onPressed: () async {
          await Get.to(const TADARequestScreen());
          await Get.put(TADAController()).getAllData();
        },
        style: TextButton.styleFrom(
          backgroundColor: DColors.card,
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(29)),
        ),
        icon: const Icon(Icons.add),
        label: const Text('TA/DA Request'),
      ),
      body: const BodyScreen(),
    );
  }
}
