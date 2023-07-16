import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neways3/src/features/prebook/controllers/PrebookController.dart';
import 'package:neways3/src/features/prebook/widgets/MultipleChipsChoice.dart';
import 'package:neways3/src/features/prebook/widgets/PrebookDropDown.dart';
import 'package:neways3/src/features/prebook/widgets/PrebookTextField.dart';
import '../../../utils/constants.dart';
import 'package:get/get.dart';
import '../../../utils/functions.dart';


class PrebookScreen extends StatefulWidget {
  const PrebookScreen({super.key});

  @override
  State<PrebookScreen> createState() => _PrebookScreenState();
}

class _PrebookScreenState extends State<PrebookScreen> {

  double screenHeight = 0;
  double screenWidth = 0;

  bool startAnimation = false;


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        startAnimation = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    int dropDownItemIndex = 0;

    return GetBuilder<PrebookController>(
      init: PrebookController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Prebook Employee'),
            centerTitle: true,
            elevation: 0,
          ),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.all(DPadding.half),
            children: [

              const Padding(padding: EdgeInsets.all(2.5),
                child: Text("Personal Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),),

              Padding(padding: const EdgeInsets.all(2.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: <Widget>[
                    /*
                      const HeightSpace(),
                      Text(
                        "First Name*",
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      const HeightSpace(),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(DPadding.half / 2),
                        ),
                        child: TextFormField(
                          controller: controller.fNameController,
                          onTap: (){setState(() {});},
                          onTapOutside: (s){setState(() {});},
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none),

                            errorText: controller.fNameController.text.isEmpty && controller.errorText.isNotEmpty? controller.errorText: null,
                            hintText: "Enter First Name ",
                            hintStyle: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      */
                    PrebookTextFiled(controller.fNameController, "First Name", controller, controller.fNameFocusNode, true),
                    PrebookTextFiled(controller.lNameController, "Last Name", controller, controller.lNameFocusNode, true),
                    PrebookTextFiled(controller.fatherNameController, "Father Name", controller, controller.fatherNameFocusNode , true),
                    PrebookTextFiled(controller.motherNameController, "Mother Name", controller, controller.motherNameFocusNode , true),
                    PrebookDropDown("Gender", controller, controller.gender, controller.genderList, controller.genderFocusNode, true, dropDownItemIndex++),
                    PrebookDropDown("Marital Status", controller, controller.maritalStatus, controller.maritalStatusList, controller.maritalStatusFocusNode, true, dropDownItemIndex++),
                    Container(
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
                        "Date of Birth*",
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      const HeightSpace(),
                      Container(
                        height: 45,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: DColors.white,
                          borderRadius:
                          BorderRadius.circular(DPadding.half / 2),
                        ),
                        child: TextButton.icon(
                            onPressed: () async {
                              controller.selectedDate = await pickDate(
                                context,

                                initialDate: DateTime(DateTime.now().year-15),
                                firstDate: DateTime(DateTime.now().year-65),
                                lastDate: DateTime(DateTime.now().year-15),


                                // DateTime.now().subtract(
                                //       const Duration(days: 365*15)),

                              );
                              controller.update();
                            },

                            icon: const Icon(Icons.calendar_month_rounded),
                            label:
                            Text(getDate(controller.selectedDate.year==DateTime.now().year?DateTime(DateTime.now().year-15) : controller.selectedDate))),
                      ),

                    ],),
                ),
                    PrebookDropDown("Blood Group", controller, controller.bloodGroup, controller.bloodGroupList,controller.bloodGroupFocusNode,  true, dropDownItemIndex++),
                    PrebookTextFiled(controller.phoneController, "Personal Phone Number", controller, controller.phoneFocusNode , true),
                    Container(
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
                            "Personal Email*",
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          const HeightSpace(),
                          Container(
                            decoration: BoxDecoration(
                              color: DColors.white,
                              borderRadius: BorderRadius.circular(DPadding.half),
                            ),
                            child: TextFormField(
                              controller: controller.emailController,
                              onTap: (){setState(() {});},
                              onChanged: (text){
                                setState(() {
                                  controller.validEmail = controller.isValidEmail(text);
                                });
                              },
                              //onTapOutside: (s){setState(() {});},
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.fromLTRB(5, 3, 3, 3),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none
                                ),

                                focusedBorder: controller.validEmail? null :

                                const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(color: Colors.redAccent)),

                                hintText: "Enter Email Address",
                                errorText: controller.emailController.text.isEmpty  && controller.validEmailError.isNotEmpty?controller.validEmailError:null,
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                              focusNode: controller.emailFocusNode,
                            ),
                          ),
                        ],),
                    ),
                    Container(
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
                            "Take a Selfie*",
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          const HeightSpace(),

                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                            ),

                            child:
                            InkWell(onTap: (){
                              _showPicker(context: context, controller: controller);
                            },child: const Row(children: [
                              Icon(Icons.add),
                              Text("Capture")
                            ],),),

                          ),
                          InkWell(onTap: (){
                            _showPicker(context: context, controller: controller);
                          },child: SizedBox(
                            height: 200.0,
                            width: 300.0,
                            child: controller.galleryFile == null
                                ? const Icon(Icons.photo)
                                : Center(child: Image.file(controller.galleryFile!)),
                          ),),
                        ],),
                    ),
                    PrebookTextFiled(controller.nidPassportController, "NID / Passport", controller, controller.nidPassportFocusNode , true),
