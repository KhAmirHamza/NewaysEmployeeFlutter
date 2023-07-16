import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/constants.dart';
import 'controllers/SecurityController.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SecurityController>(
          init: SecurityController(),
          builder: (controller) {
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeightSpace(height: DPadding.full),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                        "Security",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: DColors.primary),
                      ))
                    ],
                  ),
                  const HeightSpace(),
                  Padding(
                    padding: EdgeInsets.all(DPadding.half),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Old Password",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        const HeightSpace(),
                        Container(
                          decoration: BoxDecoration(
                            color: DColors.background,
                            borderRadius:
                                BorderRadius.circular(DPadding.half / 2),
                          ),
                          child: TextField(
                            controller: controller.oldPassword,
                            obscureText: true,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 0),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                hintText: "Enter old Password",
                                hintStyle: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 14),
                                suffixIcon: const Icon(Icons.lock)),
                          ),
                        ),
                        const HeightSpace(),
                        Text(
                          "New Password",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        const HeightSpace(),
                        Container(
                          decoration: BoxDecoration(
                            color: DColors.background,
                            borderRadius:
                                BorderRadius.circular(DPadding.half / 2),
                          ),
                          child: TextField(
                            controller: controller.newPassword,
                            obscureText: true,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 0),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                hintText: "Enter New Password",
                                hintStyle: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 14),
                                suffixIcon: const Icon(Icons.lock)),
                          ),
                        ),
                        const HeightSpace(),
                        Text(
                          "Confirm Password",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        const HeightSpace(),
                        Container(
                          decoration: BoxDecoration(
                            color: DColors.background,
                            borderRadius:
                                BorderRadius.circular(DPadding.half / 2),
                          ),
                          child: TextField(
                            controller: controller.confirmPassword,
                            obscureText: true,
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 0),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                hintText: "Enter Confirm Password",
                                hintStyle: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 14),
                                suffixIcon: const Icon(Icons.lock)),
                          ),
                        ),
                        HeightSpace(height: DPadding.full),
                        SizedBox(
                          height: 45,
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () async {
                              var status = await controller.submit();
                              if (status == false) {
                                Get.snackbar('Message',
                                    "Unauthorized User! Enter Valid employee ID and Password.",
                                    snackPosition: SnackPosition.BOTTOM,
                                    margin: EdgeInsets.all(DPadding.full));
                              }
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: DColors.primary,
                            ),
                            child: Text("Change Password".toUpperCase()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  HeightSpace(height: DPadding.full),
                ],
              ),
            );
          }),
    );
  }
}
