// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:neways3/src/features/main/MainPage.dart';
import 'package:neways3/src/utils/constants.dart';

import '../controller/ForgotPasswordController.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white.withOpacity(0.0),
        statusBarIconBrightness: Brightness.dark));
    return GetBuilder<ForgotPasswordController>(
        init: ForgotPasswordController(),
        builder: (controller) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  Opacity(
                    opacity: 0.8,
                    child: Image.asset(
                      "assets/images/background.png",
                      fit: BoxFit.cover,
                      width: size.width,
                      height: size.height,
                    ),
                  ),
                  Positioned(
                    top: !controller.visibleUser
                        ? size.height * .2
                        : size.height * .15,
                    left: DPadding.full,
                    right: DPadding.full,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/images/splash.png",
                            fit: BoxFit.cover,
                            width: size.width * .5,
                          ),
                        ),
                        const HeightSpace(),
                        Text(
                          "Send otp in your neways accounts mobile number for forgot password.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 21,
                              color: Colors.grey.shade900,
                              fontWeight: FontWeight.bold),
                        ),
                        const HeightSpace(height: 20),
                        Visibility(
                          visible: controller.step1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Employee ID",
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                              const HeightSpace(),
                              Container(
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(DPadding.half / 2),
                                ),
                                child: TextField(
                                  controller: controller.employeeId,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 0),
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    hintText: "Enter Employee ID",
                                    hintStyle: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: controller.step2,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(DPadding.half / 2),
                            ),
                            child: TextField(
                              controller: controller.otpController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 0),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                hintText: "Enter 4 digit otp",
                                hintStyle: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: controller.step3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "New Password",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const HeightSpace(),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(DPadding.half / 2),
                                ),
                                child: TextField(
                                  controller: controller.password,
                                  obscureText: controller.obscureText,
                                  decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 0),
                                      border: const OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      hintText: "Enter New Password",
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 14),
                                      suffixIcon: const Icon(Icons.lock)),
                                ),
                              ),
                              const HeightSpace(),
                              Text(
                                "Confirm Password",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const HeightSpace(),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(DPadding.half / 2),
                                ),
                                child: TextField(
                                  controller: controller.confirmPassword,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 0),
                                      border: const OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      hintText: "Enter Confirm Password",
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 14),
                                      suffixIcon: const Icon(Icons.lock)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        HeightSpace(height: DPadding.full),
                        SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () async {
                              if (controller.step1) {
                                if (await controller.sendNewOtp() == true) {
                                  Get.snackbar(
                                      'Message', "Otp send Successfull!",
                                      snackPosition: SnackPosition.BOTTOM,
                                      margin: EdgeInsets.all(DPadding.full));
                                }
                              } else if (controller.step2) {
                                await controller.verify();
                              } else if (controller.step3) {
                                await controller.forgotPassword();
                              }
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: DColors.primary,
                            ),
                            child: Text(controller.step1
                                ? "Send OTP".toUpperCase()
                                : (controller.step2
                                    ? "Verify".toUpperCase()
                                    : "Change".toUpperCase())),
                          ),
                        ),
                        const HeightSpace(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
