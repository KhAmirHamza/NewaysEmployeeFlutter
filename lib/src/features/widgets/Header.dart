import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neways3/src/utils/constants.dart';

class Header extends StatelessWidget {
  const Header({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DPadding.half),
              color: DColors.background,
            ),
            child: const Icon(Icons.arrow_back, color: DColors.primary),
          ),
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: DColors.primary),
          ),
        ),
      ],
    );
  }
}
