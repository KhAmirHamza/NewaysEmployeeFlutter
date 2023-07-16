import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants.dart';
import '../controllers/PrebookController.dart';

class PrebookTextFiled extends StatefulWidget {

  TextEditingController textEditingController;
  String title;
  PrebookController prebookController;
  FocusNode focusNode;
  bool required;



  PrebookTextFiled(this.textEditingController, this.title, this.prebookController, this.focusNode, this.required, {super.key});

  @override
  State<PrebookTextFiled> createState() => _PrebookTextFiledState();
}

class _PrebookTextFiledState extends State<PrebookTextFiled> {
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
          decoration: BoxDecoration(
            color: DColors.white,
            borderRadius: BorderRadius.circular(DPadding.half),
          ),
          child: TextFormField(
            controller: widget.textEditingController,
            focusNode: widget.focusNode,
            //onTap: (){setState(() {});},
            //onTapOutside: (s){setState(() {});},
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(5, 3, 3, 3),
              border: const OutlineInputBorder(
                  borderSide: BorderSide.none
              ),

              errorText: widget.prebookController.fNameController.text.isEmpty && widget.prebookController.errorText.isNotEmpty? widget.prebookController.errorText: null,
              hintText: "Enter ${widget.title}",
              hintStyle: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],),
    );
  }
}
