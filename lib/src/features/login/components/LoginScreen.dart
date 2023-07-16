// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:neways3/src/features/login/controller/LoginController.dart';
import 'package:neways3/src/features/main/MainPage.dart';
import 'package:neways3/src/features/message/controllers/SocketController.dart';
import 'package:neways3/src/utils/constants.dart';

import 'ForgotPasswordScreen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white.withOpacity(0.0),
        statusBarIconBrightness: Brightness.dark));
    return GetBuilder<LoginController>(
        init: LoginController(),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: !controller.visibleUser
                              ? Alignment.topLeft
                              : Alignment.center,
                          child: Image.asset(
                            "assets/images/splash.png",
                            fit: BoxFit.cover,
                            width: !controller.visibleUser
                                ? size.width * .35
                                : size.width * .5,
                          ),
                        ),
                        Visibility(
                            visible: controller.visibleUser,
                            child: const HeightSpace()),
                        Visibility(
                          visible: controller.visibleUser,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(DPadding.half),
                            child: Image.network(
                              "${controller.box.read("avater")}",
                              fit: BoxFit.cover,
                              width: size.width * .15,
                              height: size.width * .15,
                            ),
                          ),
                        ),
                        const HeightSpace(),
                        Visibility(
                          visible: !controller.visibleUser,
                          child: Text(
                            "Welcome to Neways",
                            style: TextStyle(
                                fontSize: 26,
                                color: Colors.grey.shade900,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Visibility(
                          visible: controller.visibleUser,
                          child: Text(
                            "Hello, ${controller.box.read('firstName')}",
                            style: TextStyle(
                                fontSize: 26,
                                color: Colors.grey.shade900,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const HeightSpace(height: 20),
                        Visibility(
                          visible: !controller.sendOtp,
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
                              const HeightSpace(),
                              Text(
                                "Password",
                                style: TextStyle(color: Colors.grey.shade700),
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
                                      hintText: "Enter Password",
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 14),
                                      suffixIcon: IconButton(
                                        icon: Icon(Icons.remove_red_eye,
                                            color: controller.obscureText
                                                ? Colors.grey.shade300
                                                : DColors.primary),
                                        onPressed: () =>
                                            controller.setObscureText(),
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: controller.sendOtp,
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
                        HeightSpace(height: DPadding.full),
                        SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () async {
                              if (controller.sendOtp) {
                                if (controller.verify()) {
                                  Get.snackbar(
                                      'Message', "Account Login Successfull!",
                                      snackPosition: SnackPosition.BOTTOM,
                                      margin: EdgeInsets.all(DPadding.full));
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MainPage(socket!, 2)));
                                } else {
                                  Get.snackbar('Message', "OTP is not valid!",
                                      snackPosition: SnackPosition.BOTTOM,
                                      margin: EdgeInsets.all(DPadding.full));
                                }
                              } else {
                                var status = await controller.login();
                                if (status == false) {
                                  Get.snackbar('Message',
                                      "Unauthorized User! Enter Valid employee ID and Password.",
                                      snackPosition: SnackPosition.BOTTOM,
                                      margin: EdgeInsets.all(DPadding.full));
                                }
                              }
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: DColors.primary,
                            ),
                            child: Text(controller.sendOtp
                                ? "Verify".toUpperCase()
                                : "Login".toUpperCase()),
                          ),
                        ),
                        const HeightSpace(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Checkbox(
                                      activeColor: DColors.primary,
                                      value: controller.isRemember,
                                      onChanged: (value) =>
                                          controller.setRemember(value),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ),
                                  const WidthSpace(),
                                  const Text(
                                    "Remember Me",
                                    style: TextStyle(
                                        color: DColors.primary,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () => Get.to(const ForgotPasswordScreen()),
                              child: Text(
                                "Forgot Password",
                                style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontWeight: FontWeight.normal),
                              ),
                            )
                          ],
                        )
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