/*
                      const HeightSpace(height: 25),

                      Text(
                        "Educational Qualification*",
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      const HeightSpace(),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius:
                          BorderRadius.circular(DPadding.half / 2),
                        ),
                        child: TextFormField(
                          controller: controller.educationalController,
                          onTap: (){setState(() {});},
                          onTapOutside: (s){setState(() {});},
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none),
                            hintText: "Enter Educational Qualification",
                            errorText: controller.educationalController.text.isEmpty && controller.errorText.isNotEmpty?controller.errorText:null,
                            hintStyle: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),*/
                    Container(
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
                            "Educational Qualification*",
                            style: TextStyle(color: Colors.grey.shade700),
                          ),

                          MultipleChipsChoice(),
                        ],),
                    ),
                    PrebookTextFiled(controller.emergencyContactName1Controller, "Emergency Contact Name 1 ", controller, controller.emergencyContactName1FocusNode , true),
                    PrebookTextFiled(controller.emergencyContactNumber1Controller, "Emergency Contact Number 1", controller, controller.emergencyContactNumber1FocusNode, true),
                    PrebookDropDown("Emergency Contact Relation 1", controller, controller.contactRelation, controller.contactRelationList, controller.contactRelationFocusNode,  true, dropDownItemIndex++),
                    //
                    // const HeightSpace(height: 25),
                    // Text(
                    //   "Emergency Contact Relation 1 *",
                    //   style: TextStyle(color: Colors.grey.shade700),
                    // ),
                    // const HeightSpace(),
                    //
                    //
                    //
                    // DropdownButton<String>(
                    //   isExpanded: true,
                    //   value: controller.contactRelation,
                    //   icon: const Icon(Icons.arrow_drop_down_outlined),
                    //   elevation: 16,
                    //   style: const TextStyle(color: DColors.black,),
                    //   autofocus: controller.contactRelation==controller.contactRelationList[0],
                    //   underline: Container(
                    //     height: controller.contactRelation==controller.contactRelationList[0]? controller.dropDownULHeight: 1,
                    //     color: controller.contactRelation==controller.contactRelationList[0]? controller.dropDownULColor: DColors.primary,
                    //   ),
                    //   onChanged: (String? value) {
                    //     // This is called when the user selects an item.
                    //     setState(() {
                    //       controller.contactRelation = value!;
                    //     });
                    //   },
                    //   items: controller.contactRelationList.map<DropdownMenuItem<String>>((String value) {
                    //     return DropdownMenuItem<String>(
                    //       value: value,
                    //       child: Text(value),
                    //     );
                    //   }).toList(),
                    // ),


                    // Container(
                    //   decoration: BoxDecoration(
                    //     color: Colors.grey.shade100,
                    //     borderRadius:
                    //     BorderRadius.circular(DPadding.half / 2),
                    //   ),
                    //   child: TextFormField(
                    //     controller: controller.emergencyContactRelation1Controller,
                    //     onTap: (){setState(() {});},
                    //     onTapOutside: (s){setState(() {});},
                    //     decoration: InputDecoration(
                    //       contentPadding: const EdgeInsets.symmetric(
                    //           horizontal: 8, vertical: 8),
                    //       border: const OutlineInputBorder(
                    //           borderSide: BorderSide.none),
                    //       errorText: controller.emergencyContactRelation1Controller.text.isEmpty && controller.errorText.isNotEmpty?controller.errorText:null,
                    //       hintText: "Enter Emergency Contact Relation 1",
                    //       hintStyle: TextStyle(
                    //         color: Colors.grey.shade600,
                    //         fontSize: 14,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    PrebookTextFiled(controller.emergencyContactName2Controller, "Emergency Contact Name 2", controller, controller.emergencyContactName2FocusNode, false),
                    PrebookTextFiled(controller.emergencyContactNumber2Controller, "Emergency Contact Number 2", controller, controller.emergencyContactNumber2FocusNode, false),
                    PrebookDropDown("Emergency Contact Relation 2", controller, controller.contactRelation2, controller.contactRelationList2, controller.contactRelation2FocusNode, false, dropDownItemIndex++),
