import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../controllers/PrebookController.dart';

class PrebookDropDown extends StatefulWidget {

  String title;
  PrebookController prebookController;
  String value;
  List<String> options;
  FocusNode focusNode;
  bool required;
  int index;

  PrebookDropDown(this.title, this.prebookController, this.value, this.options, this.focusNode, this.required, this.index, {super.key});

  @override
  State<PrebookDropDown> createState() => _PrebookDropDownState();
}

class _PrebookDropDownState extends State<PrebookDropDown> {

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          color: DColors.background
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${widget.title} ${widget.required?"*": ''}",
            style: TextStyle(color: Colors.black),
          ),
          const HeightSpace(),
          Container(
            padding: EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(
              color: DColors.white,
              borderRadius: BorderRadius.circular(DPadding.half),
            ),
            child: DropdownButton<String>(
              focusNode: widget.focusNode,
              isExpanded: true,
              value: widget.prebookController.dropDownValues[widget.index],
              icon: const Icon(Icons.arrow_drop_down_outlined),
              elevation: 16,
              style: const TextStyle(color: DColors.black,),
              autofocus: widget.value==widget.options[0],
              underline: Container(
                height: widget.value==widget.options[0]? widget.prebookController.dropDownULHeight: 1,
                color: widget.value==widget.options[0]? widget.prebookController.dropDownULColor: DColors.primary,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  widget.prebookController.dropDownValues[widget.index] = value!;
                  widget.value = value!;
                });
              },
              items: widget.options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],),
    );
  }
}



/*
*
*
*
*  Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      color: DColors.background
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                    ],),
                ),
                *
                *
                * */
