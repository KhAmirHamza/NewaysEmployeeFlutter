import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:neways3/src/features/prebook/controllers/PrebookController.dart';

class MultipleChipsChoice extends StatefulWidget {
  const MultipleChipsChoice({super.key});

  @override
  State<MultipleChipsChoice> createState() => _MultipleChipsChoiceState();
}

class _MultipleChipsChoiceState extends State<MultipleChipsChoice> {

  @override
  Widget build(BuildContext context) {

    return ChipsChoice<String>.multiple(

      value: PrebookController.selectedQualifications,
      onChanged: (val) => setState(() => PrebookController.selectedQualifications = val),
      choiceItems: C2Choice.listFrom<String, String>(
        source: PrebookController.qualifications,
        value: (i, v) => v,
        label: (i, v) => v,
      ),
        
        choiceCheckmark: true,
        choiceStyle: C2ChipStyle.outlined(),
    );
  }
}
