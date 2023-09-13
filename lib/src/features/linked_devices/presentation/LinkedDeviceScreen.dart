import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/functions.dart';
import '../../../utils/constants.dart';
import '../controller/LinkedDeviceController.dart';

class LinkedDeviceScreen extends StatelessWidget {
  const LinkedDeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LinkedDeviceController>(
        init: LinkedDeviceController(),
        builder: (controller) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  HeightSpace(height: DPadding.half),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          margin: EdgeInsets.only(left: DPadding.half),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(DPadding.half),
                            color: DColors.background,
                          ),
                          child: const Icon(Icons.arrow_back,
                              color: DColors.primary),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Linked Devices",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.quicksand(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: DColors.primary),
                        ),
                      ),
                    ],
                  ),
                  HeightSpace(height: DPadding.half),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(DPadding.half),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/desktop-login.svg",
                             // width: Get.mediaQuery.size.width / 2,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                            HeightSpace(height: DPadding.half),
                            const Text(
                              "Use Neways Apps on other devices",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: DColors.primary,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18),
                            ),
                            HeightSpace(height: DPadding.half),
                            const Text(
                              "Use Neways Management System on Web,Desktop, and other devices.",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                            HeightSpace(height: DPadding.half),
                            SizedBox(
                              //width: Get.mediaQuery.size.width / 2,
                              width: 121,
                              height: 40,
                              child: TextButton(
                                  onPressed: () => controller.scanQR(),
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: DColors.primary,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                  child: const Text("Link a device")),
                            ),
                            const HeightSpace(),
                            const Divider(),
                            const HeightSpace(),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Devices Status",
                                style: GoogleFonts.quicksand(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade900),
                              ),
                            ),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Tap a device to log out.",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            HeightSpace(height: DPadding.half),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: controller.responses.length,
                              itemBuilder: (context, index) {
                                var data = controller.responses[index];
                                String icon = 'chrome.png';
                                if (data['device_type'] == 'Android') {
                                  icon = 'android.png';
                                }
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: DPadding.half),
                                  child: InkWell(
                                    onTap: () {
                                      defaultDialog(
                                        title:
                                            "Are you sure Logout ${data['device']}?",
                                        okPress: () async {
                                          Get.back();
                                          await controller.deviceLogout(
                                              data: data);
                                        },
                                        widget: const SizedBox(),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Image.asset("assets/images/$icon",
                                            width: 36,
                                            height: 36,
                                            fit: BoxFit.fill),
                                        const WidthSpace(),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${data['device']} (${data['device_type']})",
                                              style: TextStyle(
                                                  color: Colors.grey.shade900),
                                            ),
                                            Text(
                                              "Last login at ${getDateTime(DateTime.parse(data['datetime'].toString()))}",
                                              style: const TextStyle(color: Colors.grey),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