/*
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius:
                      BorderRadius.circular(DPadding.half / 2),
                    ),
                    child: TextFormField(
                      controller: controller.emergencyContactRelation2Controller,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        hintText: "Enter Emergency Contact Relation 2",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
*/
                    PrebookTextFiled(controller.emergencyContactNumber2Controller, "Emergency Contact Number 2", controller, controller.emergencyContactNumber2FocusNode, false),
                    PrebookTextFiled(controller.currentAddressController, "Current address", controller, controller.currentAddressFocusNode, true),
                    PrebookTextFiled(controller.permanentAddressController, "Permanent address", controller, controller.permanentAddressFocusNode, true),
                    PrebookTextFiled(controller.previousCurrentCompanyNameController, "Previous / Current Company Name", controller, controller.previousCurrentCompanyNameFocusNode, true),
                    PrebookTextFiled(controller.currentDesignationController, "Current Designation", controller, controller.currentDesignationFocusNode, true),
                    PrebookTextFiled(controller.reasonAboutLeaveController, "Reason About Leave", controller, controller.reasonAboutLeaveFocusNode, true),
                    PrebookTextFiled(controller.workExperienceController, "Work Experience", controller, controller.workExperienceFocusNode, false),
                    const HeightSpace(height: 25),
                  ],
                ),),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Checkbox(

                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.resolveWith(controller.getColor),
                    value: controller.isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        controller.isChecked = value!;
                      });
                    },
                  ),
                  const Padding(padding: EdgeInsets.all(2.5),
                    child: Text("Social Media Link", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),),

                ],),


              Visibility( visible:controller.isChecked,
                  child: Padding(
                    padding: const EdgeInsets.all(2.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PrebookTextFiled(controller.facebookUrlController, "Facebook URL", controller, controller.facebookUrlFocusNode, false),
                        PrebookTextFiled(controller.linkedinUrlController, "Linkedin URL", controller, controller.linkedinUrlFocusNode, false),
                        PrebookTextFiled(controller.twitterUrlController, "Twitter URL", controller, controller.twitterUrlFocusNode, false),
                        PrebookTextFiled(controller.instagramUrlController, "Instagram URL", controller, controller.instagramUrlNode, false),
                        const HeightSpace(height: 25),
                      ],),
                  )),

              const HeightSpace(height: 25),
              const Text("N:B: Try to fill all field with your correct information, If you give any of wrong information then you have to suffer!!", style: TextStyle(color: DColors.highLight),),
              const HeightSpace(height: 25),


              MaterialButton(onPressed: (){
                controller.prebookEmployee(context);
                setState(() {});
              },
                padding: const EdgeInsets.all(5),
                color: DColors.card,
                shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0) ),

                child: const Text("Submit", style: TextStyle(fontSize: 16),),)
            ],
          )



          // Padding(
          //   padding: EdgeInsets.all(DPadding.half),
          //   child: SingleChildScrollView(
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //
          //
          //       ],
          //     ),
          //   ),
          // )
        );
      },
    );
  }
}




void _showPicker({required BuildContext context, required PrebookController controller}) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Photo Library'),
              onTap: () {
                getImage(ImageSource.gallery, controller);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () {
                getImage(ImageSource.camera, controller);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}

Future getImage(ImageSource img, PrebookController controller) async {
  final pickedFile = await controller.picker.pickImage(source: img);
  XFile? xfilePick = pickedFile;

      if (xfilePick != null) {
        controller.galleryFile = File(pickedFile!.path);
        controller.refresh();
      } else {
        print("Nothing is selected");
      }

}



