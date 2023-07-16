import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/constants.dart';
import '../controllers/IncreamentController.dart';
import '../models/IncreamentResponse.dart';

class IncreamentScreen extends StatelessWidget {
  IncreamentScreen({super.key});
  bool isColor = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<IncreamentController>(
          init: IncreamentController(),
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
                        "Increaments/ Decreament",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.quicksand(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: DColors.primary),
                      ))
                    ],
                  ),
                  HeightSpace(height: DPadding.full),
                  Row(children: const [
                    Expanded(
                        child: Text(
                      "Type",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )),
                    Expanded(
                        child: Text(
                      "Date",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )),
                    Expanded(
                        child: Text(
                      "Amount",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )),
                  ]),
                  HeightSpace(height: DPadding.half),
                  const Divider(height: 0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.data.length,
                      itemBuilder: (context, index) =>
                          _customeCard(increament: controller.data[index]),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }

  Widget _customeCard({required Increament increament}) {
    isColor = !isColor;
    return Container(
      padding: EdgeInsets.symmetric(vertical: DPadding.half),
      color: isColor ? Colors.grey.shade200 : Colors.grey.shade100,
      child: Row(children: [
        Expanded(
            child: Text(
          increament.status ? "Increament" : "Decreament",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        )),
        Expanded(
            child: Text(
          increament.data,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        )),
        Expanded(
            child: Text(
          "${double.parse(increament.amount.toString()) * 30} TK / Month",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        )),
      ]),
    );
  }
}
