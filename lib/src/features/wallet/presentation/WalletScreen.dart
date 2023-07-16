// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neways3/src/features/wallet/controller/WalletController.dart';
import 'package:neways3/src/utils/constants.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<WalletController>(
          init: WalletController(),
          builder: (controller) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeightSpace(height: DPadding.full),
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
                    HeightSpace(height: DPadding.full),
                    Padding(
                      padding: EdgeInsets.all(DPadding.full),
                      child: Text(
                        "Current wallet balance",
                        style: GoogleFonts.barlowCondensed(
                            fontSize: 20, color: Colors.grey.shade500),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(DPadding.full),
                      child: RichText(
                        text: TextSpan(children: [
                          WidgetSpan(
                            child: Transform.translate(
                              offset: const Offset(2, -20),
                              child: Text(
                                '৳',
                                //superscript is usually smaller in size
                                textScaleFactor: 1.8,
                                style: TextStyle(color: Colors.grey.shade800),
                              ),
                            ),
                          ),
                          TextSpan(
                              text:
                                  ' ${double.parse(controller.currentSalary.wallet.toString())}',
                              style: GoogleFonts.barlowCondensed(
                                  color: Colors.grey.shade700, fontSize: 52)),
                          WidgetSpan(
                            child: Transform.translate(
                              offset: const Offset(2, 0),
                              child: Text(
                                ' BDT',
                                //superscript is usually smaller in size
                                textScaleFactor: 1.2,
                                style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ]),
                      ),
                    ),
                    HeightSpace(height: DPadding.full),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(left: DPadding.full),
                      padding: EdgeInsets.all(DPadding.full),
                      height: 200,
                      decoration: const BoxDecoration(
                        color: DColors.primary,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            bottomLeft: Radius.circular(25)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.payments_outlined,
                                color: Colors.white,
                                size: 24,
                              ),
                              HeightSpace(height: DPadding.half),
                              Text(
                                "৳ ${30 * (double.parse(controller.currentSalary.basicSalary.toString()) + double.parse(controller.currentSalary.increament.toString()) - double.parse(controller.currentSalary.decreament.toString()))}",
                                style: GoogleFonts.barlowCondensed(
                                    color: Colors.white, fontSize: 24),
                              ),
                              HeightSpace(height: DPadding.half),
                              Text(
                                "your monthly salary",
                                style: GoogleFonts.quicksand(
                                    color: Colors.white, fontSize: 16),
                              )
                            ],
                          ),
                          const WidthSpace(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.monetization_on_outlined,
                                color: Colors.white,
                                size: 24,
                              ),
                              HeightSpace(height: DPadding.half),
                              Text(
                                "${(double.parse(controller.currentSalary.basicSalary.toString()) + double.parse(controller.currentSalary.increament.toString()) - double.parse(controller.currentSalary.decreament.toString()))}",
                                style: GoogleFonts.barlowCondensed(
                                    color: Colors.white, fontSize: 24),
                              ),
                              HeightSpace(height: DPadding.half),
                              Text(
                                "your daily salary",
                                style: GoogleFonts.quicksand(
                                    color: Colors.white, fontSize: 16),
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
          }),
    );
  }
}
