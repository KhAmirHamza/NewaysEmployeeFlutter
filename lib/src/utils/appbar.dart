import 'package:flutter/material.dart';
import 'package:get/get.dart';

AppBar buildAppBar({required title, actions}) {
  return AppBar(
    leading: InkWell(
        onTap: () => Get.back(),
        child: const Icon(Icons.arrow_back_ios_new_rounded)),
    title: Text(title),
    centerTitle: true,
    elevation: 0,
    actions: actions,
  );
}
