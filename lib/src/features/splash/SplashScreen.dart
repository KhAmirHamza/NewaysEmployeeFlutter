// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import './controller/SplashController.dart';
import 'package:neways3/src/utils/constants.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class SplashScreen extends StatefulWidget {
  final Socket socket;
  const SplashScreen(this.socket, {Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: DColors.primary,
        statusBarIconBrightness: Brightness.light));

    return Scaffold(
      backgroundColor: DColors.primary,
      body: GetBuilder<SplashController>(
          init: SplashController(widget.socket),
          builder: (controller) {
            controller.setContext(context);
            return SizedBox(
              height: size.height,
              width: size.width,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    "assets/images/splash.png",
                    fit: BoxFit.cover,
                    width: size.width * .35,
                  ),
                  Positioned(
                      bottom: DPadding.full,
                      child:
                      const CircularProgressIndicator(color: Colors.white))
                ],
              ),
            );
          }),
    );
  }
}
